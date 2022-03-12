import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as Path;
import 'package:project_dumangan/pages/editor/resizable_widget.dart';
import 'package:project_dumangan/services/file_handler.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

String fontSelector = "Calibri";
String fontViewer = "";
String selectedFont = "Lato";
String styleFontStyle = "";
String styleFontColor = "";
double _styleFontSize = 10;
Color fontColorPicker = Color(0xff443a49);
FontWeight fontWeightSelector = FontWeight.normal;

class Editor extends StatefulWidget {
  const Editor({Key? key}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

final autoSuggestBox = TextEditingController();

class _EditorState extends State<Editor> {
  ScreenshotController screenshotController = ScreenshotController();
  Color color = Colors.red;
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

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

  final values = [
    'Thin',
    'Light',
    'Regular',
    'Medium',
    'SemiBold',
    'Bold',
    'ExtraBold',
    'Black'
  ];
  String? comboBoxValue;
  @override
  Widget build(BuildContext context) {
    const double splitButtonHeight = 25.0;
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
                      Container(child: DraggableText()),
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Tools'),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Font style selector'),
                ),
                AutoSuggestBox(
                  cursorColor: mat.Colors.blue,
                  highlightColor: mat.Colors.black,
                  clearButtonEnabled: true,
                  trailingIcon: Icon(FluentIcons.search),
                  placeholder: "Pick a Font style",
                  controller: autoSuggestBox,
                  items: [
                    'Abhaya Libre',
                    'Abril Fatface',
                    'Alegreya',
                    'Alegreya Sans',
                    'Amatic SC',
                  ],
                  onSelected: (text) {
                    print(text);
                    setState(() {
                      selectedFont = text;
                    });
                  },
                ),
                // Text("$number"),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Font size selector'),
                ),
                SizedBox(
                  // The default width is 200.
                  // The slider does not have its own widget, so you have to add it yourself.
                  // The slider always try to be as big as possible
                  width: 250,
                  child: Slider(
                    min: 10,
                    max: 100,
                    value: _styleFontSize,
                    onChanged: (v) => setState(() => _styleFontSize = v),
                    label: '${_styleFontSize.toInt()}',
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                            color: fontColorPicker,
                            borderRadius: BorderRadius.circular(5)),
                        height: 25,
                        width: 25,
                      ),
                      onTap: () {
                        pickColor(context);
                        print('button pressed');
                      },
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Button(
                        child: Text('Open color picker'),
                        // Set onPressed to null to disable the button
                        onPressed: () {
                          pickColor(context);
                          print('button pressed');
                        })
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Font weight selector'),
                ),
                SizedBox(
                  width: 300,
                  child: Combobox<String>(
                    placeholder: Text('Selected list item'),
                    isExpanded: true,
                    items: values
                        .map((e) => ComboboxItem<String>(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    value: comboBoxValue,
                    onChanged: (value) {
                      // print(value);
                      if (value != null) setState(() => comboBoxValue = value);
                      if (value == "Thin") {
                        setState(() {
                          fontWeightSelector = FontWeight.w100;
                        });
                      }
                      if (value == "Light") {
                        setState(() {
                          fontWeightSelector = FontWeight.w300;
                        });
                      }
                      if (value == "Regular") {
                        setState(() {
                          fontWeightSelector = FontWeight.w400;
                        });
                      }
                      if (value == "Medium") {
                        setState(() {
                          fontWeightSelector = FontWeight.w500;
                        });
                      }
                      if (value == "SemiBold") {
                        setState(() {
                          fontWeightSelector = FontWeight.w600;
                        });
                      }
                      if (value == "Bold") {
                        setState(() {
                          fontWeightSelector = FontWeight.w700;
                        });
                      }
                      if (value == "ExtraBold") {
                        setState(() {
                          fontWeightSelector = FontWeight.w800;
                        });
                      }
                      if (value == "Black") {
                        setState(() {
                          fontWeightSelector = FontWeight.w900;
                        });
                      }
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Alignment selector'),
                ),
                SizedBox(
                  width: 300,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropDownButton(
                      leading: const Icon(FluentIcons.align_left),
                      title: const Text('Alignment'),
                      items: [
                        DropDownButtonItem(
                          title: const Text('Left'),
                          leading: const Icon(FluentIcons.align_left),
                          onTap: () => debugPrint('left'),
                        ),
                        DropDownButtonItem(
                          title: const Text('Center'),
                          leading: const Icon(FluentIcons.align_center),
                          onTap: () => debugPrint('center'),
                        ),
                        DropDownButtonItem(
                          title: const Text('Right'),
                          leading: const Icon(FluentIcons.align_right),
                          onTap: () => debugPrint('right'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 200,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Widget buildColorPicker() => ColorPicker(
        pickerColor: color,
        onColorChanged: (color) => setState(() => this.color = color),
      );

  void pickColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => mat.AlertDialog(
        title: mat.Text("Pick a color"),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildColorPicker(),
            Button(
                child: Text('Select'),
                // Set onPressed to null to disable the button
                onPressed: () {
                  Navigator.of(context).pop();
                  print('button pressed');
                  setState(() {
                    fontColorPicker = color;
                  });
                }),
          ],
        ),
      ),
    );
  }
}

class DraggableText extends StatefulWidget {
  const DraggableText({Key? key}) : super(key: key);

  @override
  _DraggableTextState createState() => _DraggableTextState();
}

class _DraggableTextState extends State<DraggableText> {
  TextEditingController _controller =
      TextEditingController(text: "Sample Name");
  late FocusNode _focusNode;

  @override
  void initState() {
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResizableWidget(
      focusNode: _focusNode,
      child: Center(
        child: buildEditableText("", ""),
      ),
    );
  }

  Align buildEditableText(String styleFontStyle, String styleFontSize) {
    return Align(
      //Here
      alignment: Alignment.center,
      child: EditableText(
        onEditingComplete: (() {}),
        cursorRadius: const Radius.circular(1.0),
        textInputAction: TextInputAction.done,
        scrollBehavior: const ScrollBehavior().copyWith(scrollbars: false),
        scrollPhysics: const NeverScrollableScrollPhysics(),
        scrollController: null,
        controller: _controller,
        backgroundCursorColor: Colors.black,
        focusNode: _focusNode,
        maxLines: null,
        cursorColor: Colors.black,
        textAlign: TextAlign.center,
        style: GoogleFonts.getFont(
          "$selectedFont",
          fontSize: _styleFontSize,
          color: fontColorPicker,
          fontWeight: fontWeightSelector,
        ),
      ),
    );
  }
}
