import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mat;
import 'package:fluent_ui/fluent_ui.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final _expanderKey = GlobalKey<ExpanderState>();
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      home: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          margin: EdgeInsets.only(right: 10),
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Expander(
                      header: Text('What is Project Dumangan?'),
                      content: RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          text: '               This application, codenamed ',
                          style: TextStyle(
                              fontSize: 14, color: mat.Colors.black, height: 2),
                          children: const <TextSpan>[
                            TextSpan(
                                text: 'Project Dumangan',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: ' is an application developed by '),
                            TextSpan(
                                text: 'Unitek,',
                                style: TextStyle(fontStyle: FontStyle.italic)),
                            TextSpan(
                                text:
                                    ' a team of aspiring computer scientists, for '),
                            TextSpan(
                                text: 'Asst. Prof. Analiza A. Yanga, MHist,',
                                style: TextStyle(fontStyle: FontStyle.italic)),
                            TextSpan(text: ' the current adviser of '),
                            TextSpan(
                                text: 'UST UNESCO Club. ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(
                                text:
                                    'The codename has been derived from Dumangan, the Tagalog sky-god of good harvest in Philippine Mythology. That said, the inspiration comes from the belief of the team that this software is the jumpstart to their future careers. Furthermore, the application aims to automate the process of generating and sending certificates for events with flexibility and ease-of-use in mind and make it easier for those who work in the Creatives team of any organization. Lastly, this project is done in fulfillment of the course requirement for the courses '),
                            TextSpan(
                                text: 'Software Engineering 1',
                                style: TextStyle(fontStyle: FontStyle.italic)),
                            TextSpan(text: ' and '),
                            TextSpan(
                                text: 'Software Engineering 2',
                                style: TextStyle(fontStyle: FontStyle.italic)),
                            TextSpan(
                                text:
                                    ' under the B.S. Computer Science program of the College of Information and Computing Sciences in the University of Santo Tomas.'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Expander(
                      header: Text('Why is Lorem Ipsum?'),
                      content: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ac est lacus. Mauris leo ante, porttitor vitae nisi vitae, pulvinar porta ante. Vestibulum magna mi, dictum eget suscipit eget, molestie sed ligula. Aliquam in congue nunc, eu luctus augue. Donec sodales enim ut tellus accumsan consectetur. Duis nulla leo, sodales sit amet neque a, fringilla aliquet urna. Proin ultricies, mi nec ultrices interdum, magna odio congue metus, ac finibus nulla mauris non massa. Ut accumsan quam non sem fermentum, quis egestas augue egestas. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Etiam vel lacinia lacus.'),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Expander(
                      header: Text('Where is Lorem Ipsum?'),
                      content: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ac est lacus. Mauris leo ante, porttitor vitae nisi vitae, pulvinar porta ante. Vestibulum magna mi, dictum eget suscipit eget, molestie sed ligula. Aliquam in congue nunc, eu luctus augue. Donec sodales enim ut tellus accumsan consectetur. Duis nulla leo, sodales sit amet neque a, fringilla aliquet urna. Proin ultricies, mi nec ultrices interdum, magna odio congue metus, ac finibus nulla mauris non massa. Ut accumsan quam non sem fermentum, quis egestas augue egestas. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Etiam vel lacinia lacus.'),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Expander(
                      header: Text('When is Lorem Ipsum?'),
                      content: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ac est lacus. Mauris leo ante, porttitor vitae nisi vitae, pulvinar porta ante. Vestibulum magna mi, dictum eget suscipit eget, molestie sed ligula. Aliquam in congue nunc, eu luctus augue. Donec sodales enim ut tellus accumsan consectetur. Duis nulla leo, sodales sit amet neque a, fringilla aliquet urna. Proin ultricies, mi nec ultrices interdum, magna odio congue metus, ac finibus nulla mauris non massa. Ut accumsan quam non sem fermentum, quis egestas augue egestas. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Etiam vel lacinia lacus.'),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Expander(
                      header: Text('How is Lorem Ipsum?'),
                      content: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ac est lacus. Mauris leo ante, porttitor vitae nisi vitae, pulvinar porta ante. Vestibulum magna mi, dictum eget suscipit eget, molestie sed ligula. Aliquam in congue nunc, eu luctus augue. Donec sodales enim ut tellus accumsan consectetur. Duis nulla leo, sodales sit amet neque a, fringilla aliquet urna. Proin ultricies, mi nec ultrices interdum, magna odio congue metus, ac finibus nulla mauris non massa. Ut accumsan quam non sem fermentum, quis egestas augue egestas. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Etiam vel lacinia lacus.'),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Expander(
                      header: Text('If is Lorem Ipsum?'),
                      content: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ac est lacus. Mauris leo ante, porttitor vitae nisi vitae, pulvinar porta ante. Vestibulum magna mi, dictum eget suscipit eget, molestie sed ligula. Aliquam in congue nunc, eu luctus augue. Donec sodales enim ut tellus accumsan consectetur. Duis nulla leo, sodales sit amet neque a, fringilla aliquet urna. Proin ultricies, mi nec ultrices interdum, magna odio congue metus, ac finibus nulla mauris non massa. Ut accumsan quam non sem fermentum, quis egestas augue egestas. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Etiam vel lacinia lacus.'),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Expander(
                      header: Text('Explain Lorem Ipsum?'),
                      content: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ac est lacus. Mauris leo ante, porttitor vitae nisi vitae, pulvinar porta ante. Vestibulum magna mi, dictum eget suscipit eget, molestie sed ligula. Aliquam in congue nunc, eu luctus augue. Donec sodales enim ut tellus accumsan consectetur. Duis nulla leo, sodales sit amet neque a, fringilla aliquet urna. Proin ultricies, mi nec ultrices interdum, magna odio congue metus, ac finibus nulla mauris non massa. Ut accumsan quam non sem fermentum, quis egestas augue egestas. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Etiam vel lacinia lacus.'),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Expander(
                      header: Text('Is Lorem Ipsum?'),
                      content: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ac est lacus. Mauris leo ante, porttitor vitae nisi vitae, pulvinar porta ante. Vestibulum magna mi, dictum eget suscipit eget, molestie sed ligula. Aliquam in congue nunc, eu luctus augue. Donec sodales enim ut tellus accumsan consectetur. Duis nulla leo, sodales sit amet neque a, fringilla aliquet urna. Proin ultricies, mi nec ultrices interdum, magna odio congue metus, ac finibus nulla mauris non massa. Ut accumsan quam non sem fermentum, quis egestas augue egestas. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Etiam vel lacinia lacus.'),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Expander(
                      header: Text('If Lorem Ipsum?'),
                      content: Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ac est lacus. Mauris leo ante, porttitor vitae nisi vitae, pulvinar porta ante. Vestibulum magna mi, dictum eget suscipit eget, molestie sed ligula. Aliquam in congue nunc, eu luctus augue. Donec sodales enim ut tellus accumsan consectetur. Duis nulla leo, sodales sit amet neque a, fringilla aliquet urna. Proin ultricies, mi nec ultrices interdum, magna odio congue metus, ac finibus nulla mauris non massa. Ut accumsan quam non sem fermentum, quis egestas augue egestas. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Etiam vel lacinia lacus.'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void close() {
    _expanderKey.currentState?.open = false;
  }
}
