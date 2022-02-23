import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/rendering.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  DateTime today = DateTime.now();

  final flyoutController = FlyoutController();

  @override
  void dispose() {
    flyoutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      header: Container(
        padding: EdgeInsets.only(left: 16, bottom: 8, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Events',
              style: FluentTheme.of(context).typography.display,
            ),
            Divider(
              style: DividerThemeData(
                thickness: 2,
                horizontalMargin: EdgeInsets.zero,
              ),
            )
          ],
        ),
      ),
      content: Column(
        children: [
          Flexible(
            flex: 1,
            child: Flyout(
              verticalOffset: 24,
              controller: flyoutController,
              contentWidth: 600,
              content: Container(
                height: 500,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(vertical: 16.0),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Event',
                        style: FluentTheme.of(context).typography.title,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(
                          style: DividerThemeData(
                            thickness: 2,
                            horizontalMargin: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      TextFormBox(
                        header: 'Event Title *',
                        placeholder: 'Type the events name',
                      ),
                      TextBox(
                        minHeight: 100,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        header: 'Event Description',
                        placeholder: 'Add brief description of the event',
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 1,
                            child: DatePicker(header: 'Date', selected: today),
                          ),
                          Flexible(
                            flex: 1,
                            child: TimePicker(header: 'Time', selected: today),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              child: Button(
                child: Text('Add Event'),
                onPressed: () {
                  flyoutController.open = true;
                },
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              color: Colors.green,
            ),
          )
        ],
      ),
    );
  }
}
