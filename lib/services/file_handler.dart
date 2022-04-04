import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

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
      return File('');
    }
    final file = result.files.first;
    return File(file.path);
  }

  Future<String> saveFile() async {
    String? outputFile = await platform.saveFile(
        dialogTitle: 'Save As',
        type: FileType.custom,
        allowedExtensions: ['pdf']);

    if (outputFile == null) {
      return '';
    }
    return outputFile;
  }

  Future<String> selectDirectory() async {
    String? directory = await platform.getDirectoryPath();
    print(directory);
    return directory ?? '';
  }

  Future<List<File>> getSavedTemplates() async {
    List<File> templates = [];
    final Directory templateDirectory = await getTemplateDirectory();
    final List files = templateDirectory.listSync();
    print("IsFileEmpty? ${files.isEmpty}");
    for (FileSystemEntity file in files) {
      templates.add(File(file.path));
    }

    return templates;
  }

  Future<bool> saveTemplate(File image, Directory templateDirectory) async {
    print(image.existsSync());
    if (!image.existsSync()) {
      return false;
    }
    var fileName = p.basename(image.path);
    var tempFile = p.join(templateDirectory.path, fileName);
    final File templateImage = image.copySync(tempFile);
    return templateImage.existsSync();
  }

  Future<Directory> getTemplateDirectory() async {
    final root = await getApplicationDocumentsDirectory();
    final templateFolder = p.join(root.path, 'templates');
    bool tempFolderExists = Directory(templateFolder).existsSync();
    if (!tempFolderExists) {
      Directory(templateFolder).createSync();
    }
    return Directory(templateFolder);
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
