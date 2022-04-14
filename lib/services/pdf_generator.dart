import 'dart:core';
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as IMG;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:project_dumangan/model/canvas_controller.dart';
import 'package:printing/printing.dart';

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
