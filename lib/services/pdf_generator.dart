import 'dart:core';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart' as p;
import 'package:image/image.dart' as IMG;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
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

  static void generateReport(SelectedEvent event) async {
    final pdf = pw.Document();

    final attedanceData = [
      ['Event Participants', event.eventParticipants],
      ['Event Absentees', event.eventAbsentees]
    ];
    const baseColor = PdfColors.cyan;
    final chart1 = pw.Chart(
      left: pw.Container(
        alignment: pw.Alignment.topCenter,
        margin: const pw.EdgeInsets.only(right: 2, top: 5),
        child: pw.Transform.rotateBox(
          angle: pi / 2,
          child: pw.Text('Participants'),
        ),
      ),
      overlay: pw.ChartLegend(
        position: const pw.Alignment(-.7, 1),
        decoration: pw.BoxDecoration(
          color: PdfColors.white,
          border: pw.Border.all(
            color: PdfColors.black,
            width: .5,
          ),
        ),
      ),
      grid: pw.CartesianGrid(
        xAxis: pw.FixedAxis.fromStrings(
          List<String>.generate(attedanceData.length,
              (index) => attedanceData[index][0] as String),
          marginStart: 15,
          marginEnd: 15,
          ticks: true,
        ),
        yAxis: pw.FixedAxis(
          [0, 1, 2, 3, 4, 5, 10],
          format: (v) => '$v',
          divisions: true,
        ),
      ),
      datasets: [
        pw.BarDataSet(
          color: PdfColors.blue100,
          legend: 'Participants',
          width: 20,
          offset: -10,
          borderColor: baseColor,
          data: [pw.LineChartValue(0, event.eventParticipants.toDouble())],
        ),
        pw.BarDataSet(
            color: PdfColors.amber100,
            legend: 'Absentees',
            width: 20,
            offset: 10,
            borderColor: PdfColors.amber,
            data: [pw.LineChartValue(1, 8)]),
      ],
    );
    pdf.addPage(
      pw.Page(build: (pw.Context context) {
        return pw.Column(children: [
          pw.Row(children: [
            pw.Text(
              event.eventName,
              style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
            ),
          ], mainAxisAlignment: pw.MainAxisAlignment.center),
          pw.SizedBox(height: 15),
          pw.Text(
            event.eventDate,
            style: const pw.TextStyle(fontSize: 16),
          ),
          pw.SizedBox(height: 30),
          pw.Row(children: [
            pw.Text(
              'Total Event Participants: ${event.eventParticipants}',
              style: const pw.TextStyle(fontSize: 14),
            ),
            pw.Spacer(),
            pw.Text(
              'Total Event Absentees: ${event.eventAbsentees}',
              style: const pw.TextStyle(fontSize: 14),
            ),
          ]),
          pw.SizedBox(height: 20),
          pw.Column(children: [
            pw.Text('Absentees List', style: const pw.TextStyle(fontSize: 22)),
            pw.Table(
              children: [
                pw.TableRow(
                  children: [
                    pw.Center(child: pw.Text('Name')),
                    pw.Center(child: pw.Text('Email')),
                  ],
                ),
                pw.TableRow(children: [
                  pw.Center(child: pw.Text('Tony')),
                  pw.Center(child: pw.Text('Stark')),
                ]),
                pw.TableRow(children: [
                  pw.Center(child: pw.Text('Peter')),
                  pw.Center(child: pw.Text('Parker')),
                ]),
              ],
              border: pw.TableBorder.all(),
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
            ),
          ])
        ]);
      }),
    );
    String filename = '';
    Directory? path = await p.getDownloadsDirectory();
    if (path != null) {
      filename = path.path;
    }
    filename += 'reports.pdf';
    print(filename);
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
