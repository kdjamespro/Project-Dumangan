// ignore_for_file: list_remove_unrelated_type

import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mat;
import 'package:motion_toast/motion_toast.dart';
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
                  crossAxisCount: 2, childAspectRatio: 30 / 23),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    widget.renderTemplate(archive.archivedImage[index]);
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Stack(
                      children: [
                        Container(
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
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            margin: const EdgeInsets.only(top: 4, right: 4),
                            color: mat.Colors.blue,
                            child: fluent.IconButton(
                                icon: const Icon(
                                  FluentIcons.delete,
                                  color: mat.Colors.white,
                                  size: 15,
                                ),
                                onPressed: () {
                                  archive.deleteImage(
                                      archive.archivedImage[index]);
                                  MotionToast.delete(
                                          dismissable: true,
                                          animationDuration:
                                              const Duration(seconds: 1),
                                          animationCurve: Curves.easeOut,
                                          toastDuration:
                                              const Duration(seconds: 2),
                                          description: const Text(
                                              'Template has been deleted'))
                                      .show(context);
                                }),
                          ),
                        ),
//                         Padding(
//                           padding: const EdgeInsets.only(left: 25),
//                           child: RawMaterialButton(
//                             onPressed: () {
//                               setState(
//                                 () {
//                                   archive.archivedImage.removeAt(index);
//                                 },
//                               );
//                               //bool rem = images.remove(index);
//                             },
//                             elevation: 2.0,
//                             child: const Icon(
//                               Icons.close,
//                               size: 15.0,
//                             ),
//                           ),
// // >>>>>>> e6525fa895a686c6ba3648c66e0ad97c0a974da2
//                         ),
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
