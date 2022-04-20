import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mat;
import 'package:project_dumangan/model/selected_event.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EventCountdown extends StatelessWidget {
  const EventCountdown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SelectedEvent event = context.read<SelectedEvent>();
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 0.0),
        padding: const EdgeInsets.only(left: 20.0),
        child: mat.Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 20, 0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: mat.Colors.white,
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
                  width: 200,
                  height: 220,
                  padding: const EdgeInsets.all(4),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(FluentIcons.timer),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              'Event Countdown',
                              style:
                                  FluentTheme.of(context).typography.bodyStrong,
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Column(children: [
                            Container(
                              height: 130,
                              width: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: FluentTheme.of(context)
                                    .accentColor
                                    .lightest
                                    .withOpacity(0.4),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${getDayDifference(DateFormat.yMd().parse(event.eventDate))}',
                                    style: FluentTheme.of(context)
                                        .typography
                                        .bodyStrong!
                                        .copyWith(fontSize: 60),
                                  ),
                                  Text(
                                    'Days',
                                    style: FluentTheme.of(context)
                                        .typography
                                        .bodyStrong!
                                        .copyWith(fontSize: 24),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 2.0,
                            ),
                            Text(
                              'Event Date: ${event.eventDate}',
                              style: FluentTheme.of(context)
                                  .typography
                                  .body!
                                  .copyWith(fontSize: 14, color: Colors.grey),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ]));
  }

  int getDayDifference(DateTime eventDate) {
    DateTime today = DateTime.now();
    DateTime to = DateTime(eventDate.year, eventDate.month, eventDate.day);
    if (today.isAfter(to)) {
      return 0;
    }
    DateTime now = DateTime(today.year, today.month, today.day);
    return to.difference(now).inDays;
  }
}
