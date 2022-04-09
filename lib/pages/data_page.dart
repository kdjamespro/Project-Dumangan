import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mat;
import 'package:project_dumangan/database/database.dart';
import 'package:project_dumangan/model/gmail_account.dart';
import 'package:project_dumangan/model/selected_event.dart';
import 'package:provider/provider.dart';

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
                  MyDatabase db = context.read<MyDatabase>();
                  SelectedEvent event = context.read<SelectedEvent>();
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
                          body: fluent.Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                fluent.Row(
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      child: FloatingActionButton(
                                        onPressed: () {
                                          fluent.showDialog(
                                            barrierDismissible: true,
                                            context: context,
                                            builder: (context) {
                                              return ContentDialog(
                                                title: const Text(
                                                    'Do you want to go back?'),
                                                content: const Text(
                                                    'All changes will be discarded.'),
                                                actions: [
                                                  Button(
                                                      child:
                                                          const Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      }),
                                                  FilledButton(
                                                    child:
                                                        const Text('Go Back'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .popUntil((route) =>
                                                              route.isFirst);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        backgroundColor:
                                            const fluent.Color.fromARGB(
                                                255, 146, 146, 146),
                                        child: const Icon(Icons.cancel_rounded),
                                      ),
                                    ),
                                    const fluent.Spacer(),
                                    const SizedBox(
                                      child: Text(
                                        'Compose Email',
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                                fluent.Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 20.0, 0.0, 0.0),
                                  child: TextField(
                                    controller: emailSubject,
                                    decoration: const InputDecoration(
                                      hintText: "Email Subject",
                                      labelText: "Subject",
                                      labelStyle: TextStyle(
                                        fontSize: 18,
                                      ),
                                      border: OutlineInputBorder(),
                                      contentPadding:
                                          fluent.EdgeInsets.all(20.0),
                                    ),
                                    maxLength: 70,
                                  ),
                                ),
                                // ignore: prefer_const_constructors
                                Flexible(
                                  child: Container(
                                    // ignore: prefer_const_constructors
                                    constraints: BoxConstraints(),
                                    // ignore: prefer_const_constructors
                                    child: SingleChildScrollView(
                                      child: TextField(
                                        controller: emailContents,
                                        maxLines: null,
                                        decoration: const InputDecoration(
                                          alignLabelWithHint: true,
                                          hintText: "Email Body",
                                          labelText: "Body",
                                          labelStyle: TextStyle(
                                            fontSize: 17,
                                          ),
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide(),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(4.0)),
                                              gapPadding: 4.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          floatingActionButton: FloatingActionButton(
                            onPressed: () {
                              fluent.showDialog(
                                barrierDismissible: true,
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
                                      FilledButton(
                                          child: const Text('Send'),
                                          onPressed: () async {
                                            print(account.signedIn);
                                            if (account.signedIn) {
                                              if (event.isEventSet()) {
                                                List<CertificatesTableData>
                                                    certs =
                                                    await db.getCertificates(
                                                        event.eventId);
                                                for (CertificatesTableData cert
                                                    in certs) {
                                                  String email = await db
                                                      .getParticipantEmail(
                                                          cert.participantsId);
                                                  File certificate =
                                                      File(cert.filename);
                                                  if (certificate
                                                      .existsSync()) {
                                                    account.sendEmail(
                                                        emailSubject.text,
                                                        emailContents.text,
                                                        email,
                                                        certificate);
                                                    await db.updateCertStatus(
                                                        cert.id);
                                                  }
                                                }
                                              }
                                            } else {
                                              fluent.showSnackbar(
                                                  context,
                                                  const SnackBar(
                                                      content: Text(
                                                          'You are not logged in to your gmail account')));
                                            }

                                            Navigator.pop(context);
                                          })
                                    ],
                                  );
                                },
                              );
                            },
                            backgroundColor:
                                const Color.fromRGBO(99, 158, 231, 1.0),
                            child: const Icon(Icons.send),
                          ),
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
      ),
    );
  }

  fluent.Stack certificateCard(
      fluent.BuildContext context, String name, String email) {
    return Stack(
      children: [
        Container(
          child: const fluent.Center(
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
                const fluent.Color.fromARGB(0, 255, 255, 255).withOpacity(.7),
                const fluent.Color.fromARGB(0, 255, 255, 255).withOpacity(.9),
                const fluent.Color.fromARGB(0, 255, 255, 255).withOpacity(.9),
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
                                icon: const Icon(FluentIcons.send),
                                onPressed: () {
                                  showSnackbar(
                                    context,
                                    const Snackbar(
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
