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
// <<<<<<< HEAD
import 'package:flutter_font_picker/flutter_font_picker.dart';

// =======
// >>>>>>> e6525fa895a686c6ba3648c66e0ad97c0a974da2
import '/services/file_handler.dart';
import 'attribute_menu.dart';
import 'attribute_text.dart';

class Editor extends StatefulWidget {
  const Editor({Key? key}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

final List<String> _myGoogleFonts = [
  "Abril Fatface",
  "Aclonica",
  "Alegreya Sans",
  "Architects Daughter",
  "Archivo",
  "Archivo Narrow",
  "Bebas Neue",
  "Bitter",
  "Bree Serif",
  "Bungee",
  "Cabin",
  "Cairo",
  "Coda",
  "Comfortaa",
  "Comic Neue",
  "Cousine",
  "Croissant One",
  "Faster One",
  "Forum",
  "Great Vibes",
  "Heebo",
  "Inconsolata",
  "Josefin Slab",
  "Lato",
  "Libre Baskerville",
  "Lobster",
  "Lora",
  "Merriweather",
  "Montserrat",
  "Mukta",
  "Nunito",
  "Offside",
  "Open Sans",
  "Oswald",
  "Overlock",
  "Pacifico",
  "Playfair Display",
  "Poppins",
  "Raleway",
  "Roboto",
  "Roboto Mono",
  "Source Sans Pro",
  "Space Mono",
  "Spicy Rice",
  "Squada One",
  "Sue Ellen Francisco",
  "Trade Winds",
  "Ubuntu",
  "Varela",
  "Vollkorn",
  "Work Sans",
  "Zilla Slab"
];

final autoSuggestBox = TextEditingController();
String fontSelector = "Roboto";
String selectedFont = "Current Font";
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
  late FontStyleController styleController;
  late FlyoutController fontSelection;
  late TextEditingController fontValue;
  late TextEditingController fontFamily;

  String _selectedFont = "Roboto";

  @override
  void initState() {
    fontValue = TextEditingController(text: '');
    fontFamily = TextEditingController(text: '');
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
      _selectedFont = styleController.textStyle.fontFamily ?? _selectedFont;
      fontFamily.text = styleController.fontFamily;
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
    // 'Light',
    'Regular',
    // 'Medium',
    // 'SemiBold',
    'Bold',
    // 'ExtraBold',
    // 'Black'
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
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Screenshot(
                    controller: screenshotController,
                    child: AspectRatio(
                      aspectRatio: aspectRatio,
                      child: Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          Positioned(
                            child: AspectRatio(
                              aspectRatio: aspectRatio,
                              child: Container(
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
                ),
              ),
            ],
          ),
        ),
        Container(
          // color: Color.fromARGB(255, 37, 38, 39),
          color: mat.Colors.black38,
          child: SizedBox(
              width: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 7, top: 10, bottom: 10),
                    decoration: BoxDecoration(
                      color: menuIndex == 0
                          ? const Color.fromARGB(255, 249, 249, 249)
                          : null,
                      borderRadius: menuIndex == 0
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12))
                          : null,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 7, top: 8),
                      child: MenuButton(
                        color: menuIndex == 0
                            ? const Color.fromARGB(255, 249, 249, 249)
                            : null,
                        label: 'Font',
                        menuIcon: const Icon(
                          FluentIcons.font,
                          color: Colors.black,
                          size: 25,
                        ),
                        onPress: () {
                          changeMenu(0);
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 7),
                    padding: const EdgeInsets.only(left: 7, top: 8),
                    decoration: BoxDecoration(
                      color: menuIndex == 1
                          ? const Color.fromARGB(255, 249, 249, 249)
                          : null,
                      borderRadius: menuIndex == 1
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12))
                          : null,
                    ),
                    child: MenuButton(
                      color: menuIndex == 1
                          ? const Color.fromARGB(255, 249, 249, 249)
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
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5, top: 10, bottom: 10),
                    padding: const EdgeInsets.only(left: 7),
                    decoration: BoxDecoration(
                      color: menuIndex == 2
                          ? const Color.fromARGB(255, 249, 249, 249)
                          : null,
                      borderRadius: menuIndex == 2
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12))
                          : null,
                    ),
                    child: MenuButton(
                      color: menuIndex == 2
                          ? const Color.fromARGB(255, 249, 249, 249)
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
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 7, top: 10, bottom: 10),
                    padding: const EdgeInsets.only(left: 7),
                    decoration: BoxDecoration(
                      color: menuIndex == 3
                          ? const Color.fromARGB(255, 249, 249, 249)
                          : null,
                      borderRadius: menuIndex == 3
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12))
                          : null,
                    ),
                    child: MenuButton(
                      color: menuIndex == 3
                          ? const Color.fromARGB(255, 249, 249, 249)
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
                  ),
                ],
              )),
        ),
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
        Row(
          children: [
            Expanded(
              child: Container(
                child: TextBox(
                  readOnly: true,
                  controller: fontFamily,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Button(
                child: const Text('Open Font picker'),
                onPressed: () {
                  Navigator.push(
                    context,
                    mat.MaterialPageRoute(
                        builder: (context) => FontPicker(
                            recentsCount: 2,
                            onFontChanged: (font) {
                              setState(() {
                                font.fontStyle;
                                selectedFont = font.fontFamily;
                                styleController.changeFontStyle(
                                    selectedFont, font.toTextStyle());
                                _selectedFont = font.fontFamily;
                                fontFamily.text = _selectedFont;
                              });
                            },
                            googleFonts: _myGoogleFonts)),
                  );
                }),
          ],
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
          width: double.infinity,
          child: SizedBox(
            child: Flyout(
              contentWidth: 100,
              controller: fontSelection,
              child: TextBox(
                placeholder: "Enter Font size",
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
        const SizedBox(
          height: 20,
        ),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Font color picker'),
        ),
        Row(
          children: [
            GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  color: fontColorPicker,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                ),
                height: 30,
                width: 45,
              ),
              onTap: () {
                pickColor(context);
              },
            ),
            Button(
                child: const Padding(
                  padding: EdgeInsets.only(right: 100, top: 2, bottom: 2),
                  child: Text('Open color picker'),
                ),
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
          width: double.infinity,
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
            flex: 10,
            child: ImageArchive(
              renderTemplate: setImage,
            )),
        const SizedBox(
          height: 10,
        ),
        Flexible(
          flex: 1,
          child: Container(
            width: double.infinity,
            child: Button(
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Text('Upload Image'),
              ),
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
          ),
        ),
        Flexible(
          child: Container(
            margin: const EdgeInsets.only(top: 6, bottom: 6),
            width: double.infinity,
            child: Button(
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
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Text("Save Template"),
              ),
            ),
          ),
        ),
        ChangeNotifierProvider(
            create: (context) => ProgressController(),
            builder: (context, _) {
              return Flexible(
                child: Container(
                  width: double.infinity,
                  child: Button(
                    child: const Padding(
                      padding: EdgeInsets.all(4.0),
                      child: Text('Generate PDF'),
                    ),
                    onPressed: () async {
                      SelectedEvent event = context.read<SelectedEvent>();
                      MyDatabase db = context.read<MyDatabase>();
                      if (event.isEventSet() &&
                          dynamicFields.attributes.isNotEmpty) {
                        List<ParticipantsTableData> list =
                            await db.getAttendedParticipants(event.eventId);
                        if (list.isNotEmpty) {
                          String path = await context
                              .read<FileHandler>()
                              .selectDirectory();
                          if (path != '') {
                            dynamicFields.hideIndicators();
                            dynamicFields.setDynamicFieldsData(list, event);
                            List<CertificatesTableCompanion> certs = [];
                            int i = 0;
                            ProgressController loading =
                                context.read<ProgressController>();
                            loading.setOverall(list.length);
                            LoadingDialog load = LoadingDialog();
                            load.showLoadingScreen(
                              context: context,
                              title: 'Generating Certificate',
                            );

                            int sucessful = 0;
                            for (; i < list.length;) {
                              final stopwatch = Stopwatch()..start();
                              int id = dynamicFields.updateAttributes(i);
                              String name =
                                  Path.join(path, id.toString() + '.pdf');

                              var cert = await screenshotController.capture(
                                pixelRatio: 5,
                              );
                              if (cert != null) {
                                try {
                                  await PdfGenerator.generatePdf(
                                      cert, name, canvasController.orientation);
                                  certs.add(CertificatesTableCompanion.insert(
                                      participantsId: id,
                                      filename: name,
                                      eventId: event.eventId));
                                  sucessful += 1;
                                } on FileSystemException catch (e) {
                                  print(e);
                                  await showWarningMessage(
                                      context: context,
                                      title: 'Cannot create pdf file',
                                      message:
                                          'The file $name is used by another application or process. Please close it before proceeding');
                                  i -= 1;
                                  loading.decrease();
                                }
                              }
                              i += 1;
                              loading.increase();
                              print(
                                  'Whole Generation Process executed in ${stopwatch.elapsed.inSeconds}');
                            }
                            await db.addCertificates(certs);
                            await db.updateEventCertificates(
                                event.eventId, sucessful);
                            event.updateCertificatesCount(sucessful);
                            dynamicFields.showIndicators();
                            dynamicFields.reset();
                            load.hideLoadingScreen();
                            loading.reset();
                          }
                        } else {
                          MotionToast.error(
                            animationDuration: const Duration(seconds: 1),
                            animationCurve: Curves.easeOut,
                            toastDuration: const Duration(seconds: 2),
                            title: const Text('Certificate Generation Error'),
                            description:
                                const Text('Add a participant\'s data first'),
                            dismissable: true,
                          ).show(context);
                        }
                      }
                    },
                  ),
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
      barrierDismissible: true,
      context: context,
      builder: (context) => mat.AlertDialog(
        content: Container(
          height: 500,
          width: 700,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  const Text(
                    'Font Color Selection',
                  ),
                ],
              ),
              buildColorPicker(),
              Button(
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Select Color'),
                  ),
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
      ),
    );
  }
}
