import 'package:project_dumangan/database/database.dart';

class SelectedEvent {
  int _eventId;
  String _eventName;
  String _eventDescription;
  String _eventLocation;
  int _eventParticipants;
  int _eventAbsentees;
  int _certifacatesGenerated;

  SelectedEvent()
      : _eventId = -1,
        _eventName = '',
        _eventDescription = '',
        _eventLocation = '',
        _eventParticipants = 0,
        _eventAbsentees = 0,
        _certifacatesGenerated = 0;

  void setEvent(EventsTableData event) {
    _eventId = event.id;
    _eventName = event.name;
    _eventDescription = event.description ?? '';
    _eventParticipants = event.participants;
    _eventAbsentees = event.absentees;
  }

  void clearEvent() {
    _eventId = -1;
    _eventName = '';
    _eventDescription = '';
    _eventLocation = '';
    _eventParticipants = 0;
    _eventAbsentees = 0;
    _certifacatesGenerated = 0;
  }

  int get eventId => _eventId;

  String get eventName => _eventName;

  String get eventDescription => _eventDescription;

  String get eventLocation => _eventLocation;

  int get eventParticipants => _eventParticipants;

  int get eventAbsentees => _eventAbsentees;

  bool isEventSet() {
    return _eventId >= 0;
  }
}
