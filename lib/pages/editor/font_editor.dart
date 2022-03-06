import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mat;
import 'package:project_dumangan/model/fontstyle_controller.dart';
import 'package:provider/provider.dart';
import 'package:text_style_editor/text_style_editor.dart';

List<String> fonts = ['Baskerville', 'Calibri', 'SweetChild', 'OldEnglish'];

class FontEditor extends StatefulWidget {
  FontEditor({Key? key, required this.controller}) : super(key: key);
  FontStyleController controller;

  @override
  _FontEditorState createState() => _FontEditorState();
}

class _FontEditorState extends State<FontEditor> {
  late TextStyle textStyle;
  late TextAlign textAlign;
  bool edit = false;

  @override
  void initState() {
    textStyle = const TextStyle(
      fontSize: 15,
      color: mat.Colors.black,
      fontFamily: 'Calibri',
    );
    textAlign = TextAlign.left;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextStyleEditor(
        fonts: fonts,
        textStyle: textStyle,
        textAlign: textAlign,
        initialTool: EditorToolbarAction.fontFamilyTool,
        onTextAlignEdited: (align) {
          setState(() {
            textAlign = align;
          });
        },
        onTextStyleEdited: (style) {
          setState(() {
            Provider.of<FontStyleController>(context, listen: false)
                .changeFontStyle(textStyle.merge(style));
          });
        },
        onCpasLockTaggle: (caps) {
          print(caps);
        },
      ),
    );
  }
}
