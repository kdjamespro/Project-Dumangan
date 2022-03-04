import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as mat;
import 'package:flutter/material.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:project_dumangan/services/file_handler.dart';
import 'package:provider/provider.dart';
import 'dart:io';

String fontSelector = "Calibri";
String fontViewer = "";
double _verticalSlider = 0;
double _horizontalSlider = 0;

class EditorPage extends StatefulWidget {
  const EditorPage({Key? key}) : super(key: key);

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
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
    return FluentApp(
      debugShowCheckedModeBanner: false,
      home: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Scaffold(
          body: Row(
            children: [
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        color: mat.Colors
                            .blueAccent, //remove color to make it transpatent
                        border: Border.all(
                            style: BorderStyle.solid, color: mat.Colors.white)),
                    child: Center(
                        child: Padding(
                      padding: EdgeInsets.only(
                          top: _verticalSlider, left: _horizontalSlider),
                      child: Text(
                        'Preview',
                        style: TextStyle(
                            fontFamily: "$fontViewer",
                            color: mat.Colors.white,
                            fontSize: 200),
                      ),
                    ))),
              ),
              Container(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
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

                      SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        child: Text("Vertical Slider"),
                        height: 40,
                      ),
                      SizedBox(
                        // The default width is 200.
                        // The slider does not have its own widget, so you have to add it yourself.
                        // The slider always try to be as big as possible
                        width: 200,
                        child: fluent.Slider(
                          max: 300,
                          value: _verticalSlider,
                          onChanged: (v) => setState(() => _verticalSlider = v),
                          // Label is the text displayed above the slider when the user is interacting with it.
                          label: '${_verticalSlider.toInt()}',
                        ),
                      ),

                      SizedBox(
                        height: 40,
                      ),
                      SizedBox(
                        child: Text("Horizontal Slider"),
                        height: 40,
                      ),
                      SizedBox(
                        // The default width is 200.
                        // The slider does not have its own widget, so you have to add it yourself.
                        // The slider always try to be as big as possible
                        width: 200,
                        child: fluent.Slider(
                          max: 300,
                          value: _horizontalSlider,
                          onChanged: (v) =>
                              setState(() => _horizontalSlider = v),
                          // Label is the text displayed above the slider when the user is interacting with it.
                          label: '${_horizontalSlider.toInt()}',
                        ),
                      ),
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
