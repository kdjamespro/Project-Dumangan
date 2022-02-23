import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  bool _checked = false;
  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      home: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Scaffold(
          body: Container(
            child: Button(
              child: Text('Add Event'),
              onPressed: () async {
                print('Got here');
              },
            ),
          ),
        ),
      ),
    );
  }
}
