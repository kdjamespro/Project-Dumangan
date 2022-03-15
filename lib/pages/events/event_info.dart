import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;
import 'package:flutter/material.dart';
import 'package:project_dumangan/database/database.dart';

class EventInfo extends StatefulWidget {
  EventInfo({Key? key, required this.event}) : super(key: key);
  EventsTableData event;

  @override
  _EventInfoState createState() => _EventInfoState();
}

class _EventInfoState extends State<EventInfo> {
  @override
  Widget build(BuildContext context) {
    return mat.SafeArea(
      child: mat.Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: mat.Colors.white54,
          margin: EdgeInsets.only(right: 12),
          child: FluentApp(
            debugShowCheckedModeBanner: false,
            home: SingleChildScrollView(
              child: Container(
                color: mat.Colors.white54,
                padding: const EdgeInsets.only(
                    left: 16, bottom: 8, right: 16, top: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    mat.Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Event Information",
                        style: FluentTheme.of(context).typography.title,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: mat.Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          EventTitleText(
                              context, "Event Title: ", widget.event.name),
                          EventDescription(
                              context, widget.event.description ?? ''),
                          EventTitleText(context, "Location / Meeting room : ",
                              "Online, Zoom link"),
                          EventTitleText(context, "Time & Date: ",
                              widget.event.date.toString()),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FilledButton(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text('Select Event'),
                                ),
                                onPressed: () {
                                  Navigator.pop(context, widget.event.id);
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: FilledButton(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text('Return'),
                                ),
                                onPressed: () {
                                  Navigator.pop(context, -1);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column EventDescription(BuildContext context, String eventDescription) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 25,
        ),
        Text(
          "Event Description: ",
          style: FluentTheme.of(context).typography.bodyStrong,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 20, 0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: mat.Colors.white,
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromRGBO(203, 202, 202, 1.0).withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: const Offset(2, 1), // changes position of shadow
                ),
              ],
            ),
            width: double.infinity,
            height: 150,
            padding: EdgeInsets.all(4),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SelectableText(
                (eventDescription),
                showCursor: false,
                cursorColor: mat.Colors.red,
                cursorRadius: mat.Radius.circular(3),
                cursorWidth: 10,
                cursorHeight: 2,
                toolbarOptions: mat.ToolbarOptions(copy: true, selectAll: true),
                autofocus: true,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Column EventTitleText(
      BuildContext context, String title, String containerContent) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 25,
        ),
        Text(
          title,
          style: FluentTheme.of(context).typography.bodyStrong,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 20, 0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: mat.Colors.white,
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromRGBO(203, 202, 202, 1.0).withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 3,
                  offset: const Offset(2, 1), // changes position of shadow
                ),
              ],
            ),
            width: double.infinity,
            height: 50,
            padding: EdgeInsets.all(4),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SelectableText(
                (containerContent),
                showCursor: false,
                cursorColor: mat.Colors.red,
                cursorRadius: mat.Radius.circular(3),
                cursorWidth: 10,
                cursorHeight: 2,
                toolbarOptions: mat.ToolbarOptions(copy: true, selectAll: true),
                autofocus: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
