import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart' as mat;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:path/path.dart' as Path;
import 'package:project_dumangan/model/canvas_controller.dart';
import 'package:project_dumangan/model/fontstyle_controller.dart';
import 'package:project_dumangan/pages/editor/canvas_menu.dart';
import 'package:project_dumangan/pages/editor/draggable_text.dart';
import 'package:project_dumangan/services/warning_message.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:string_validator/string_validator.dart';

import '/services/file_handler.dart';
import '/services/pdf_generator.dart';
import 'attribute_text.dart';

class Editor extends StatefulWidget {
  const Editor({Key? key}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

final autoSuggestBox = TextEditingController();

class _EditorState extends State<Editor> with AutomaticKeepAliveClientMixin {
  ScreenshotController screenshotController = ScreenshotController();
  String fontSelector = "Calibri";
  String selectedFont = "Lato";
  String styleFontStyle = "";
  String styleFontColor = "";
  double _styleFontSize = 12;
  Color fontColorPicker = const Color(0xff443a49);
  FontWeight fontWeightSelector = FontWeight.normal;
  late AttributeText dyanmicFields;

  Color color = Colors.red;
  Color pickerColor = const Color(0xff443a49);
  Color currentColor = const Color(0xff443a49);
  int menuIndex = 0;
  late double aspectRatio;
  File image = File('');
  late DraggableText text;
  List<Widget> stackContents = [];
  late FontStyleController styleController;
  late CanvasController canvasController;
  late FlyoutController fontSelection;
  late TextEditingController fontValue;

  changeFontController(FontStyleController controller) {
    styleController = controller;
    Color selectedColor = styleController.textStyle.color ?? pickerColor;
    setState(() {
      changeColor(selectedColor);
      fontColorPicker = selectedColor;
      _styleFontSize = styleController.textStyle.fontSize ?? _styleFontSize;
      fontValue.text = '${_styleFontSize.toInt()}';
    });
  }

  @override
  void initState() {
    print('Initialized');
    fontValue = TextEditingController(text: '');
    fontSelection = FlyoutController();
    styleController = FontStyleController(
        controller: TextEditingController(text: 'Sample Text'));
    canvasController = CanvasController();
    aspectRatio = canvasController.aspectRatio;
    canvasController.addListener(() {
      setState(() {
        print('Changing');
        aspectRatio = canvasController.aspectRatio;
      });
    });
    dyanmicFields = AttributeText(changeController: changeFontController)
      ..addAttribute('Full Name')
      ..addAttribute('Email');
    stackContents.addAll(dyanmicFields.attributes.values);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

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
    super.build(context);
    return Row(
      children: [
        Flexible(
          flex: 5,
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
                          aspectRatio: aspectRatio,
                          child: Container(
                            margin: const EdgeInsets.all(16),
                            color: Colors.white,
                            child: setImage(image),
                          ),
                        ),
                      ),
                      ...stackContents,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
            width: 50,
            child: Column(
              children: [
                Container(
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        menuIndex = 0;
                      });
                    },
                    icon: const Icon(
                      FluentIcons.font,
                      size: 23,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      menuIndex = 1;
                    });
                  },
                  icon: const Icon(
                    FluentIcons.file_image,
                    size: 23,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      menuIndex = 2;
                    });
                  },
                  icon: const Icon(
                    FluentIcons.size_legacy,
                    size: 23,
                  ),
                )
              ],
            )),
        Container(
          width: 300,
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: IndexedStack(
                index: menuIndex,
                children: [
                  fontsMenu(),
                  imageMenu(context),
                  CanvasMenu(controller: canvasController),
                ],
              )),
        ),
      ],
    );
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  void changeFontSize(double size) {
    setState(() {
      _styleFontSize = size;
      styleController.changeFontSize(size);
      fontValue.text = '${size.toInt()}';
    });
  }

  Widget fontsMenu() {
    return Column(
      children: [
        const Text('Tools'),
        const SizedBox(
          height: 20,
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Font style selector'),
        ),
        AutoSuggestBox(
          cursorColor: mat.Colors.blue,
          highlightColor: mat.Colors.black,
          clearButtonEnabled: true,
          trailingIcon: const Icon(FluentIcons.search),
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
            selectedFont = text;
            setState(() {
              styleController.changeFontStyle(selectedFont);
            });

            selectedFont = text;
          },
        ),
        // Text("$number"),
        const SizedBox(
          height: 20,
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Font size selector'),
        ),
        SizedBox(
          // The default width is 200.
          // The slider does not have its own widget, so you have to add it yourself.
          // The slider always try to be as big as possible
          width: 90,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              child: Flyout(
                contentWidth: 80,
                controller: fontSelection,
                child: TextBox(
                  enableSuggestions: true,
                  controller: fontValue,
                  suffix: IconButton(
                    icon: const Icon(FluentIcons.chevron_down),
                    onPressed: () {
                      fontSelection.open = true;
                    },
                  ),
                  onSubmitted: (text) {
                    if (isNumeric(text)) {
                      changeFontSize(double.parse(text));
                    } else {
                      showWarningMessage(
                          context: context,
                          title: 'Not a number',
                          message: 'The input is not a valid number');
                      fontValue.text = '${_styleFontSize.toInt()}';
                    }
                  },
                ),
                content: SizedBox(
                  height: 200,
                  width: 50,
                  child: Card(
                    backgroundColor: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            IconButton(
                                icon: Container(child: const Text('8')),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(8);
                                }),
                            IconButton(
                                icon: Container(child: const Text('9')),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(9);
                                }),
                            IconButton(
                                icon: Container(child: const Text('10')),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(10);
                                }),
                            IconButton(
                                icon: Container(child: const Text('11')),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(11);
                                }),
                            IconButton(
                                icon: Container(child: const Text('12')),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(12);
                                }),
                            IconButton(
                                icon: Container(child: const Text('14')),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(14);
                                }),
                            IconButton(
                                icon: Container(child: const Text('16')),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(16);
                                }),
                            IconButton(
                                icon: Container(child: const Text('18')),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(18);
                                }),
                            IconButton(
                                icon: Container(child: const Text('20')),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(20);
                                }),
                            IconButton(
                                icon: Container(child: const Text('22')),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(22);
                                }),
                            IconButton(
                                icon: Container(child: const Text('24')),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(24);
                                }),
                            IconButton(
                                icon: Container(child: const Text('26')),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(26);
                                }),
                            IconButton(
                                icon: Container(child: const Text('28')),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(28);
                                }),
                            IconButton(
                                icon: Container(child: const Text('36')),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(36);
                                }),
                            IconButton(
                                icon: Container(child: const Text('48')),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(48);
                                }),
                            IconButton(
                                icon: Container(child: const Text('72')),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(72);
                                }),
                          ]),
                    ),
                  ),
                ),
              ),
              width: 200,
            ),
          ),
        ),
        const SizedBox(
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
            const SizedBox(
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
        const SizedBox(
          height: 20,
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Font weight selector'),
        ),
        SizedBox(
          width: 300,
          child: Combobox<String>(
            placeholder: const Text('Selected list item'),
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
              if (value != null) {
                setState(() {
                  comboBoxValue = value;
                  styleController.changeFontWeight(value);
                });
              }
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Align(
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
                  onTap: () => setState(() {
                    styleController.changeFontAlignment(TextAlign.left);
                  }),
                ),
                DropDownButtonItem(
                  title: const Text('Center'),
                  leading: const Icon(FluentIcons.align_center),
                  onTap: () => setState(() {
                    styleController.changeFontAlignment(TextAlign.center);
                  }),
                ),
                DropDownButtonItem(
                  title: const Text('Right'),
                  leading: const Icon(FluentIcons.align_right),
                  onTap: () => setState(() {
                    styleController.changeFontAlignment(TextAlign.right);
                  }),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget imageMenu(BuildContext context) {
    return Column(
      children: [
        Button(
          child: const Text('Upload Image'),
          onPressed: () async {
            final picked = await context.read<FileHandler>().openImageFile();
            if (picked.existsSync()) {
              image = picked;
            }
            setState(() {
              setImage(image);
            });
          },
        ),
        Button(
          child: const Text('Generate PDF'),
          onPressed: () async {
            String path = await context.read<FileHandler>().saveFile();
            String name = Path.basename(path);
            if (path != '') {
              styleController.changeText('Kenneth');
              var cert = await screenshotController.capture(
                pixelRatio: 5,
              );
              if (cert != null) {
                await PdfGenerator.generatePdf(
                    cert, path, canvasController.orientation);
                print('Sucessful');
              }
            }
          },
        ),
      ],
    );
  }

  Widget buildColorPicker() => ColorPicker(
        pickerColor: color,
        onColorChanged: (color) => setState(() => this.color = color),
      );

  void pickColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => mat.AlertDialog(
        title: const mat.Text(""),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            mat.Row(
              children: [
                fluent.IconButton(
                    icon: const Icon(
                      FluentIcons.return_key,
                      color: mat.Colors.black,
                      size: 20,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                fluent.Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Compose Email',
                  ),
                ),
              ],
            ),
            buildColorPicker(),
            Button(
                child: const Text('Select'),
                // Set onPressed to null to disable the button
                onPressed: () {
                  Navigator.of(context).pop();
                  print('button pressed');
                  setState(() {
                    fontColorPicker = color;
                    styleController.changeFontColor(color);
                  });
                }),
          ],
        ),
      ),
    );
  }
}
