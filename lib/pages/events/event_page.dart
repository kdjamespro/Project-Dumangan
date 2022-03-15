import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_dumangan/bloc/bloc/events_bloc.dart';

import '/model/selected_event.dart';
import 'dashboard_page.dart';
import 'event_selection_page.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key}) : super(key: key);

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EventsBloc(),
      child: BlocBuilder<EventsBloc, EventsState>(
        builder: ((context, state) {
          print(context.read<SelectedEvent>().isEventSet());
          if (state is EventsSelected ||
              context.read<SelectedEvent>().isEventSet()) {
            return BlocProvider.value(
              value: BlocProvider.of<EventsBloc>(context),
              child: const DashboardPage(),
            );
          }
          return BlocProvider.value(
            value: BlocProvider.of<EventsBloc>(context),
            child: const EventSelectionPage(),
          );
        }),
      ),
    );
  }
}
