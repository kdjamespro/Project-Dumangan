import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:path/path.dart' as p;

class FileParser {
  Future<Map<String, List>> parseFile(File file) async {
    if (_isCsv(file)) {
      return await _parseCsv(file);
    }
    return {};
  }

  Future<Map<String, List>> _parseCsv(file) async {
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
    data.removeAt(0);
    output.add(headers);
    output.add(data);
    Map<String, List> col = {};
    for (int i = 0; i < headers.length; i++) {
      List contents = [];
      for (var row in data) {
        contents.add(row[i]);
      }
      col.putIfAbsent(headers[i], () => contents);
    }
    return col;
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