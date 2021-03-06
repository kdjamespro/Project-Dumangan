import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;
import 'package:project_dumangan/database/database.dart';
import 'package:project_dumangan/model/selected_event.dart';
import 'package:provider/provider.dart';

import '/bloc/cross_checking_bloc.dart';
import '/services/file_handler.dart';
import '/services/file_parser.dart';
import '/services/warning_message.dart';

class FileUploader extends StatefulWidget {
  const FileUploader({Key? key}) : super(key: key);

  @override
  _FileUploaderState createState() => _FileUploaderState();
}

class _FileUploaderState extends State<FileUploader> {
  FileParser parser = FileParser();
  bool _crossCheck = false;
  PickerContainer filePicker1 = PickerContainer(
    caption: 'Drop a csv file or click \nto upload for Attendance Form',
  );
  PickerContainer filePicker2 = PickerContainer(
      caption: 'Drop a csv file or click \nto upload for Registration Form');

  bool isFileReady() {
    if (_crossCheck) {
      return filePicker1.containsFile() && filePicker2.containsFile();
    } else {
      return filePicker1.containsFile();
    }
  }

  @override
  Widget build(BuildContext context) {
    SelectedEvent event = context.read<SelectedEvent>();
    return FutureBuilder(
        future: Provider.of<MyDatabase>(context)
            .getParticipantsCount(event.eventId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print((snapshot.data as int > 0 && event.eventParticipants > 0) ||
                event.eventAbsentees > 0);
            if ((snapshot.data as int > 0 && event.eventParticipants > 0) ||
                event.eventAbsentees > 0) {
              context.read<CrossCheckingBloc>().add(DbLoaded(
                  participants: event.eventParticipants,
                  absentees: event.eventAbsentees));
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(
                                FluentIcons.check_list,
                                size: 30,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Do you want to Cross Check your data?",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ToggleSwitch(
                      checked: _crossCheck,
                      onChanged: (v) => setState(() {
                        if (_crossCheck) {
                          context
                              .read<CrossCheckingBloc>()
                              .add(CrossChekingDisable());
                        } else {
                          context
                              .read<CrossCheckingBloc>()
                              .add(CrossChekingEnable());
                        }
                        _crossCheck = v;
                        filePicker2.removeFile();
                      }),
                      content: Text(_crossCheck
                          ? 'Cross-Checking Enabled'
                          : 'Cross-Checking Disabled'),
                    ),
                    BlocConsumer<CrossCheckingBloc, CrossCheckingState>(
                        builder: (context, state) {
                          if (state is CrossCheckingDisabled) {
                            return Row(
                              children: [filePicker1],
                            );
                          } else if (state is CrossCheckingEnabled) {
                            return Row(
                              children: [filePicker2, filePicker1],
                            );
                          } else {
                            return Container();
                          }
                        },
                        listener: (context, state) {}),
                    FilledButton(
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: Text('Upload Data'),
                        ),
                        onPressed: () {
                          int eventId = context.read<SelectedEvent>().eventId;
                          if (!isFileReady()) {
                            showWarningMessage(
                                context: context,
                                title: 'Missing File',
                                message:
                                    'Please select the file first before uploading');
                            return;
                          } else if (!(eventId >= 0)) {
                            showWarningMessage(
                                context: context,
                                title: 'No Event Selected',
                                message:
                                    'Please select an event first before uploading the data');
                            return;
                          }
                          context.read<CrossCheckingBloc>().add(
                              CrossChekingStart(
                                  files: _crossCheck
                                      ? [
                                          filePicker2.getFile(),
                                          filePicker1.getFile()
                                        ]
                                      : [filePicker1.getFile()],
                                  crossCheck: _crossCheck));
                          debugPrint('File Uploaded');
                        }),
                  ],
                ),
              );
            }
          }
          return Container();
        });
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
                if (extension == '.csv') {
                  widget._file = File(droppedFile.path);
                } else {
                  showWarningMessage(
                      context: context,
                      title: 'Invalid File Extension',
                      message: 'Please only select files with csv format');
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
                          await context.read<FileHandler>().openCsvFile();
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
                    height: MediaQuery.of(context).size.height / 2,
                    color: _dragging ? Colors.grey[50] : null,
                    child: Center(
                      child: widget._fileExists
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 100.0),
                                    child: Icon(
                                      FluentIcons.table,
                                      color: Colors.green.lightest,
                                      size: 90,
                                    ),
                                  ),
                                ),
                                // FileIcon(_getName(widget._file), size: 90),
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
                                      icon:
                                          const Icon(FluentIcons.chrome_close),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : AutoSizeText(
                              widget.caption,
                              style: FluentTheme.of(context).typography.title,
                              textAlign: TextAlign.center,
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
    );
  }
}
