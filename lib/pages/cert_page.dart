import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../services/file_handler.dart';

class CertPage extends StatelessWidget {
  CertPage({Key? key}) : super(key: key);
  bool fileExists = false;
  bool _crossCheck = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PickerContainer(
                caption:
                    'Drop a csv or xlsx file or click to upload for Registration Form'),
            PickerContainer(
              caption:
                  'Drop a csv or xlsx file or click to upload for Attedance Form',
            )
          ],
        ),
      ],
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
        padding: const EdgeInsets.all(16.0),
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
              strokeCap: StrokeCap.round,
              dashPattern: [6, 6],
              strokeWidth: 2,
              color: _dragging ? Colors.blue : Colors.grey[150],
              child: ClipRRect(
                child: Container(
                  width: double.infinity,
                  height: 400,
                  color: _dragging ? Colors.grey[50] : null,
                  child: Center(
                      child: Text(
                    widget.caption,
                    style: FluentTheme.of(context).typography.title,
                  )),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
