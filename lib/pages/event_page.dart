import 'package:drift/drift.dart' as drift;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:project_dumangan/database/database.dart';
import 'package:provider/provider.dart';

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
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: Container(
        padding: const EdgeInsets.only(left: 16, bottom: 8, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Events',
              style: FluentTheme.of(context).typography.display,
            ),
            const Divider(
              style: DividerThemeData(
                thickness: 2,
                horizontalMargin: EdgeInsets.zero,
              ),
            )
          ],
        ),
      ),
      content: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Event',
                  style: FluentTheme.of(context).typography.title,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: const Divider(
                    style: DividerThemeData(
                      thickness: 2,
                      horizontalMargin: EdgeInsets.zero,
                    ),
                  ),
                ),
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
                TextFormBox(
                  controller: locationController,
                  header: 'Location / Meeting Room',
                  placeholder: 'Type the event\'s location',
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 240,
                      child: TextBox(
                        keyboardType: TextInputType.datetime,
                        controller: dateController,
                        header: 'Date',
                        placeholder: 'Type event\'s date',
                      ),
                    ),
                    SizedBox(
                      width: 240,
                      child: TimePicker(
                        header: 'Starts At',
                        selected: date,
                        onChanged: (selectedDate) =>
                            setState(() => date = selectedDate),
                      ),
                    ),
                  ],
                ),
                FilledButton(
                    child: Text('Add New Event'),
                    onPressed: () async {
                      MyDatabase db =
                          Provider.of<MyDatabase>(context, listen: false);
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
              ],
            ),
            Flexible(
              flex: 1,
              child: Container(
                child: StreamBuilder(
                  stream: Provider.of<MyDatabase>(context, listen: false)
                      .getEvents(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.active:
                        List<EventsTableData> events =
                            snapshot.data as List<EventsTableData>;
                        print(events.length);
                        return Row(
                          children: events
                              .map((event) => GestureDetector(
                                    onTap: () {
                                      print(event.id);
                                    },
                                    child: Column(children: [
                                      Text(event.name),
                                      Text(event.date.toString())
                                    ]),
                                  ))
                              .toList(),
                        );
                    }
                    return Container();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
