import 'package:drift/drift.dart' as drift;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/rendering.dart';
import 'package:project_dumangan/database/database.dart';
import 'package:project_dumangan/pages/event_info.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart' as mat;
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as picker;

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  DateTime date = DateTime.now();

  late TextEditingController eventsTitleController;
  late TextEditingController eventsDescController;
  late TextEditingController locationController;
  late TextEditingController dateController;

  final flyoutController = FlyoutController();
  late final dateTimeController =
      TextEditingController(text: DateTime.now().toString());

  @override
  void initState() {
    eventsTitleController = TextEditingController();
    eventsDescController = TextEditingController();
    locationController = TextEditingController();
    dateController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    eventsTitleController.dispose();
    eventsDescController.dispose();
    locationController.dispose();
    flyoutController.dispose();
    dateTimeController.dispose();
    dateController.dispose();
    super.dispose();
  }

  void clearController() {
    eventsTitleController.clear();
    eventsDescController.clear();
    locationController.clear();
    dateController.clear();
  }

  @override
  final ScrollController _firstController = ScrollController();
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: Container(
        padding: const EdgeInsets.only(left: 16, bottom: 8, right: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Events',
              style: FluentTheme.of(context).typography.title,
            ),
            const Divider(
              style: DividerThemeData(
                thickness: 2,
                horizontalMargin: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
      content: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextFormBox(
                          header: 'Event Title *',
                          placeholder: 'Type the event\'s name',
                          controller: eventsTitleController,
                        ),
                        TextBox(
                          controller: eventsDescController,
                          minHeight: 100,
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          header: 'Event Description',
                          placeholder: 'Add brief description of the event',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextFormBox(
                          controller: locationController,
                          header: 'Location / Meeting Room',
                          placeholder: 'Type the event\'s location',
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextBox(
                                keyboardType: TextInputType.datetime,
                                controller: dateController,
                                header: 'Date',
                                placeholder: 'Type event\'s date',
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              // Here Kirk
                              child: TimePicker(
                                header: 'Starts At',
                                selected: date,
                                onChanged: (selectedDate) =>
                                    setState(() => date = selectedDate),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 630,
                          child: FilledButton(
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text('Add New Event'),
                              ),
                              onPressed: () async {
                                MyDatabase db = Provider.of<MyDatabase>(context,
                                    listen: false);
                                String name = eventsTitleController.text;
                                String desc = eventsDescController.text;
                                await db.addEvent(EventsTableCompanion(
                                  name: drift.Value(name),
                                  description: drift.Value(desc),
                                  date: drift.Value(date),
                                  absentees: const drift.Value(0),
                                  participants: const drift.Value(0),
                                ));
                                print('Added to db');
                                clearController();
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              padding: EdgeInsets.only(bottom: 14, left: 12),
              child: Scrollbar(
                isAlwaysShown: true,
                controller: _firstController,
                child: ListView.builder(
                    // Uncomment this is you want to check is the item was added
                    // reverse: true,
                    padding: EdgeInsets.only(bottom: 20),
                    scrollDirection: Axis.horizontal,
                    controller: _firstController,
                    //Change this to show how many contents are there to show
                    itemCount: 1,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        // color: mat.Colors.greenAccent,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: StreamBuilder(
                              stream: Provider.of<MyDatabase>(context,
                                      listen: false)
                                  .getEvents(),
                              builder: (context, snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.active:
                                    List<EventsTableData> events =
                                        snapshot.data as List<EventsTableData>;
                                    print(events.length);
                                    return EventCard(events);
                                }
                                return Container();
                              },
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          )
        ],
      ),
    );
  }

  Row EventCard(List<EventsTableData> events) {
    return Row(
      children: events
          .map((event) => GestureDetector(
                onTap: () {
                  print(event.id);
                  Navigator.push(
                    context,
                    mat.MaterialPageRoute(
                        builder: (context) => const EventInfo()),
                  );
                },
                child: Container(
                  width: 225,
                  height: 225,
                  decoration: BoxDecoration(
                    color: mat.Colors.blueAccent,
                    borderRadius: BorderRadius.circular(16),
                    // gradient: LinearGradient(
                    //   begin: Alignment.topCenter,
                    //   end: Alignment.bottomCenter,
                    //   colors: <Color>[
                    //     fluent.Color.fromARGB(0, 255, 255, 255).withOpacity(.7),
                    //     fluent.Color.fromARGB(0, 255, 255, 255).withOpacity(.9),
                    //     fluent.Color.fromARGB(0, 255, 255, 255).withOpacity(.9),
                    //     fluent.Color.fromARGB(246, 255, 255, 255)
                    //         .withOpacity(1.0),
                    //   ],
                    // ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(203, 202, 202, 1.0)
                            .withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset:
                            const Offset(2, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(right: 15),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          mat.Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () {
                                // Combobox;
                                print("More options clicked");
                              },
                              icon: Icon(
                                mat.Icons.more_horiz,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          // Container(),
                          mat.Align(
                            alignment: Alignment.centerLeft,
                            child: Expanded(
                              child: Text(
                                event.name,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: mat.Colors.white,
                                    fontSize: 15,
                                    letterSpacing: 1,
                                    fontWeight: mat.FontWeight.w600),
                              ),
                            ),
                          ),
                          mat.Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(
                              dateTimeFormatter(event.date.toString())
                                  .toString(),
                              style: TextStyle(
                                color: mat.Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          )
                        ]),
                  ),
                ),
              ))
          .toList(),
    );
  }

  String dateTimeFormatter(String dateTime) {
    //Date and Time together (Military time)
    //[2021-12-01 23:34:00.0000]
    String dateTimeInfo = dateTime;

    //Splitting date and time
    String date = dateTimeInfo.split(" ")[0];
    String time = dateTimeInfo.split(" ")[1];

    //Splitting time
    String hours = time.split(":")[0];
    String minutes = time.split(":")[1];
    String seconds = time.split(":")[2];
    int hourInt = int.parse(hours);
    String formattedTime = "";

    //
    if (hourInt > 12) {
      hourInt = hourInt - 12;
      hours = hourInt.toString();
      formattedTime = hours + ":$minutes" + " PM";
    }

    if (hourInt == 12) {
      hours = '12';
      formattedTime = hours + ":$minutes" + " AM";
    } else {
      hours = hourInt.toString();
      formattedTime = hours + ":$minutes" + " AM";
    }

    //Splitting date
    String month = date.split("-")[1];
    String days = (date.split("-")[2]);
    String years = (date.split("-")[0]);
    String formattedDate = "";

    if (month == '01') {
      month = 'Jan ';
      formattedDate = (month + "$days, " + years + "    " + formattedTime);
    }
    if (month == '02') {
      month = 'Feb ';
      formattedDate = (month + "$days, " + years + "    " + formattedTime);
    }
    if (month == '03') {
      month = 'Mar ';
      formattedDate = (month + "$days, " + years + "   \n" + formattedTime);
    }
    if (month == '04') {
      month = 'Apr ';
      formattedDate = (month + "$days, " + years + "    " + formattedTime);
    }
    if (month == '05') {
      month = 'May ';
      formattedDate = (month + "$days, " + years + "    " + formattedTime);
    }
    if (month == '06') {
      month = 'Jun ';
      formattedDate = (month + "$days, " + years + "    " + formattedTime);
    }
    if (month == '07') {
      month = 'Jul ';
      formattedDate = (month + "$days, " + years + "    " + formattedTime);
    }
    if (month == '08') {
      month = 'Aug ';
      formattedDate = (month + "$days, " + years + "    " + formattedTime);
    }
    if (month == '09') {
      month = 'Sept ';
      formattedDate = (month + "$days, " + years + "    " + formattedTime);
    }
    if (month == '10') {
      month = 'Oct ';
      formattedDate = (month + "$days, " + years + "    " + formattedTime);
    }
    if (month == '11') {
      month = 'Nov ';
      formattedDate = (month + "$days, " + years + "    " + formattedTime);
    }
    if (month == '12') {
      month = 'Dec ';
      formattedDate = (month + "$days, " + years + "    " + formattedTime);
    }
    return formattedDate;
  }
}
