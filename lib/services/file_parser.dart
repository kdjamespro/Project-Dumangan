import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:excel/excel.dart';
import 'package:path/path.dart' as p;

class FileParser {
  Future<void> parseFile(File file) async {
    if (_isCsv(file)) {
      await _parseCsv(file);
    }
  }

  Future<List<dynamic>> _parseCsv(file) async {
    List output = [];
    final input = File(file.path).openRead();
    final data = await input
        .transform(utf8.decoder)
        .transform(const CsvToListConverter())
        .toList();
    List headers = _getHeaders(data);
    _removeBlankRows(data);
    List index = _getDataIndex(headers);
    // _getNeededFields(data, index);
    // print(data);
    output.add(headers);
    output.add(data);
    data.removeAt(0);
    print(output[1]);
    return output;
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

  List _getDataIndex(List headers) {
    List index = [];
    for (int i = 0; i < headers.length; i++) {
      if (_isNeeded(headers[i])) {
        index.add(i);
      }
    }
    return index;
  }

  void _removeBlankRows(List data) {
    data.removeWhere((rows) => rows.every((field) => field == ''));
  }

  void _getNeededFields(List data, List columnIndex) {
    for (var row in data) {
      row.removeWhere((field) => !columnIndex.contains(row.indexOf(field)));
    }
  }

  bool _isNeeded(String header) {
    return header.contains(RegExp(r'first name', caseSensitive: false)) ||
        header.contains(RegExp(r'last name', caseSensitive: false));
  }
}


// get the headers
// get the index of the columns needed for the data
// 