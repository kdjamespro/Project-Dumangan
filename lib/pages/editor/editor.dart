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
                          margin: EdgeInsets.all(16),
                          color: Colors.white,
                          child: setImage(image),
                        ),
                      ),
                    ),
                    DraggableText(),
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
                child: Text('Upload Image'),
                onPressed: () async {
                  final picked =
                      await context.read<FileHandler>().open_image_file();
                  if (picked.existsSync()) {
                    image = picked;
                  }
                  setState(() {
                    setImage(image);
                  });
                },
              ),
            ]),
          ),
        ),
      ],
    );
  }
}
