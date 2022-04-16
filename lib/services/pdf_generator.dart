import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart' as p;
import 'package:image/image.dart' as IMG;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:project_dumangan/database/database.dart';
import 'package:project_dumangan/model/canvas_controller.dart';
import 'package:printing/printing.dart';
import 'package:project_dumangan/model/selected_event.dart';
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

  static void generateReport(
      SelectedEvent event, List<ParticipantsTableData> absentees) async {
    final pdf = pw.Document();
    List<pw.Widget> absent = [];
    if (absentees.isNotEmpty) {
      absent.add(
          pw.Text('Absentees List', style: const pw.TextStyle(fontSize: 22)));
      absent.addAll(absentees
          .map((participant) => pw.Column(children: [
                pw.Row(children: [
                  pw.Text(participant.fullName),
                  pw.SizedBox(width: 40),
                  pw.Text(participant.email),
                  pw.Spacer(),
                ]),
                pw.SizedBox(
                  height: 10,
                )
              ]))
          .toList());
    } else {
      absent.add(pw.Text(
          'Your event has a perfect attendance! Congratulations!',
          style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold),
          textAlign: pw.TextAlign.center));
    }
    // List<pw.Row> absent = List.generate(
    //   100,
    //   (index) => pw.Row(
    //     children: [
    //       pw.Expanded(
    //         child: pw.Text(
    //           'JOSÉ PROTACIO RIZAL MERCADO Y ALONSO REALONDA@gmail.com',
    //         ),
    //       ),
    //       pw.SizedBox(width: 40),
    //       pw.Text(
    //         'JOSÉ PROTACIO RIZAL MERCADO Y ALONSO REALONDA@gmail.com',
    //       ),
    //       pw.Expanded(
    //         child: pw.Text(
    //           'JOSÉ PROTACIO RIZAL MERCADO Y ALONSO REALONDA@gmail.com',
    //         ),
    //       ),
    //       pw.Spacer(),
    //     ],
    //   ),
    // );
    const baseColor = PdfColors.cyan;
    pdf.addPage(
      pw.MultiPage(build: (pw.Context context) {
        return <pw.Widget>[
          pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Row(children: [
              pw.Text(
                event.eventName,
                style:
                    pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
              ),
            ], mainAxisAlignment: pw.MainAxisAlignment.center),
            pw.SizedBox(height: 15),
            pw.Text(
              'Event Date: ${event.eventDate}',
              style: const pw.TextStyle(fontSize: 16),
              textAlign: pw.TextAlign.left,
            ),
            pw.Text(
              event.eventLocation.trim().isEmpty
                  ? 'Event Location: No Data Provided'
                  : 'Event Location: ${event.eventLocation}',
              style: const pw.TextStyle(fontSize: 16),
              textAlign: pw.TextAlign.left,
            ),
            pw.SizedBox(height: 30),
            pw.Text(
              event.eventDescription.trim().isEmpty
                  ? 'Event Description: No Data Provided'
                  : 'Event Description:\n${event.eventDescription}',
              style: const pw.TextStyle(fontSize: 16),
              textAlign: pw.TextAlign.left,
            ),
            pw.SizedBox(height: 45),
            pw.Text(
              'Total Event Participants: ${event.eventParticipants}',
              style: const pw.TextStyle(fontSize: 14),
            ),
            pw.Text(
              'Total Event Absentees: ${event.eventAbsentees}',
              style: const pw.TextStyle(fontSize: 14),
            ),
            pw.SizedBox(height: 30),
          ]),
          ...absent
        ];
      }),
    );

    Directory? path = await p.getDownloadsDirectory();
    String filename = '${event.eventName}_reports.pdf'
        .replaceAll(RegExp(r'[~"#%&*:<>?/\\{|}]+'), '');
    filename = path!.path + '/' + filename;
    final pdfFile = File(filename);
    final Uri uri = Uri.file(filename);
    await pdfFile.writeAsBytes(await pdf.save());

    if (pdfFile.existsSync()) {
      if (!await launch(uri.toString())) {
        throw 'Could not launch $uri';
      }
    }
  }

  static Uint8List _resizeImage(Uint8List data, PageOrientation orientation) {
    int width = orientation.width.toInt();
    int height = orientation.height.toInt();

    Uint8List resizedData = data;
    IMG.Image img = IMG.decodeImage(data) as IMG.Image;

    IMG.Image resized;
    if (width < height) {
      resized = IMG.copyResize(img, width: width, height: height);
    } else {
      resized = IMG.copyResize(img, width: width, height: height);
    }
    resizedData = Uint8List.fromList(IMG.encodeJpg(resized));
    return resizedData;
  }
}
