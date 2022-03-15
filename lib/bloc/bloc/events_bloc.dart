import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:project_dumangan/database/database.dart';

part 'events_event.dart';
part 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  EventsBloc() : super(const EventsSelecting()) {
    on<SelectEvent>((event, emit) {
      emit(const EventsSelecting());
    });
    on<LoadEvent>((event, emit) {
      emit(const EventsSelected());
    });
  }
}
