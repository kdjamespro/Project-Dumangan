import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
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
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
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
                  );
                });
          },
        ),
      ),
    ]);
  }
}

// ChangeNotifierProvider.value(
//           value: context.watch<ArchiveList>(),
//           builder: (context, child) {
//             print('update Images');
//             return Consumer<ArchiveList>(
//               builder: (context, archive, child) {
//                 return GridView.builder(
//                     itemCount: archive.archivedImage.length,
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: 2),
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: () {
//                           print(index);
//                         },
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 4.0, vertical: 2.0),
//                           margin: const EdgeInsets.symmetric(
//                               horizontal: 4, vertical: 4),
//                           decoration: BoxDecoration(
//                             image: DecorationImage(
//                                 fit: BoxFit.fitWidth,
//                                 filterQuality: FilterQuality.medium,
//                                 isAntiAlias: true,
//                                 image: FileImage(
//                                   archive.archivedImage[index],
//                                 )),
//                           ),
//                         ),
//                       );
//                     });
//               },
//             );
//           },
//         ),