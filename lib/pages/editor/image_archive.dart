// ignore_for_file: list_remove_unrelated_type

import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:project_dumangan/model/archive_list.dart';
import 'package:provider/provider.dart';

class ImageArchive extends StatefulWidget {
  const ImageArchive({Key? key, required this.renderTemplate})
      : super(key: key);

  final Function renderTemplate;
  @override
  State<ImageArchive> createState() => _ImageArchiveState();
}

class _ImageArchiveState extends State<ImageArchive> {
  List<File> images = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text('Saved Templates',
          style: FluentTheme.of(context).typography.subtitle),
      const SizedBox(
        height: 10,
      ),
      Expanded(
        child: Consumer<ArchiveList>(
          builder: (context, archive, child) {
            return GridView.builder(
              itemCount: archive.archivedImage.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    widget.renderTemplate(archive.archivedImage[index]);
                  },
                  onLongPress: () {
                    //archive.archivedImage.removeAt(index);
                    print("Template Deleted");
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Stack(
                      children: [
                        // Material(
                        //   child: InkWell(
                        //     onTap: () {
                        //       setState(
                        //         () {
                        //           archive.archivedImage.removeAt(index);
                        //         },
                        //       );
                        //     },
                        //     child: const Padding(
                        //       padding: EdgeInsets.all(2.0),
                        //       child: Icon(Icons.delete),
                        //     ),
                        //   ),
                        // ),

                        // ElevatedButton(
                        //   onPressed: () {
                        //     setState(() {
                        //       archive.archivedImage.removeAt(index);
                        //     });
                        //   },
                        //   child: Text("Delete"),
                        // ),

                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 2.0),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 4),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fitWidth,
                                  filterQuality: FilterQuality.medium,
                                  isAntiAlias: true,
                                  image: FileImage(
                                    archive.archivedImage[index],
                                  )),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: RawMaterialButton(
                            onPressed: () {
                              setState(
                                () {
                                  archive.archivedImage.removeAt(index);
                                },
                              );
                              //bool rem = images.remove(index);
                            },
                            elevation: 2.0,
                            child: const Icon(
                              Icons.close,
                              size: 15.0,
                            ),
                            shape: const CircleBorder(),
                          ),
                        ),
                        // Container(
                        //   alignment: Alignment.bottomCenter,
                        //   child: Button(
                        //     child: Text("Delete"),
                        //     onPressed: () {
                        //       setState(() {
                        //         archive.archivedImage.removeAt(index);
                        //       });
                        //       //archive.archivedImage.removeAt(index);
                        //     },
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    ]);
  }
}
