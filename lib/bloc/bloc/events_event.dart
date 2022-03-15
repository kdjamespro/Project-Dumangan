part of 'events_bloc.dart';

@immutable
abstract class EventsEvent {
  const EventsEvent();
}

class SelectEvent extends EventsEvent {}

class LoadEvent extends EventsEvent {
  final int eventId;
  final MyDatabase db;
  const LoadEvent({required this.eventId, required this.db});
}
