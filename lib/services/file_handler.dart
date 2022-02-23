import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

class FileHandler {
  bool valid = false;
  var platform;
  FileHandler({required this.platform});
  Future<File> openCsvFile() async {
    final result = await platform.pickFiles(
        dialogTitle: 'Please select a File:',
        type: FileType.custom,
        allowedExtensions: ['csv', 'xlsx']);
    if (result == null) {
      print('No Files Picked');
      return File('');
    }
    final file = result.files.first;
    return File(file.path);
  }

  Future<File> openImageFile() async {
    final result = await platform.pickFiles(
        dialogTitle: 'Please select a File:',
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png']);
    if (result == null) {
      print('No Files Picked');
      return File('');
    }
    final file = result.files.first;
    return File(file.path);
  }

  Future<String?> saveFile() async {
    String? outputFile = await FilePicker.platform.saveFile(
      dialogTitle: 'Save As',
    );

    if (outputFile == null) {
      return '';
    }
    return outputFile;
  }

  Future<List> _parsecsv(file) async {
    final input = File(file.path).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    return fields;
  }

  void _parse_excel(file) async {
    var bytes = File(file.path).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    for (var table in excel.tables.keys) {
      print(table); //sheet Name
    }
  }
}
