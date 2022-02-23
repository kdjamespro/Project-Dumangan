import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_icon/file_icon.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:path/path.dart' as p;
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../data/participants_data.dart';
import '../services/file_handler.dart';
import '../services/file_parser.dart';
import '../services/warning_message.dart';

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
  bool _fileExists = false;
  File _file = File('');

  bool containsFile() => _fileExists;

  void removeFile() {
    _fileExists = false;
    _file = File('');
  }

  File getFile() => _file;

  @override
  _PickerContainerState createState() => _PickerContainerState();
}

class _PickerContainerState extends State<PickerContainer> {
  final List<XFile> _list = [];

  bool _dragging = false;

  Offset? offset;

  void _doFileExists(File file) {
    if (file.existsSync()) {
      setState(() {
        widget._fileExists = true;
      });
    } else {
      setState(() {
        widget._fileExists = false;
      });
    }
  }

  String _getName(File file) {
    return file.path.split('/').last;
  }

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
                const Color.fromRGBO(255, 255, 255, 0.7647058823529411)
                    .withOpacity(1),
                const Color.fromRGBO(255, 255, 255, 1.0).withOpacity(1),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color:
                    const Color.fromRGBO(203, 202, 202, 1.0).withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(1, 3), // changes position of shadow
              ),
            ],
          ),
          child: DropTarget(
            onDragDone: (detail) async {
              setState(() {
                _list.addAll(detail.files);
              });
              debugPrint('onDragDone:');
              for (final droppedFile in detail.files) {
                if (detail.files.length > 1) {
                  showWarningMessage(
                      context: context,
                      title: 'Multiple Files',
                      message: 'Please only drag one file at a time');
                  break;
                }
                String extension = p.extension(droppedFile.path);
                if (extension == '.xlsx' || extension == '.csv') {
                  widget._file = File(droppedFile.path);
                } else {
                  showWarningMessage(
                      context: context,
                      title: 'Invalid File Extension',
                      message:
                          'Please only select files with csv or xlsx format');
                  break;
                }
              }
              _doFileExists(widget._file);
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
              onTap: widget._fileExists
                  ? null
                  : () async {
                      widget._file =
                          await context.read<FileHandler>().open_csv_file();
                      _doFileExists(widget._file);
                    },
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                padding: const EdgeInsets.all(6),
                strokeCap: StrokeCap.round,
                dashPattern: const [10, 12],
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
                        child: widget._fileExists
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FileIcon(_getName(widget._file), size: 90),
                                  Expanded(
                                    flex: 4,
                                    child: AutoSizeText(
                                      _getName(widget._file),
                                      style: FluentTheme.of(context)
                                          .typography
                                          .bodyLarge,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: FittedBox(
                                      fit: BoxFit.none,
                                      child: IconButton(
                                        onPressed: () => {
                                          setState(() {
                                            widget._fileExists = false;
                                            widget.removeFile();
                                          })
                                        },
                                        icon: Icon(FluentIcons.chrome_close),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : AutoSizeText(
                                widget.caption,
                                style: FluentTheme.of(context).typography.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                    ),
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
  FileParser parser = FileParser();
  bool _crossCheck = false;
  PickerContainer filePicker1 = PickerContainer(
    caption: 'Drop a csv or xlsx file or click to upload for Attedance Form',
  );
  PickerContainer filePicker2 = PickerContainer(
      caption:
          'Drop a csv or xlsx file or click to upload for Registration Form');

  bool isFileReady() {
    if (_crossCheck) {
      return filePicker1.containsFile() && filePicker2.containsFile();
    } else {
      return filePicker1.containsFile();
    }
  }

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
                onChanged: (v) => setState(() {
                  _crossCheck = v;
                  filePicker2.removeFile();
                }),
                content: Text(_crossCheck ? 'Enable' : 'Disable'),
              ),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _crossCheck
                    ? [
                        filePicker2,
                        filePicker1,
                      ]
                    : [
                        filePicker1,
                      ],
              ),
              Button(
                  child: Text('Upload Data'),
                  onPressed: () {
                    if (!isFileReady()) {
                      showWarningMessage(
                          context: context,
                          title: 'Missing File',
                          message:
                              'Please select the file first before uploading');
                      return;
                    }
                    debugPrint('File Uploaded');
                    parser.parseFile(filePicker1.getFile());
                  })
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
