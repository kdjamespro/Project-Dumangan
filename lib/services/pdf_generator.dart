import 'dart:io';
import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfGenerator {
  static generatePdf(Uint8List image, String path) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageTheme: const pw.PageTheme(
          margin: pw.EdgeInsets.all(1),
          orientation: pw.PageOrientation.landscape,
          pageFormat: PdfPageFormat.a4,
        ),
        build: (context) => pw.Row(children: [
          pw.Expanded(
            child: pw.Image(pw.MemoryImage(image)),
          )
        ]),
      ),
    );
    final pdfFile = File(path);
    await pdfFile.writeAsBytes(await pdf.save());
  }
}
