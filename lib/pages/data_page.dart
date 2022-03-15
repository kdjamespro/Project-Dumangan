import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mat;

class DataPage extends StatefulWidget {
  const DataPage({Key? key}) : super(key: key);

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      home: fluent.Container(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: fluent.Container(
            child: Scaffold(
              backgroundColor: mat.Color.fromARGB(1, 249, 249, 249),
              body: GridView.count(
                padding: EdgeInsets.only(right: 20),
                childAspectRatio: (35 / 20),
                crossAxisCount: 5,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  certificateCard(context, "Name", "Email"),
                  certificateCard(context, "Name", "Email"),
                  certificateCard(context, "Name", "Email"),
                  certificateCard(context, "Name", "Email"),
                  certificateCard(context, "Name", "Email"),
                  certificateCard(context, "Name", "Email"),
                  certificateCard(context, "Name", "Email"),
                  certificateCard(context, "Name", "Email"),
                  certificateCard(context, "Name", "Email"),
                  certificateCard(context, "Name", "Email"),
                  certificateCard(context, "Name", "Email"),
                  certificateCard(context, "Name", "Email"),
                  certificateCard(context, "Name", "Email"),
                  certificateCard(context, "Name", "Email"),
                  certificateCard(context, "Name", "Email"),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  print('Hello');
                  fluent.showDialog(
                    context: context,
                    builder: (context) {
                      return ContentDialog(
                        title: const Text('Send all?'),
                        content: const Text(
                            'Are you sure you want to send all content'),
                        actions: [
                          Button(
                              child: const Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          Button(
                              child: const Text('Send'),
                              onPressed: () {
                                Navigator.pop(context);
                              })
                        ],
                      );
                    },
                  );
                },
                backgroundColor: const Color.fromRGBO(99, 158, 231, 1.0),
                child: const Icon(Icons.send),
              ),
            ),
          ),
        ),
      ),
    );
  }

  fluent.Stack certificateCard(
      fluent.BuildContext context, String name, String email) {
    return Stack(
      children: [
        Container(
          child: fluent.Center(
              child: fluent.Image(
                  fit: fluent.BoxFit.fill,
                  height: 200.0,
                  image:
                      fluent.AssetImage('lib/image/certificate_template.png'))),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                fluent.Color.fromARGB(0, 255, 255, 255).withOpacity(.7),
                fluent.Color.fromARGB(0, 255, 255, 255).withOpacity(.9),
                fluent.Color.fromARGB(0, 255, 255, 255).withOpacity(.9),
                fluent.Color.fromARGB(246, 255, 255, 255).withOpacity(1.0),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color:
                    const Color.fromRGBO(203, 202, 202, 1.0).withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 3,
                offset: const Offset(1, 3), // changes position of shadow
              ),
            ],
          ),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          name,
                          style: TextStyle(fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              email,
                              style: TextStyle(fontSize: 12),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              fluent.IconButton(
                                icon: const Icon(FluentIcons.download),
                                onPressed: () {
                                  showSnackbar(
                                    context,
                                    Snackbar(
                                      content:
                                          Text('FileName has been downloaded'),
                                    ),
                                  );
                                },
                              ),
                              fluent.IconButton(
                                icon: const Icon(FluentIcons.send),
                                onPressed: () {
                                  showSnackbar(
                                    context,
                                    Snackbar(
                                      content: Text('FileName has been sent'),
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

//Past version of the certificate card
//
// class CertificateCard extends fluent.StatelessWidget {
//   const CertificateCard({
//     fluent.Key? key,
//   }) : super(key: key);
//
//   @override
//   fluent.Widget build(fluent.BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           child: fluent.Center(
//               child: fluent.Image(
//                   fit: fluent.BoxFit.fill,
//                   height: 200.0,
//                   image:
//                       fluent.AssetImage('lib/image/certificate_template.png'))),
//         ),
//         Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             gradient: LinearGradient(
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//               colors: <Color>[
//                 fluent.Color.fromARGB(0, 255, 255, 255).withOpacity(.7),
//                 fluent.Color.fromARGB(0, 255, 255, 255).withOpacity(.9),
//                 fluent.Color.fromARGB(0, 255, 255, 255).withOpacity(.9),
//                 fluent.Color.fromARGB(246, 255, 255, 255).withOpacity(1.0),
//               ],
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color:
//                     const Color.fromRGBO(203, 202, 202, 1.0).withOpacity(0.2),
//                 spreadRadius: 2,
//                 blurRadius: 3,
//                 offset: const Offset(1, 3), // changes position of shadow
//               ),
//             ],
//           ),
//           child: Align(
//             alignment: Alignment.bottomLeft,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Column(
//                     children: [
//                       Align(
//                         alignment: Alignment.bottomLeft,
//                         child: Expanded(
//                           child: Text(
//                             "Name",
//                             style: TextStyle(fontSize: 14),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           const Align(
//                             alignment: Alignment.bottomLeft,
//                             child: Expanded(
//                               child: Text(
//                                 "email",
//                                 style: TextStyle(fontSize: 12),
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               fluent.IconButton(
//                                 icon: const Icon(FluentIcons.download),
//                                 onPressed: () {
//                                   showSnackbar(
//                                     context,
//                                     Snackbar(
//                                       content:
//                                           Text('FileName has been downloaded'),
//                                     ),
//                                   );
//                                 },
//                               ),
//                               fluent.IconButton(
//                                 icon: const Icon(FluentIcons.send),
//                                 onPressed: () {
//                                   showSnackbar(
//                                     context,
//                                     Snackbar(
//                                       content: Text('FileName has been sent'),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ],
//                           )
//                         ],
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
