import 'dart:io';
import 'dart:typed_data';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mat;
import 'package:mailer/mailer.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:project_dumangan/database/database.dart';
import 'package:project_dumangan/model/gmail_account.dart';
import 'package:project_dumangan/model/selected_event.dart';
import 'package:project_dumangan/services/pdf_generator.dart';
import 'package:project_dumangan/services/warning_message.dart';
import 'package:provider/provider.dart';

Color sendingColor = mat.Colors.red;

class DataPage extends StatefulWidget {
  const DataPage({Key? key}) : super(key: key);
  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  TextEditingController emailSubjectAnnoucement = TextEditingController();
  TextEditingController emailContentsAnnoucement = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    MyDatabase db = context.read<MyDatabase>();
    SelectedEvent event = context.read<SelectedEvent>();
    return FluentApp(
      debugShowCheckedModeBanner: false,
      home: Padding(
        padding: const EdgeInsets.all(15),
        child: fluent.Container(
          child: Scaffold(
            backgroundColor: mat.Color.fromARGB(1, 249, 249, 249),
            body: event.isEventSet()
                ? fluent.FutureBuilder(
                    future: db.getCertificates(event.eventId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.active:
                          case ConnectionState.waiting:
                            return const Center(
                              child: ProgressRing(strokeWidth: 8.0),
                            );
                          case ConnectionState.done:
                            List<CertificatesTableData> certs =
                                snapshot.data as List<CertificatesTableData>;
                            if (certs.isNotEmpty) {
                              return GridView.count(
                                padding: const EdgeInsets.only(right: 20),
                                childAspectRatio: (35 / 20),
                                crossAxisCount: 5,
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 20,
                                children: certs.map((e) {
                                  return certificateCard(
                                      context, '', e.filename, e.filename);
                                }).toList(),
                              );
                            }
                        }
                      }
                      return Container();
                    })
                : Container(),
            floatingActionButton: FloatingActionButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              onPressed: () {
                GmailAccount account = context.read<GmailAccount>();
                fluent.showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) {
                    TextEditingController emailSubject =
                        TextEditingController();
                    TextEditingController emailContents =
                        TextEditingController();

                    return fluent.Container(
                      margin: const fluent.EdgeInsets.all(100),
                      child: Scaffold(
                        appBar: TabBar(
                          controller: _controller,
                          tabs: const [
                            fluent.Padding(
                              padding: EdgeInsets.all(12.0),
                              child: fluent.Text(
                                "Send Certificate",
                                style: TextStyle(color: mat.Colors.black),
                              ),
                            ),
                            fluent.Padding(
                              padding: EdgeInsets.all(12.0),
                              child: fluent.Text(
                                "Send Announcements",
                                style: TextStyle(color: mat.Colors.black),
                              ),
                            ),
                          ],
                        ),
                        body: TabBarView(controller: _controller, children: [
                          fluent.Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                fluent.Row(
                                  children: [
                                    fluent.IconButton(
                                      icon: const Icon(
                                        fluent.FluentIcons.return_key,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        fluent.showDialog(
                                          // barrierDismissible: true,
                                          context: context,
                                          builder: (context) {
                                            return ContentDialog(
                                              title: const Text(
                                                  'Do you want to exit email composition?'),
                                              content: const Text(
                                                  'All changes will be discarded.'),
                                              actions: [
                                                Button(
                                                  child: const Text(
                                                      'Discard email'),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .popUntil((route) =>
                                                            route.isFirst);
                                                  },
                                                ),
                                                FilledButton(
                                                    child: const Text(
                                                        'Continue Editing'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    }),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    const fluent.Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        'Compose Email for Certificates',
                                        style: fluent.TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                                const fluent.Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                                ),
                                // ignore: prefer_const_constructors
                                TextBox(
                                  header: 'Subject',
                                  headerStyle: const TextStyle(fontSize: 18),
                                  placeholder: 'Enter your email subject here',
                                  controller: emailSubject,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextBox(
                                  maxLines: 12,
                                  header: 'Body',
                                  headerStyle: const TextStyle(fontSize: 18),
                                  placeholder: 'Enter your email body here',
                                  controller: emailContents,
                                ),
                                const fluent.SizedBox(
                                  height: 10,
                                ),
                                fluent.Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(),
                                    FilledButton(
                                      onPressed: () {
                                        fluent.showDialog(
                                          // barrierDismissible: true,
                                          context: context,
                                          builder: (context) {
                                            return ContentDialog(
                                              title: const Text(
                                                  'Send certificates to all?'),
                                              content: const Text(
                                                  'Are you sure you want to send all the certificates?'),
                                              actions: [
                                                Button(
                                                    child: const Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    }),
                                                FilledButton(
                                                    child:
                                                        const Text('Send All'),
                                                    onPressed: () async {
                                                      print(account.signedIn);
                                                      if (account.signedIn) {
                                                        if (event
                                                            .isEventSet()) {
                                                          List<CertificatesTableData>
                                                              certs =
                                                              await db.getCertificates(
                                                                  event
                                                                      .eventId);
                                                          for (CertificatesTableData cert
                                                              in certs) {
                                                            String email = await db
                                                                .getParticipantEmail(
                                                                    cert.participantsId);
                                                            File certificate =
                                                                File(cert
                                                                    .filename);
                                                            if (certificate
                                                                .existsSync()) {
                                                              account.sendEmail(
                                                                  emailSubject
                                                                      .text,
                                                                  emailContents
                                                                      .text,
                                                                  email,
                                                                  certificate);

                                                              await db
                                                                  .updateCertStatus(
                                                                      cert.id);
                                                            }
                                                            if (cert.sended ==
                                                                true) {
                                                              setState(() {
                                                                sendingColor =
                                                                    mat.Colors
                                                                        .green;
                                                              });
                                                            } else {
                                                              setState(() {
                                                                sendingColor =
                                                                    mat.Colors
                                                                        .red;
                                                              });
                                                            }
                                                          }
                                                        } else {
                                                          await showWarningMessage(
                                                              context: context,
                                                              title:
                                                                  'No Event Selected',
                                                              message:
                                                                  'Please selected an event first');
                                                          Navigator.of(context)
                                                              .popUntil((route) =>
                                                                  route
                                                                      .isFirst);
                                                        }
                                                      } else {
                                                        await showWarningMessage(
                                                            context: context,
                                                            title:
                                                                'Gmail Account Error',
                                                            message:
                                                                'You are not logged In with your gmail account');
                                                      }
                                                      Navigator.of(context)
                                                          .popUntil((route) =>
                                                              route.isFirst);
                                                    })
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: fluent.Row(
                                        children: const [
                                          fluent.Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 3, horizontal: 10),
                                            child: fluent.Text(
                                              "Send",
                                              style: fluent.TextStyle(
                                                  fontSize: 15),
                                            ),
                                          ),
                                          fluent.SizedBox(
                                            width: 3,
                                          ),
                                          fluent.Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: Icon(
                                              FluentIcons.send,
                                              size: 15,
                                            ),
                                          ),
                                          fluent.SizedBox(
                                            width: 5,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          fluent.Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                fluent.Row(
                                  children: [
                                    fluent.IconButton(
                                      icon: const Icon(
                                        fluent.FluentIcons.return_key,
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        fluent.showDialog(
                                          // barrierDismissible: true,
                                          context: context,
                                          builder: (context) {
                                            return ContentDialog(
                                              title: const Text(
                                                  'Do you want to exit email announcement composition?'),
                                              content: const Text(
                                                  'All changes will be discarded.'),
                                              actions: [
                                                Button(
                                                  child: const Text(
                                                      'Discard email'),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .popUntil((route) =>
                                                            route.isFirst);
                                                  },
                                                ),
                                                FilledButton(
                                                    child: const Text(
                                                        'Continue Editing'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    }),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    const fluent.Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        'Compose Email for Announcements',
                                        style: fluent.TextStyle(fontSize: 18),
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                                const fluent.Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
                                ),
                                // ignore: prefer_const_constructors
                                TextBox(
                                  header: 'Subject',
                                  controller: emailSubjectAnnoucement,
                                  headerStyle: const TextStyle(fontSize: 18),
                                  placeholder: 'Enter your email subject here',
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextBox(
                                  controller: emailContentsAnnoucement,
                                  maxLines: 12,
                                  header: 'Body',
                                  headerStyle: const TextStyle(fontSize: 18),
                                  placeholder: 'Enter your email body here',
                                ),
                                const fluent.SizedBox(
                                  height: 10,
                                ),
                                fluent.Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(),
                                    FilledButton(
                                      onPressed: () {
                                        fluent.showDialog(
                                          // barrierDismissible: true,
                                          context: context,
                                          builder: (context) {
                                            return ContentDialog(
                                              title: const Text(
                                                  'Send Announcement to all?'),
                                              content: const Text(
                                                  'Are you sure you want to send announcement to all?'),
                                              actions: [
                                                Button(
                                                    child: const Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    }),
                                                FilledButton(
                                                    child:
                                                        const Text('Send all'),
                                                    onPressed: () async {
                                                      if (account.signedIn) {
                                                        print(account.signedIn);
                                                        if (event
                                                            .isEventSet()) {
                                                          List<String> emails =
                                                              await db
                                                                  .getAllParticipantEmail();
                                                          for (String email
                                                              in emails) {
                                                            await account
                                                                .sendAnnouncements(
                                                                    emailSubjectAnnoucement
                                                                        .text,
                                                                    emailContentsAnnoucement
                                                                        .text,
                                                                    email);
                                                          }
                                                        } else {
                                                          await showWarningMessage(
                                                              context: context,
                                                              title:
                                                                  'No Event Selected',
                                                              message:
                                                                  'Please selected an event first');
                                                          Navigator.of(context)
                                                              .popUntil((route) =>
                                                                  route
                                                                      .isFirst);
                                                        }
                                                      } else {
                                                        await showWarningMessage(
                                                            context: context,
                                                            title:
                                                                'Gmail Account Error',
                                                            message:
                                                                'You are not logged In with your gmail account');
                                                      }
                                                      Navigator.of(context)
                                                          .popUntil((route) =>
                                                              route.isFirst);
                                                    }),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: fluent.Row(
                                        children: const [
                                          fluent.Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 3, horizontal: 10),
                                            child: fluent.Text(
                                              "Send",
                                              style: fluent.TextStyle(
                                                  fontSize: 15),
                                            ),
                                          ),
                                          fluent.SizedBox(
                                            width: 3,
                                          ),
                                          fluent.Padding(
                                            padding: EdgeInsets.all(2.0),
                                            child: Icon(
                                              FluentIcons.send,
                                              size: 15,
                                            ),
                                          ),
                                          fluent.SizedBox(
                                            width: 5,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ]),
                      ),
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
    );
  }

  fluent.Stack certificateCard(
      fluent.BuildContext context, String name, String email, String path) {
    return Stack(
      children: [
        Container(
          child: fluent.Center(
              child: fluent.FutureBuilder(
                  future: PdfGenerator.getPdfThumbnail(path),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.done:
                          Uint8List? img = snapshot.data as Uint8List?;
                          if (img == null) {
                            return Container();
                          } else {
                            return fluent.Image.memory(
                              img,
                              height: 200,
                            );
                          }
                        case ConnectionState.waiting:
                        case ConnectionState.active:
                          return const Center(
                            child: ProgressRing(),
                          );
                        default:
                          return Container();
                      }
                    }
                    return Container();
                  })),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                const fluent.Color.fromARGB(0, 255, 255, 255).withOpacity(.0),
                const fluent.Color.fromARGB(0, 255, 255, 255).withOpacity(.2),
                const fluent.Color.fromARGB(0, 255, 255, 255).withOpacity(.8),
                const fluent.Color.fromARGB(246, 255, 255, 255)
                    .withOpacity(1.0),
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
              child: Wrap(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          email,
                          style: TextStyle(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 5,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
              color: sendingColor,
            ),
          ),
        ),
      ],
    );
  }
}
