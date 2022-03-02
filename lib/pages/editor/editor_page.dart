import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;
import 'package:project_dumangan/model/fontstyle_controller.dart';
import 'package:provider/provider.dart';

String fontSelector = "Calibri";
String fontViewer = "";

class EditorPage extends StatefulWidget {
  const EditorPage({Key? key}) : super(key: key);

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  TextStyle textStyle = const TextStyle(
    fontSize: 15,
    color: Colors.black,
    fontFamily: 'Calibri',
  );
  FontStyleController style = FontStyleController();
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      home: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ScaffoldPage(
          content: Row(
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
                      style: Provider.of<FontStyleController>(context,
                              listen: true)
                          .textStyle,
                    ))),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: const [
                      Text('Tools'),
                      SizedBox(
                        height: 30,
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
}
