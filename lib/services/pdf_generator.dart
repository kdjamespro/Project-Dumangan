import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart' as p;
import 'package:image/image.dart' as IMG;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:project_dumangan/database/database.dart';
import 'package:project_dumangan/model/canvas_controller.dart';
import 'package:printing/printing.dart';
import 'package:project_dumangan/model/selected_event.dart';
import 'package:project_dumangan/services/cipher.dart';
import 'package:url_launcher/url_launcher.dart';

class PdfGenerator {
  static generatePdf(
      Uint8List image, String path, PageOrientation orientation) async {
    final stopwatch = Stopwatch()..start();
    final pdf = pw.Document();
    PdfPageFormat pageFormat = _findPaperSize(orientation);
    pw.PageOrientation pageOrientation = _findOrientation(orientation);
    // final cert = _resizeImage(image, orientation);
    // print('Image Resizing executed in ${stopwatch.elapsed.inSeconds}');
    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        orientation: pageOrientation,
        build: (pw.Context context) => pw.FullPage(
          ignoreMargins: true,
          child: pw.Image(
            pw.MemoryImage(image),
            fit: pw.BoxFit.fill,
            dpi: 300,
          ),
        ),
      ),
    );
    final pdfFile = File(path);
    await pdfFile.writeAsBytes(await pdf.save());
    print('Cert Generation executed in ${stopwatch.elapsed.inSeconds}');
  }

  static PdfPageFormat _findPaperSize(PageOrientation orientation) {
    if (orientation == PageOrientation.a4Landscape) {
      return PdfPageFormat.a4.landscape;
    } else if (orientation == PageOrientation.a4Portrait) {
      return PdfPageFormat.a4.portrait;
    } else if (orientation == PageOrientation.legalLandscape) {
      return PdfPageFormat.legal.landscape;
    } else if (orientation == PageOrientation.legalPortrait) {
      return PdfPageFormat.legal.portrait;
    } else if (orientation == PageOrientation.letterLandscape) {
      return PdfPageFormat.letter.landscape;
    } else {
      return PdfPageFormat.letter.portrait;
    }
  }

  static Future<Uint8List?> getPdfThumbnail(String path) async {
    final file = File(path);
    if (file.existsSync()) {
      await for (var page
          in Printing.raster(file.readAsBytesSync(), pages: [0], dpi: 72)) {
        final image = await page.toPng(); // ...or page.toPng()
        return image;
      }
    }
    return null;
  }

  static pw.PageOrientation _findOrientation(PageOrientation orientation) {
    if (orientation == PageOrientation.a4Landscape ||
        orientation == PageOrientation.legalLandscape ||
        orientation == PageOrientation.letterLandscape) {
      return pw.PageOrientation.landscape;
    } else {
      return pw.PageOrientation.portrait;
    }
  }

  static Future<void> generateReport(
      SelectedEvent event, List<ParticipantsTableData> absentees) async {
    final pdf = pw.Document();
    List<pw.Widget> absent = [];
    final marginSide = pw.EdgeInsets.only(
        right: PdfPageFormat.a4.marginRight, left: PdfPageFormat.a4.marginLeft);
    if (absentees.isNotEmpty) {
      absent.add(pw.Container(
        margin: marginSide,
        child: pw.Text('Absentees List',
            style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center),
      ));
    } else {
      pw.SizedBox(height: 40);
      absent.add(pw.Container(
        margin: marginSide,
        child: pw.Text(
            'Your event has a perfect attendance!\n\nCongratulations!',
            style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center),
      ));
    }
    final banner = (await rootBundle.load('assets/images/banner.png'))
        .buffer
        .asUint8List();
    const double textFontSize = 18;
    pdf.addPage(
      pw.MultiPage(
          build: (pw.Context context) {
            return <pw.Widget>[
              pw.Container(
                margin: marginSide,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        event.eventName.toUpperCase(),
                        style: pw.TextStyle(
                            fontSize: 40, fontWeight: pw.FontWeight.bold),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.SizedBox(height: 15),
                      pw.Text(
                        'Event Date: ${event.eventDate}',
                        style: const pw.TextStyle(fontSize: textFontSize),
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        event.eventLocation.trim().isEmpty
                            ? 'Event Location: No Data Provided'
                            : 'Event Location: ${event.eventLocation}',
                        style: const pw.TextStyle(fontSize: textFontSize),
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.SizedBox(height: 30),
                      pw.Text(
                        event.eventDescription.trim().isEmpty
                            ? 'Event Description:\nNo Data Provided'
                            : 'Event Description:\n${event.eventDescription}',
                        style: const pw.TextStyle(fontSize: textFontSize),
                        textAlign: pw.TextAlign.left,
                      ),
                      pw.SizedBox(height: 30),
                      pw.Text(
                        'Total Event Participants: ${event.eventParticipants}',
                        style: const pw.TextStyle(fontSize: textFontSize),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'Total Event Absentees: ${event.eventAbsentees}',
                        style: const pw.TextStyle(fontSize: textFontSize),
                      ),
                      pw.SizedBox(height: 30),
                    ]),
              ),
              ...absent,
              absentees.isNotEmpty
                  ? _absentTable(context, absentees)
                  : pw.Container(),
            ];
          },
          header: (pw.Context context) {
            return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 10.0),
                child: pw.Image(
                  pw.MemoryImage(banner),
                ));
          },
          footer: (pw.Context context) {
            return _pdfFooter(context);
          },
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(0)),
    );

    Directory? path = await p.getDownloadsDirectory();
    String filename = '${event.eventName}_reports.pdf'
        .replaceAll(RegExp(r'[~"#%&*:<>?/\\{|}]+'), '');
    filename = path!.path + '/' + filename;
    final Uri uri = Uri.file(filename);
    final pdfFile = File(filename);
    await pdfFile.writeAsBytes(await pdf.save());
    if (pdfFile.existsSync()) {
      if (!await launch(uri.toString())) {
        throw 'Could not launch $uri';
      }
    }
  }

  static pw.Widget _pdfFooter(pw.Context context) {
    return pw.Container(
        margin: pw.EdgeInsets.only(
            left: PdfPageFormat.a4.marginLeft,
            right: PdfPageFormat.a4.marginRight,
            top: 8.0,
            bottom: 8.0),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          children: [
            pw.Text(
              'Page ${context.pageNumber}/${context.pagesCount}',
              style: const pw.TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ));
  }

  static pw.Widget _absentTable(
      pw.Context context, List<ParticipantsTableData> absentees) {
    const tableHeaders = [
      'Name',
      'Email',
    ];

    List absents = absentees
        .map((e) => [Cipher.decryptAES(e.fullName), Cipher.decryptAES(e.email)])
        .toList();
    const PdfColor baseColor = PdfColors.blue800;
    const PdfColor accentColor = PdfColors.blueGrey900;
    return pw.Container(
      margin: pw.EdgeInsets.symmetric(horizontal: PdfPageFormat.a4.marginLeft),
      child: pw.Table.fromTextArray(
        border: null,
        headerAlignment: pw.Alignment.center,
        cellAlignment: pw.Alignment.centerLeft,
        headerDecoration: const pw.BoxDecoration(
          borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
          color: baseColor,
        ),
        headerHeight: 25,
        cellHeight: 40,
        cellAlignments: {
          0: pw.Alignment.centerLeft,
          1: pw.Alignment.centerLeft,
        },
        headerStyle: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 20,
          fontWeight: pw.FontWeight.bold,
        ),
        cellStyle: const pw.TextStyle(
          fontSize: 14,
        ),
        rowDecoration: const pw.BoxDecoration(
          border: pw.Border(
            bottom: pw.BorderSide(
              color: accentColor,
              width: .5,
            ),
          ),
        ),
        headers: List<String>.generate(
          tableHeaders.length,
          (col) => tableHeaders[col],
        ),
        data: List<List<String>>.generate(
          absents.length,
          (row) => List<String>.generate(
            tableHeaders.length,
            (col) => absents[row][col],
          ),
        ),
      ),
    );
  }
}
