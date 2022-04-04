import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/model/archive_list.dart';
import 'editor/editor.dart';

class EditorSample extends StatelessWidget {
  const EditorSample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ArchiveList.create(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ChangeNotifierProvider(
              create: (context) => snapshot.data as ArchiveList,
              child: const Editor(),
            );
          }
          return Container();
        });
  }
}
