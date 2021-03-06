import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_dumangan/bloc/bloc/events_bloc.dart';
import 'package:project_dumangan/database/database.dart';
import 'package:project_dumangan/model/attribute_mapping.dart';
import 'package:project_dumangan/model/crosscheck_mapping.dart';
import 'package:project_dumangan/model/selected_event.dart';
import 'package:project_dumangan/pages/events/event_countdown.dart';
import 'package:project_dumangan/services/pdf_generator.dart';
import 'event_table.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    SelectedEvent event = context.read<SelectedEvent>();
    MyDatabase db = context.read<MyDatabase>();
    db.updateEvent(
        event.eventId, event.eventParticipants, event.eventAbsentees);
    return mat.SafeArea(
      child: FluentApp(
        debugShowCheckedModeBanner: false,
        home: Container(
          color: FluentTheme.of(context).scaffoldBackgroundColor,
          padding:
              const EdgeInsets.only(left: 16, bottom: 8, right: 16, top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.eventName,
                          overflow: TextOverflow.ellipsis,
                          style: FluentTheme.of(context).typography.titleLarge,
                        ),
                      ),
                      const Spacer(),
                      Button(
                        child: Row(
                          children: const [
                            Icon(
                              FluentIcons.generate,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text('Generate \nEvent Report'),
                          ],
                        ),
                        onPressed: () async {
                          List<ParticipantsTableData> absentees =
                              await db.getAbsentees(event.eventId);
                          await PdfGenerator.generateReport(event, absentees);
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        child: FilledButton(
                            child: Row(
                              children: const [
                                Icon(FluentIcons.cancel),
                                SizedBox(width: 10),
                                Text('Select/Add \nAnother Event'),
                              ],
                            ),
                            onPressed: () {
                              context.read<AttributeMapping>().removeAll();
                              context.read<CrossCheckMapping>().removeAll();
                              event.clearEvent();
                              context.read<EventsBloc>().add(SelectEvent());
                            }),
                      )
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  const EventCountdown(),
                  Expanded(
                    child: Container(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 35, 20, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: mat.Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color.fromRGBO(203, 202, 202, 1.0)
                                            .withOpacity(0.4),
                                    spreadRadius: 2,
                                    blurRadius: 3,
                                    offset: const Offset(
                                        2, 1), // changes position of shadow
                                  ),
                                ],
                              ),
                              width: double.infinity,
                              height: 220,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Event\'s summary',
                                        style: FluentTheme.of(context)
                                            .typography
                                            .title,
                                      ),
                                    ),
                                    const Divider(
                                      size: double.infinity,
                                    ),
                                    const SizedBox(height: 25),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        DashStats(
                                            context,
                                            "Total Count\nof Registration",
                                            '${event.eventParticipants + event.eventAbsentees}'),
                                        DashStats(
                                            context,
                                            "Total Count\nof Participants",
                                            '${event.eventParticipants}'),
                                        DashStats(
                                            context,
                                            "Total Count\nof Absentees",
                                            '${event.eventAbsentees}'),
                                        DashStats(
                                            context,
                                            "Total Number of \nCertificates Generated",
                                            "${event.certficatesGenerated}"),
                                        // DashStats(
                                        //     context, "Average Rate of Events", "4.5"),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Expanded(child: EventTable()),
            ],
          ),
        ),
      ),
    );
  }

  Expanded DashStats(BuildContext context, String header, String number) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            header,
            style: FluentTheme.of(context).typography.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            number,
            style: FluentTheme.of(context).typography.titleLarge,
          ),
        ],
      ),
    );
  }
}
