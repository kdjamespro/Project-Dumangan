import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

class FileParser {
  void parseFile(PlatformFile file) {
    if (file.extension == 'csv') {
      _parse_csv(file);
    } else if (file.extension == 'xslx') {
      _parse_xlsx(file);
    }
  }

  Future<List> _parse_csv(file) async {
    final input = File(file.path).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    return fields;
  }

  void _parse_xlsx(file) async {
    var bytes = File(file.path).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    for (var table in excel.tables.keys) {
      print(table); //sheet Name
    }
  }
}
