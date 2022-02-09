import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';

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
      home: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Scaffold(
          body: GridView.count(
            crossAxisCount: 4,
            mainAxisSpacing: 20,
            crossAxisSpacing: 0,
            children: [
              CertificateCard(),
              CertificateCard(),
              CertificateCard(),
              CertificateCard(),
              CertificateCard(),
              CertificateCard(),
              CertificateCard(),
              CertificateCard(),
              CertificateCard(),
              CertificateCard(),
              CertificateCard(),
              CertificateCard(),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              print('Hello');
              fluent.showDialog(
                context: context,
                builder: (context) {
                  return ContentDialog(
                    title: Text('Send all?'),
                    content: Text('Are you sure you want to send all content'),
                    actions: [
                      Button(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      Button(
                          child: Text('Send'),
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
    );
  }
}

class CertificateCard extends fluent.StatelessWidget {
  const CertificateCard({
    fluent.Key? key,
  }) : super(key: key);

  @override
  fluent.Widget build(fluent.BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: fluent.EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color.fromRGBO(255, 255, 255, 0.7647058823529411)
                    .withOpacity(1),
                Color.fromRGBO(255, 255, 255, 1.0).withOpacity(1),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(203, 202, 202, 1.0).withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(1, 3), // changes position of shadow
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
                          "Name",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              "email",
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Row(
                            children: [
                              fluent.IconButton(
                                icon: Icon(FluentIcons.download),
                                onPressed: () {
                                  print('pressed icon button');
                                },
                              ),
                              fluent.IconButton(
                                icon: Icon(FluentIcons.send),
                                onPressed: () {
                                  print('pressed icon button');
                                },
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
