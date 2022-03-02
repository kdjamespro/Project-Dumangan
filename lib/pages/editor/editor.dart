import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:project_dumangan/services/file_handler.dart';
import 'package:provider/provider.dart';

import 'draggable_text.dart';

class Editor extends StatefulWidget {
  const Editor({Key? key}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  File image = File('');

  Image? setImage(File image) {
    return image.existsSync()
        ? Image.file(
            image,
            fit: BoxFit.fill,
          )
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 3,
          child: Column(
            children: [
              Expanded(
                child: Stack(
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
                    const DraggableText(),
                  ],
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Container(
            color: Colors.white,
            child: Column(children: [
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
                child: const Text('Save Image'),
                onPressed: () async {
                  context.read<FileHandler>().saveFile();
                },
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
