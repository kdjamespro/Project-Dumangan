import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;
import 'package:path/path.dart' as Path;
import 'package:project_dumangan/services/file_handler.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import 'draggable_text.dart';

String fontSelector = "Calibri";
String fontViewer = "";

class Editor extends StatefulWidget {
  const Editor({Key? key}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  ScreenshotController screenshotController = ScreenshotController();

  File image = File('');
  DraggableText text = DraggableText();

  Image? setImage(File image) {
    return image.existsSync()
        ? Image.file(
            image,
            fit: BoxFit.fill,
          )
        : null;
  }

  Container FontChanger(font, style) {
    final String fontTitle = font;
    final String styleFont = style;
    return Container(
      child: mat.OutlinedButton(
        style: mat.OutlinedButton.styleFrom(
            side: BorderSide(color: mat.Colors.white, width: 400),
            padding: EdgeInsets.fromLTRB(5, 0, 120, 10)),
        child: Text(
          fontTitle,
          style: TextStyle(color: mat.Colors.black, fontFamily: styleFont),
        ),
        onPressed: () {
          setState(() {
            fontSelector = fontTitle;
            fontViewer = styleFont;
            print(fontSelector);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 3,
          child: Column(
            children: [
              Expanded(
                child: Screenshot(
                  controller: screenshotController,
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: [
                      Positioned(
                        child: AspectRatio(
                          aspectRatio: 1.6471 / 1,
                          child: Container(
                            margin: const EdgeInsets.all(16),
                            color: Colors.white,
                            child: setImage(image),
                          ),
                        ),
                      ),
                      Positioned.fill(
                          child:
                              Align(alignment: Alignment.center, child: text))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 300,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Tools'),
                SizedBox(
                  height: 30,
                ),
                Expander(
                  header: Text("$fontSelector"),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FontChanger("Basekerville", "Baskerville"),
                      FontChanger("Calibri", "Calibri"),
                      FontChanger("Sweet Child", "SweetChild"),
                      FontChanger("Old English", "OldEnglish"),
                    ],
                  ),
                  direction: ExpanderDirection
                      .down, // (optional). Defaults to ExpanderDirection.down
                  initiallyExpanded: false, // (false). Defaults to false
                ),
                // Text("$number"),

                Row(
                  children: [
                    Button(
                      child: const Text('Upload Image'),
                      onPressed: () async {
                        final picked =
                            await context.read<FileHandler>().openImageFile();
                        if (picked.existsSync()) {
                          image = picked;
                        }
                        setState(() {
                          setImage(image);
                        });
                      },
                    ),
                    Button(
                      child: Text('Save Image'),
                      onPressed: () async {
                        String path =
                            await context.read<FileHandler>().saveFile();
                        String name = Path.basename(path);
                        if (path != '') {
                          screenshotController.captureAndSave(
                              Path.dirname(path),
                              pixelRatio: 3.0,
                              fileName: name);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
