import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:excel/excel.dart';
import 'package:path/path.dart' as p;

class FileParser {
  void parseFile(File file) {
    if (_isCsv(file)) {
      _parse_csv(file);
    } else if (_isXlsx(file)) {
      _parse_xlsx(file);
    }
  }

  Future<List> _parse_csv(file) async {
    final input = File(file.path).openRead();
    final data = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    print(data);
    return data;
  }

  void _parse_xlsx(file) async {
    var bytes = File(file.path).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);
    print(excel.getDefaultSheet());
    List l = excel.tables[excel.getDefaultSheet()]?.rows ?? [];
    for (var rows in l) {
      print(rows);
      //print(table); //sheet Name
    }
  }

  bool _isCsv(File file) {
    return p.extension(file.path) == ".csv";
  }

  bool _isXlsx(File file) {
    return p.extension(file.path) == ".xlsx";
  }

  List _getHeaders(List data) {
    return data[0];
  }
}

// get the headers
// get the index of the columns needed for the data
// 