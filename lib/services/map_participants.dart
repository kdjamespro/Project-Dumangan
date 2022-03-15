import 'dart:math';

import 'package:drift/drift.dart';
import 'package:project_dumangan/database/database.dart';

class MapParticipants {
  Map regData;
  int eventId;
  late List<Insertable> _participants;
  MapParticipants({required this.regData, required this.eventId}) {
    _participants = [];
    _parseData();
  }

  void _parseData() {
    List regNames = regData['Full Name'] ?? [];
    List regEmails = regData['Email'] ?? [];
    List regOrg = regData['Organization'] ?? [];

    if (regOrg.isEmpty) {
      regOrg = List<String>.generate(
          min(regNames.length, regEmails.length), (index) => '');
    }

    List participantsList = [];
    for (int i = 0; i < min(regNames.length, regEmails.length); i++) {
      participantsList.add({
        'Full Name': regNames[i],
        'Email': regEmails[i],
        'Organization': regOrg[i]
      });
    }
    _createQuery(participantsList);
  }

  void _createQuery(List map) {
    for (var participant in map) {
      _participants.add(ParticipantsTableCompanion.insert(
        eventsId: eventId,
        fullName: participant['Full Name'],
        email: participant['Email'],
        organization: Value(participant['Organization']),
        attended: const Value(true),
      ));
    }
  }

  List<Insertable> get participants => _participants;
}
