import 'dart:io';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '/services/file_handler.dart';

class ArchiveList extends ChangeNotifier {
  late List<File> _archivedImage;
  late final Directory _archivePath;
  late FileHandler handler;

  ArchiveList._create() {
    handler = FileHandler(platform: FilePicker.platform);
  }

  static Future<ArchiveList> create() async {
    var archiveList = ArchiveList._create();
    archiveList._archivePath = await archiveList.handler.getTemplateDirectory();
    archiveList._archivedImage = await archiveList.handler.getSavedTemplates();

    return archiveList;
  }

  List<File> get archivedImage => _archivedImage;
  Directory get archivePath => _archivePath;

  Future<bool> addImage(File image) async {
    bool saved = await handler.saveTemplate(image, _archivePath);
    _archivedImage = await handler.getSavedTemplates();
    notifyListeners();
    return saved;
  }
}
