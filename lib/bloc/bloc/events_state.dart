part of 'events_bloc.dart';

@immutable
abstract class EventsState {
  const EventsState();
}

class EventsSelecting extends EventsState {
  const EventsSelecting() : super();
}

class EventsSelected extends EventsState {
  const EventsSelected() : super();
}
