import 'package:drift/drift.dart' as drift;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' as mat;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:project_dumangan/bloc/bloc/events_bloc.dart';
import 'package:project_dumangan/database/database.dart';
import 'package:project_dumangan/services/verify_message.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '/model/selected_event.dart';
import 'event_info.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart' as picker;

class EventSelectionPage extends StatefulWidget {
  const EventSelectionPage({Key? key}) : super(key: key);

  @override
  State<EventSelectionPage> createState() => _EventSelectionPageState();
}

class _EventSelectionPageState extends State<EventSelectionPage> {
  DateTime date = DateTime.now();

  late TextEditingController eventsTitleController;
  late TextEditingController eventsDescController;
  late TextEditingController locationController;
  late TextEditingController dateController;
  final ScrollController _firstController = ScrollController();
  final FlyoutController calendarFlyout = FlyoutController();
  final DateFormat df = DateFormat('MM/dd/yyyy');
  late final dateTimeController =
      TextEditingController(text: DateTime.now().toString());
  final formKey = GlobalKey<FormState>();

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
    dateTimeController.dispose();
    dateController.dispose();
    _firstController.dispose();
    super.dispose();
  }

  void clearController() {
    eventsTitleController.clear();
    eventsDescController.clear();
    locationController.clear();
    dateController.clear();
  }

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
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextFormBox(
                          header: 'Event Title',
                          placeholder: 'Type the event\'s name',
                          controller: eventsTitleController,
                          validator: (text) {
                            if (text == null || text.isEmpty) {
                              return 'Event\'s name is required';
                            }
                          },
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
                  const SizedBox(
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flyout(
                                child: Expanded(
                                    child: TextFormBox(
                                  prefix: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Icon(FluentIcons.calendar),
                                  ),
                                  header: 'Event\'s Date',
                                  controller: dateController,
                                  validator: (text) {
                                    if (text == null || text.isEmpty) {
                                      return 'Date Field is required';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    calendarFlyout.open = true;
                                  },
                                  readOnly: true,
                                )),
                                content: SizedBox(
                                  height: 300,
                                  child: Card(
                                    backgroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 8.0),
                                    child: SfDateRangePicker(
                                      initialSelectedDate: DateTime.now(),
                                      viewSpacing: 10,
                                      showActionButtons: true,
                                      showNavigationArrow: true,
                                      onCancel: () {
                                        calendarFlyout.open = false;
                                      },
                                      onSubmit: (date) {
                                        if (date != null) {
                                          var selected =
                                              df.format(date as DateTime);
                                          dateController.text = selected;

                                          calendarFlyout.open = false;
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                contentWidth: 500,
                                controller: calendarFlyout),
                            const SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              // Here Kirk
                              child: TimePicker(
                                  header: 'Starts At',
                                  selected: date,
                                  onChanged: (selectedDate) =>
                                      print(selectedDate)),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 630,
                          child: FilledButton(
                              child: const Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text('Add New Event'),
                              ),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  MyDatabase db = Provider.of<MyDatabase>(
                                      context,
                                      listen: false);
                                  String title = eventsTitleController.text;
                                  String desc = eventsDescController.text;
                                  String setDate = dateController.text;
                                  DateTime eventDate = df.parse(setDate);
                                  print(eventDate);
                                  await db.addEvent(EventsTableCompanion(
                                    name: drift.Value(title),
                                    description: drift.Value(desc),
                                    date: drift.Value(eventDate),
                                    absentees: const drift.Value(0),
                                    participants: const drift.Value(0),
                                  ));
                                  clearController();
                                  MotionToast.success(
                                          animationDuration:
                                              const Duration(seconds: 1),
                                          animationCurve: Curves.easeOut,
                                          toastDuration:
                                              const Duration(seconds: 2),
                                          description:
                                              const Text('New Event Added'))
                                      .show(context);
                                } else {
                                  MotionToast.error(
                                    animationDuration:
                                        const Duration(seconds: 1),
                                    animationCurve: Curves.easeOut,
                                    toastDuration: const Duration(seconds: 2),
                                    description: const Text(
                                        'Event Addition Failed! Please fill up the details in the form'),
                                  ).show(context);
                                }
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
                isAlwaysShown: false,
                controller: _firstController,
                child: ScrollConfiguration(
                  behavior:
                      ScrollConfiguration.of(context).copyWith(dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                  }),
                  child: ListView.builder(
                      primary: false,
                      // Uncomment this is you want to check is the item was added
                      // reverse: true,
                      controller: _firstController,
                      padding: EdgeInsets.only(bottom: 20),
                      scrollDirection: Axis.horizontal,
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
                                    case ConnectionState.done:
                                    case ConnectionState.active:
                                      if (snapshot.data != null) {
                                        List<EventsTableData> events = snapshot
                                            .data as List<EventsTableData>;
                                        print(events.length);
                                        return EventCard(events);
                                      }
                                      break;
                                    case ConnectionState.waiting:
                                      return const Center(
                                        child: ProgressRing(),
                                      );
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
                onTap: () async {
                  int selectedEventId = await Navigator.push(
                    context,
                    FluentPageRoute(
                      builder: (_) => EventInfo(
                        event: event,
                      ),
                    ),
                  );
                  if (selectedEventId >= 0) {
                    context.read<SelectedEvent>().setEvent(event);
                    context.read<EventsBloc>().add(LoadEvent(
                        eventId: selectedEventId,
                        db: context.read<MyDatabase>()));
                    print('Selected Event: $selectedEventId');
                    print('Event: ${event.id}');
                  }
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
                              onPressed: () async {
                                bool proceed = await showVerificationMessage(
                                    context: context,
                                    title: 'Delete Event',
                                    message:
                                        'Do you really want to delete the selected event?');
                                if (proceed) {
                                  await context
                                      .read<MyDatabase>()
                                      .deleteEvent(event.id);
                                  MotionToast.delete(
                                          animationDuration:
                                              const Duration(seconds: 1),
                                          animationCurve: Curves.easeOut,
                                          toastDuration:
                                              const Duration(seconds: 2),
                                          description: const Text(
                                              'Event Successfully Deleted'))
                                      .show(context);
                                }
                              },
                              icon: const Icon(
                                FluentIcons.delete,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          // Container(),
                          mat.Align(
                            alignment: Alignment.centerLeft,
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


// TextFormBox(
//                                 // validator: Utils.dateValidator,
//                                 keyboardType: TextInputType.datetime,
//                                 inputFormatters: [DateTextInputFormatter()],
//                                 controller: dateController,
//                                 header: 'Date',
//                                 placeholder: 'Type event\'s date',
//                               ),

// IconButton(
//                               onPressed: () {
//                                 // Combobox;
//                                 print("More options clicked");
//                               },
//                               icon: Icon(
//                                 mat.Icons.more_horiz,
//                                 color: Colors.white,
//                                 size: 20,
//                               ),
//                             ),