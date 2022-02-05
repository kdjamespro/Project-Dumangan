import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mt;

import 'pages/cert_page.dart';
import 'pages/data_page.dart';
import 'pages/editor_page.dart';
import 'pages/event_page.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      theme: ThemeData(brightness: Brightness.light),
      debugShowCheckedModeBanner: false,
      title: 'Project Dumangan',
      home: MyHomePage(title: 'Project Dumangan'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      // appBar: NavigationAppBar(
      //   // title: (Text(widget.title)),
      //   automaticallyImplyLeading: false,
      // ),

      pane: NavigationPane(
        displayMode: PaneDisplayMode.compact,
        size: const NavigationPaneSize(
          openWidth: 180,
          openMinWidth: 100,
          openMaxWidth: 180,
        ),
        selected: index,
        onChanged: (i) => setState(() => index = i),
        items: [
          // It doesn't look good when resizing from compact to open
          PaneItemHeader(
              header: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text('Controls'),
          )),

          PaneItem(
            icon: const Icon(FluentIcons.reset),
            title: const Text('Reset'),
          ),

          PaneItem(
            icon: const Icon(FluentIcons.archive),
            title: const Text('Generate'),
          ),

          PaneItem(
            icon: const Icon(FluentIcons.send),
            title: const Text('Send'),
          ),
        ],
      ),
      content: NavigationBody(
        transitionBuilder: ((child, animation) => EntrancePageTransition(
              child: child,
              animation: animation,
            )),
        index: index,
        children: const [
          EventPage(),
          CertPage(),
          DataPage(),
          EditorPage(),
          LoginPage()
        ],
      ),
    );
  }
}
