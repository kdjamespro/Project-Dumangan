import 'package:intl/intl.dart';
import 'package:project_dumangan/database/database.dart';

class SelectedEvent {
  int _eventId;
  String _eventName;
  String _eventDescription;
  String _eventLocation;
  int _eventParticipants;
  int _eventAbsentees;
  DateTime? _eventDate;
  int _certificatesGenerated;

  SelectedEvent()
      : _eventId = -1,
        _eventName = '',
        _eventDescription = '',
        _eventLocation = '',
        _eventParticipants = 0,
        _eventAbsentees = 0,
        _certificatesGenerated = 0;

  void setEvent(EventsTableData event) {
    _eventId = event.id;
    _eventName = event.name;
    _eventDescription = event.description ?? '';
    _eventParticipants = event.participants;
    _eventAbsentees = event.absentees;
    _eventDate = event.date;
    _certificatesGenerated = event.certificatesGenerated;
  }

  void clearEvent() {
    _eventId = -1;
    _eventName = '';
    _eventDescription = '';
    _eventLocation = '';
    _eventParticipants = 0;
    _eventAbsentees = 0;
    _certificatesGenerated = 0;
  }

  void updateAttendance(int present, int absent) {
    _eventParticipants = present;
    _eventAbsentees = absent;
  }

  void increaseParticipants(int num) {
    _eventParticipants += num;
  }

  void decreaseParticipants(int num) {
    _eventParticipants -= num;
  }

  void increaseAbsentees(int num) {
    _eventParticipants += num;
  }

  void decreaseAbsentees(int num) {
    _eventParticipants -= num;
  }

  void updateCertificatesCount(int num) {
    _certificatesGenerated = num;
  }

  int get eventId => _eventId;

  String get eventName => _eventName;

  String get eventDescription => _eventDescription;

  String get eventLocation => _eventLocation;

  int get eventParticipants => _eventParticipants;

  int get eventAbsentees => _eventAbsentees;

  int get certficatesGenerated => _certificatesGenerated;

  String get eventDate =>
      _eventDate == null ? '' : DateFormat.yMd().format(_eventDate as DateTime);

  bool isEventSet() {
    return _eventId >= 0;
  }
}
