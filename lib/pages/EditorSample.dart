import 'package:flutter/material.dart';

import 'editor/editor.dart';

class EditorSample extends StatelessWidget {
  const EditorSample({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('parent build');
    return const Editor();
  }
}
