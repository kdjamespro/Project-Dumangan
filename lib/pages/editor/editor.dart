import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart' as mat;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:path/path.dart' as Path;
import 'package:project_dumangan/database/database.dart';
import 'package:project_dumangan/model/archive_list.dart';
import 'package:project_dumangan/model/canvas_controller.dart';
import 'package:project_dumangan/model/fontstyle_controller.dart';
import 'package:project_dumangan/model/progress_controller.dart';
import 'package:project_dumangan/model/selected_event.dart';
import 'package:project_dumangan/pages/editor/canvas_menu.dart';
import 'package:project_dumangan/pages/editor/image_archive.dart';
import 'package:project_dumangan/pages/editor/menu_button.dart';
import 'package:project_dumangan/services/loading_dialog.dart';
import 'package:project_dumangan/services/pdf_generator.dart';
import 'package:project_dumangan/services/warning_message.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:string_validator/string_validator.dart';
import '/services/file_handler.dart';
import 'attribute_menu.dart';
import 'attribute_text.dart';
import 'package:project_dumangan/pages/editor/image_archive.dart';

class Editor extends StatefulWidget {
  const Editor({Key? key}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

final autoSuggestBox = TextEditingController();
String fontSelector = "Calibri";
String selectedFont = "Lato";
String styleFontStyle = "";
String styleFontColor = "";
double _styleFontSize = 12;
Color fontColorPicker = const Color(0xff443a49);
FontWeight fontWeightSelector = FontWeight.normal;
Color color = Colors.red;
Color pickerColor = const Color(0xff443a49);
Color currentColor = const Color(0xff443a49);
int menuIndex = 0;
File image = File('');
CanvasController canvasController = CanvasController();
List<Widget> stackContents = [];
double aspectRatio = canvasController.aspectRatio;
AttributeText dynamicFields = AttributeText();

class _EditorState extends State<Editor>
    with AutomaticKeepAliveClientMixin<Editor> {
  ScreenshotController screenshotController = ScreenshotController();
  // String fontSelector = "Calibri";
  // String selectedFont = "Lato";
  // String styleFontStyle = "";
  // String styleFontColor = "";
  // double _styleFontSize = 12;
  // Color fontColorPicker = const Color(0xff443a49);
  // FontWeight fontWeightSelector = FontWeight.normal;

  // Color color = Colors.red;
  // Color pickerColor = const Color(0xff443a49);
  // Color currentColor = const Color(0xff443a49);
  // int menuIndex = 0;
  // File image = File('');
  late FontStyleController styleController;
  late FlyoutController fontSelection;
  late TextEditingController fontValue;

  @override
  void initState() {
    fontValue = TextEditingController(text: '');
    fontSelection = FlyoutController();
    dynamicFields.setChangeController(changeFontController);
    canvasController.addListener(changeCanvasSize);
    dynamicFields.addListener(updateTextBox);
    super.initState();
  }

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

  changeCanvasSize() {
    setState(() {
      aspectRatio = canvasController.aspectRatio;
    });
  }

  updateTextBox() {
    setState(() {
      stackContents = dynamicFields.attributes.values.toList();
    });
  }

  @override
  void dispose() {
    canvasController.removeListener(changeCanvasSize);
    dynamicFields.removeListener(updateTextBox);
    super.dispose();
    // canvasController.removeListener(() { })
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
        Expanded(
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
        SizedBox(
            width: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    size: 23,
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
                    size: 23,
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
        SizedBox(
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
          items: const [
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
                                icon: const Text('8'),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(8);
                                }),
                            IconButton(
                                icon: const Text('9'),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(9);
                                }),
                            IconButton(
                                icon: const Text('10'),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(10);
                                }),
                            IconButton(
                                icon: const Text('11'),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(11);
                                }),
                            IconButton(
                                icon: const Text('12'),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(12);
                                }),
                            IconButton(
                                icon: const Text('14'),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(14);
                                }),
                            IconButton(
                                icon: const Text('16'),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(16);
                                }),
                            IconButton(
                                icon: const Text('18'),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(18);
                                }),
                            IconButton(
                                icon: const Text('20'),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(20);
                                }),
                            IconButton(
                                icon: const Text('22'),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(22);
                                }),
                            IconButton(
                                icon: const Text('24'),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(24);
                                }),
                            IconButton(
                                icon: const Text('26'),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(26);
                                }),
                            IconButton(
                                icon: const Text('28'),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(28);
                                }),
                            IconButton(
                                icon: const Text('36'),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(36);
                                }),
                            IconButton(
                                icon: const Text('48'),
                                onPressed: () {
                                  fontSelection.open = false;
                                  changeFontSize(48);
                                }),
                            IconButton(
                                icon: const Text('72'),
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
                child: const Text('Open color picker'),
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
                      description: const Text('No Image Found'),
                      dismissable: true,
                    ).show(context);
                  }
                },
                icon: const Icon(FluentIcons.save))),
        // Flexible(
        //   child: Button(
        //     child: const Text('Delete All Templates'),
        //     onPressed: () {
        //       fluent.showDialog(
        //         barrierDismissible: true,
        //         context: context,
        //         builder: (context) {
        //           return ContentDialog(
        //             title: const Text('Delete Templates'),
        //             content: const Text('This process cannot be undone.'),
        //             actions: [
        //               Button(
        //                   child: const Text('Cancel'),
        //                   onPressed: () {
        //                     Navigator.pop(context);
        //                   }),
        //               Button(
        //                 child: const Text('Delete'),
        //                 onPressed: () {

        //                 },
        //               ),
        //             ],
        //           );
        //         },
        //       );
        //     },
        //   ),
        // ),
        ChangeNotifierProvider(
            create: (context) => ProgressController(),
            builder: (context, _) {
              return Flexible(
                child: Button(
                  child: const Text('Generate PDF'),
                  onPressed: () async {
                    SelectedEvent event = context.read<SelectedEvent>();
                    if (event.isEventSet() &&
                        dynamicFields.attributes.isNotEmpty) {
                      String path =
                          await context.read<FileHandler>().selectDirectory();
                      if (path != '') {
                        List<ParticipantsTableData> list = await context
                            .read<MyDatabase>()
                            .getAttendedParticipants(event.eventId);
                        dynamicFields.hideIndicators();
                        dynamicFields.setDynamicFieldsData(list, event);
                        int i = 0;
                        ProgressController loading =
                            context.read<ProgressController>();
                        loading.setOverall(131);
                        LoadingDialog load = LoadingDialog();
                        load.showLoadingScreen(
                          context: context,
                          title: 'Generating Certificate',
                        );
                        for (; i < 131;) {
                          String fileName = dynamicFields.updateAttributes(i);
                          String name = Path.join(path, fileName);
                          var cert = await screenshotController.capture(
                            pixelRatio: 5,
                          );
                          if (cert != null) {
                            await PdfGenerator.generatePdf(
                                cert, name, canvasController.orientation);
                            print('Sucessful');
                          }
                          i += 1;
                          loading.increase();
                        }
                        dynamicFields.showIndicators();
                        dynamicFields.reset();
                        load.hideLoadingScreen();
                      }
                    } else {
                      MotionToast.error(
                        animationDuration: const Duration(seconds: 1),
                        animationCurve: Curves.easeOut,
                        toastDuration: const Duration(seconds: 2),
                        title: const Text('Certificate Generation Error'),
                        description: const Text(
                            'Please select an event first or add atleast one dynamic fields to the certificate'),
                        dismissable: true,
                      ).show(context);
                    }
                  },
                ),
              );
            }),
      ],
    );
  }

  Widget buildColorPicker() => ColorPicker(
        pickerColor: color,
        onColorChanged: (newcolor) => setState(() => color = newcolor),
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
                const fluent.Padding(
                  padding: EdgeInsets.all(20.0),
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
