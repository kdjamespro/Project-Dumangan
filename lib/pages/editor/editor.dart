import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:project_dumangan/services/file_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart' as mat;
import 'draggable_text.dart';

String fontSelector = "Calibri";
String fontViewer = "";

class Editor extends StatefulWidget {
  const Editor({Key? key}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  File image = File('');

  Image? setImage(File image) {
    return image.existsSync()
        ? Image.file(
            image,
            fit: BoxFit.fill,
          )
        : null;
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
                child: Stack(
                  children: [
                    Positioned(
                      child: AspectRatio(
                        aspectRatio: 1.6471 / 1,
                        child: Container(
                          margin: EdgeInsets.all(16),
                          color: Colors.white,
                          child: setImage(image),
                        ),
                      ),
                    ),
                    DraggableText(),
                  ],
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
                      child: Text('Upload Image'),
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
                        context.read<FileHandler>().saveFile();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Flexible(
        //   flex: 1,
        //   child: Container(
        //     color: Colors.white,
        //     child: Column(children: [
        //       Button(
        //         child: Text('Upload Image'),
        //         onPressed: () async {
        //           final picked =
        //               await context.read<FileHandler>().openImageFile();
        //           if (picked.existsSync()) {
        //             image = picked;
        //           }
        //           setState(() {
        //             setImage(image);
        //           });
        //         },
        //       ),
        //       Button(
        //         child: Text('Save Image'),
        //         onPressed: () async {
        //           context.read<FileHandler>().saveFile();
        //         },
        //       ),
        //     ]),
        //   ),
        // ),
      ],
    );
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
}
