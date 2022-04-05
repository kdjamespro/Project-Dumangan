import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:path/path.dart' as Path;
import 'package:project_dumangan/model/archive_list.dart';
import 'package:project_dumangan/model/canvas_controller.dart';
import 'package:project_dumangan/model/fontstyle_controller.dart';
import 'package:project_dumangan/pages/editor/canvas_menu.dart';
import 'package:project_dumangan/pages/editor/draggable_text.dart';
import 'package:project_dumangan/pages/editor/image_archive.dart';
import 'package:project_dumangan/pages/editor/menu_button.dart';
import 'package:project_dumangan/services/warning_message.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:string_validator/string_validator.dart';

import '/services/file_handler.dart';
import '/services/pdf_generator.dart';
import 'attribute_menu.dart';
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
  late AttributeText dynamicFields;

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
    fontValue = TextEditingController(text: '');
    fontSelection = FlyoutController();
    styleController = FontStyleController(
        controller: TextEditingController(text: 'Sample Text'));
    canvasController = CanvasController();
    aspectRatio = canvasController.aspectRatio;
    canvasController.addListener(() {
      setState(() {
        aspectRatio = canvasController.aspectRatio;
      });
    });
    dynamicFields = AttributeText(changeController: changeFontController);
    dynamicFields.addListener(() {
      setState(() {
        stackContents = dynamicFields.attributes.values.toList();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  void setImage(File selecetedImage) {
    if (selecetedImage.existsSync()) {
      setState(() => image = selecetedImage);
    }
  }

  void changeMenu(int number) {
    setState(() {
      menuIndex = number;
    });
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
                            child: image.existsSync()
                                ? Image.file(
                                    image,
                                    fit: BoxFit.fill,
                                  )
                                : Container(),
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
            width: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MenuButton(
                  color: menuIndex == 0
                      ? FluentTheme.of(context)
                          .accentColor
                          .lightest
                          .withOpacity(0.8)
                      : null,
                  label: 'Fonts',
                  menuIcon: const Icon(
                    FluentIcons.font,
                    size: 30,
                  ),
                  onPress: () {
                    changeMenu(0);
                  },
                ),
                MenuButton(
                  color: menuIndex == 1
                      ? FluentTheme.of(context)
                          .accentColor
                          .lightest
                          .withOpacity(0.8)
                      : null,
                  label: 'Templates',
                  menuIcon: const Icon(
                    FluentIcons.file_image,
                    size: 30,
                  ),
                  onPress: () {
                    changeMenu(1);
                  },
                ),
                MenuButton(
                  color: menuIndex == 2
                      ? FluentTheme.of(context)
                          .accentColor
                          .lightest
                          .withOpacity(0.8)
                      : null,
                  label: 'Document\n Size',
                  menuIcon: const Icon(
                    FluentIcons.size_legacy,
                    size: 30,
                  ),
                  onPress: () {
                    changeMenu(2);
                  },
                ),
                MenuButton(
                  color: menuIndex == 3
                      ? FluentTheme.of(context)
                          .accentColor
                          .lightest
                          .withOpacity(0.8)
                      : null,
                  label: 'Dynamic\n Fields',
                  menuIcon: const Icon(
                    FluentIcons.add_field,
                    size: 30,
                  ),
                  onPress: () {
                    changeMenu(3);
                  },
                ),
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
                  AttributeMenu(
                    attributes: dynamicFields,
                  ),
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
        Flexible(
            flex: 2,
            child: ImageArchive(
              renderTemplate: setImage,
            )),
        const SizedBox(
          height: 10,
        ),
        Flexible(
          child: Button(
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
        ),
        Flexible(
            child: IconButton(
                onPressed: () async {
                  if (image.existsSync()) {
                    bool isSaved =
                        await context.read<ArchiveList>().addImage(image);
                  } else {
                    MotionToast.error(
                            animationDuration: const Duration(seconds: 1),
                            animationCurve: Curves.easeOut,
                            toastDuration: const Duration(seconds: 2),
                            description: const Text('No Image Found'))
                        .show(context);
                  }
                },
                icon: const Icon(FluentIcons.save))),
        Flexible(
          child: Button(
            child: const Text('Generate PDF'),
            onPressed: () async {
              String path = await context.read<FileHandler>().selectDirectory();
              String name = Path.join(path, 'try.pdf');
              if (path != '') {
                dynamicFields.hideIndicators();
                var cert = await screenshotController.capture(
                  pixelRatio: 5,
                );
                if (cert != null) {
                  await PdfGenerator.generatePdf(
                      cert, name, canvasController.orientation);
                  dynamicFields.showIndicators();
                  print('Sucessful');
                }
              }
            },
          ),
        ),
        Flexible(
          child: Button(
            child: const Text('Get Templates'),
            onPressed: () async {
              await context.read<FileHandler>().getSavedTemplates();
            },
          ),
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
        title: const mat.Text("Pick a color"),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildColorPicker(),
            Button(
                child: const Text('Select'),
                // Set onPressed to null to disable the button
                onPressed: () {
                  Navigator.of(context).pop();
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
