import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../data/participants_data.dart';
import '../services/file_handler.dart';

class CertPage extends StatelessWidget {
  CertPage({Key? key}) : super(key: key);
  bool fileExists = false;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: ListView(
        children: [
          PickerPane(),
          Table(),
        ],
      ),
    );
  }
}

class PickerContainer extends StatefulWidget {
  PickerContainer({Key? key, required this.caption}) : super(key: key);
  final String caption;

  @override
  _PickerContainerState createState() => _PickerContainerState();
}

class _PickerContainerState extends State<PickerContainer> {
  final List<XFile> _list = [];

  bool _dragging = false;

  Offset? offset;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(style: BorderStyle.none),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color.fromRGBO(255, 255, 255, 0.7647058823529411)
                    .withOpacity(1),
                Color.fromRGBO(255, 255, 255, 1.0).withOpacity(1),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(203, 202, 202, 1.0).withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(1, 3), // changes position of shadow
              ),
            ],
          ),
          child: DropTarget(
            onDragDone: (detail) async {
              setState(() {
                _list.addAll(detail.files);
              });

              debugPrint('onDragDone:');
              for (final file in detail.files) {
                debugPrint('  ${file.path} ${file.name}'
                    '  ${await file.lastModified()}'
                    '  ${await file.length()}'
                    '  ${file.mimeType}');
              }
            },
            onDragUpdated: (details) {
              setState(() {
                offset = details.localPosition;
              });
            },
            onDragEntered: (detail) {
              setState(() {
                _dragging = true;
                offset = detail.localPosition;
              });
            },
            onDragExited: (detail) {
              setState(() {
                _dragging = false;
                offset = null;
              });
            },
            child: GestureDetector(
              onTap: () async {
                final browse = FileHandler(platform: FilePicker.platform);
                browse.open_csv_file();
              },
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: Radius.circular(12),
                padding: EdgeInsets.all(6),
                strokeCap: StrokeCap.round,
                dashPattern: [10, 12],
                strokeWidth: 1,
                color: _dragging ? Colors.blue : Colors.grey[150],
                child: ClipRRect(
                  child: Container(
                    width: double.infinity,
                    height: 400,
                    color: _dragging ? Colors.grey[50] : null,
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 60),
                      child: Text(
                        widget.caption,
                        style: FluentTheme.of(context).typography.title,
                      ),
                    )),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PickerPane extends StatefulWidget {
  const PickerPane({Key? key}) : super(key: key);

  @override
  _PickerPaneState createState() => _PickerPaneState();
}

class _PickerPaneState extends State<PickerPane> {
  bool _crossCheck = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Icon(
                        FluentIcons.check_list,
                        size: 30,
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Cross Check?",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                      "Matches two or or more .csv files (For example Attendace and Registration Data)"),
                ),
              ),
              ToggleSwitch(
                checked: _crossCheck,
                onChanged: (v) => setState(() => _crossCheck = v),
                content: Text(_crossCheck ? 'Enable' : 'Disable'),
              ),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _crossCheck
                    ? [
                        PickerContainer(
                            caption:
                                'Drop a csv or xlsx file or click to upload for Registration Form'),
                        PickerContainer(
                          caption:
                              'Drop a csv or xlsx file or click to upload for Attedance Form',
                        ),
                      ]
                    : [
                        PickerContainer(
                            caption:
                                'Drop a csv or xlsx file or click to upload for Attedance Form'),
                      ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Table extends StatefulWidget {
  const Table({Key? key}) : super(key: key);

  @override
  _TableState createState() => _TableState();
}

class _TableState extends State<Table> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        child: SfDataGrid(
          source: ParticipantsData(),
          columns: ParticipantsData().getColumns(),
          allowSorting: true,
          columnWidthMode: ColumnWidthMode.fill,
        ),
      ),
    );
  }
}
