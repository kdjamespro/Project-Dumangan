import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart' as mat;
import 'package:flutter/material.dart';

String fontSelector = "Calibri";
String fontViewer = "";
double _verticalScroll = 0;
double _horizontalScroll = 0;

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
                    child: Expanded(
                      child: Center(
                          child: Padding(
                        padding: EdgeInsets.only(
                            top: _verticalScroll, left: _horizontalScroll),
                        child: Text(
                          "Preview",
                          style: TextStyle(
                              fontFamily: "$fontViewer",
                              color: mat.Colors.white,
                              fontSize: 200),
                        ),
                      )),
                    )),
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
                        width: 200,
                        child: fluent.Slider(
                          max: 300,
                          value: _verticalScroll,
                          onChanged: (v) => setState(() => _verticalScroll = v),
                          label: '${_verticalScroll.toInt()}',
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: fluent.Slider(
                          max: 300,
                          value: _horizontalScroll,
                          onChanged: (v) =>
                              setState(() => _horizontalScroll = v),
                          label: '${_horizontalScroll.toInt()}',
                        ),
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
