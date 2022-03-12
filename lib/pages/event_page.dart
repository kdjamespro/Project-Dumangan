import 'package:drift/drift.dart' as drift;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:project_dumangan/database/database.dart';
import 'package:project_dumangan/services/date_text_input_formatter.dart';
import 'package:project_dumangan/services/utils.dart';
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Events',
              style: FluentTheme.of(context).typography.display,
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
                              child: TextFormBox(
                                validator: Utils.dateValidator,
                                keyboardType: TextInputType.datetime,
                                inputFormatters: [DateTextInputFormatter()],
                                controller: dateController,
                                header: 'Date',
                                placeholder: 'Type event\'s date',
                              ),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            Expanded(
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
                                String title = eventsTitleController.text;
                                String desc = eventsDescController.text;
                                String setDate = dateController.text;
                                DateTime eventDate =
                                    DateFormat('dd/MM/yyyy').parse(setDate);
                                await db.addEvent(EventsTableCompanion(
                                  name: drift.Value(title),
                                  description: drift.Value(desc),
                                  date: drift.Value(eventDate),
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
              child: StreamBuilder(
                stream:
                    Provider.of<MyDatabase>(context, listen: false).getEvents(),
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
    );
  }
}
