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
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(),
              Container(
                child: Icon(
                  FluentIcons.check_list,
                  size: 200,
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Cross Check?",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                      "Matches two or or more .csv files (For example Attendace and Registration Data)"),
                ),
              ),
              Container(
                child: ToggleSwitch(
                  checked: _checked,
                  onChanged: (v) => setState(() => _checked = v),
                  content: Text(_checked ? 'On' : 'Off'),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}
