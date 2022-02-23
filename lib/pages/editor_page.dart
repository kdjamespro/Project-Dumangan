import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart' as mat;
import 'package:flutter/material.dart';

String fontSelector = "Calibri";
String fontViewer = "";

class EditorPage extends StatefulWidget {
  const EditorPage({Key? key}) : super(key: key);

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
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
                        child: Text(
                      'Preview',
                      style: TextStyle(
                          fontFamily: "$fontViewer",
                          color: mat.Colors.white,
                          fontSize: 200),
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
                            // FontButton(
                            //   fontTitle: 'Baskerville',
                            //   styleFont: "Baskerville",
                            // ),
                            // FontButton(
                            //   fontTitle: 'Calibri',
                            //   styleFont: "Calibri",
                            // ),
                            // FontButton(
                            //   fontTitle: 'Sweet Child',
                            //   styleFont: "SweetChild",
                            // ),
                            // FontButton(
                            //   fontTitle: 'Old English',
                            //   styleFont: "OldEnglish",
                            // ),
                            // Container(
                            //   child: mat.OutlinedButton(
                            //     style: mat.OutlinedButton.styleFrom(
                            //         side: BorderSide(
                            //             color: mat.Colors.white, width: 400),
                            //         padding:
                            //             EdgeInsets.fromLTRB(5, 0, 120, 10)),
                            //     child: Text(
                            //       "Inline 1",
                            //       style: TextStyle(color: mat.Colors.black),
                            //     ),
                            //     onPressed: () {
                            //       setState(() {
                            //         fontSelector = "Inline 1";
                            //         print("Clicked");
                            //       });
                            //     },
                            //   ),
                            // ),
                            FontChanger("Basekerville", "Baskerville"),
                            FontChanger("Calibri", "Calibri"),
                            FontChanger("Sweet Child", "SweetChild"),
                            FontChanger("Old English", "OldEnglish"),

                            //
                            // NewWidget(
                            //   fontTitle: "Baskerville",
                            //   styleFont: "Baskerville",
                            // ),
                          ],
                        ),
                        direction: ExpanderDirection
                            .down, // (optional). Defaults to ExpanderDirection.down
                        initiallyExpanded: false, // (false). Defaults to false
                      ),
                      // Text("$number"),
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

class NewWidget extends StatefulWidget {
  const NewWidget({
    Key? key,
    required this.fontTitle,
    required this.styleFont,
  }) : super(key: key);
  final String fontTitle;
  final String styleFont;

  @override
  State<NewWidget> createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: mat.OutlinedButton(
        style: mat.OutlinedButton.styleFrom(
            side: BorderSide(color: mat.Colors.white, width: 400),
            padding: EdgeInsets.fromLTRB(5, 0, 120, 10)),
        child: Text(
          widget.fontTitle,
          style:
              TextStyle(color: mat.Colors.black, fontFamily: widget.styleFont),
        ),
        onPressed: () {
          setState(() {
            String ako = widget.fontTitle;
            fontSelector = ako;
            print(ako);
          });
        },
      ),
    );
  }
}

class FontButton extends StatefulWidget {
  const FontButton({
    Key? key,
    required this.fontTitle,
    required this.styleFont,
  }) : super(key: key);
  final String fontTitle;
  final String styleFont;

  @override
  State<FontButton> createState() => _FontButtonState();
}

class _FontButtonState extends State<FontButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          fontSelector = (widget.fontTitle).toString();
        });
      },
      child: mat.OutlinedButton(
        style: mat.OutlinedButton.styleFrom(
            side: BorderSide(color: mat.Colors.white, width: 400),
            padding: EdgeInsets.fromLTRB(5, 0, 120, 10)),
        child: Text(
          widget.fontTitle,
          style:
              TextStyle(fontFamily: widget.styleFont, color: mat.Colors.black),
        ),
        onPressed: () {
          setState(() {
            fontSelector = (widget.fontTitle).toString();
            print(widget.fontTitle);
          });
        },
      ),
    );
  }
}
