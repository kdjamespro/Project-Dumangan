import 'package:flutter/material.dart';
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
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Expander(
                    header: Text('What is Lorem Ipsum?'),
                    content: Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam ac est lacus. Mauris leo ante, porttitor vitae nisi vitae, pulvinar porta ante. Vestibulum magna mi, dictum eget suscipit eget, molestie sed ligula. Aliquam in congue nunc, eu luctus augue. Donec sodales enim ut tellus accumsan consectetur. Duis nulla leo, sodales sit amet neque a, fringilla aliquet urna. Proin ultricies, mi nec ultrices interdum, magna odio congue metus, ac finibus nulla mauris non massa. Ut accumsan quam non sem fermentum, quis egestas augue egestas. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Etiam vel lacinia lacus.'),
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
    );
  }

  void close() {
    _expanderKey.currentState?.open = false;
  }
}
