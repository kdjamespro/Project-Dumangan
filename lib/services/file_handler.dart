import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
// ignore: import_of_legacy_library_into_null_safe
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
        allowedExtensions: ['csv']);
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
    return directory ?? '';
  }

  Future<List<File>> getSavedTemplates() async {
    List<File> templates = [];
    final Directory templateDirectory = await getTemplateDirectory();
    final List files = templateDirectory.listSync();
    for (FileSystemEntity file in files) {
      templates.add(File(file.path));
    }

    return templates;
  }

  Future<bool> saveTemplate(File image, Directory templateDirectory) async {
    if (!image.existsSync()) {
      return false;
    }
    var fileName = p.basename(image.path);
    var tempFile = p.join(templateDirectory.path, fileName);
    final File templateImage = image.copySync(tempFile);
    return templateImage.existsSync();
  }

  Future<bool> deleteTemplate(File image) async {
    try {
      if (await image.exists()) {
        await image.delete();
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
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
}
