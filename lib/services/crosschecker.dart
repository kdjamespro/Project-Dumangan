import 'dart:math';

import 'package:drift/drift.dart';
import 'package:project_dumangan/database/database.dart';

class CrossChecker {
  Map regData;
  Map crossData;
  late List<Insertable> _participants;
  late List<Insertable> _absentees;
  int eventId;

  CrossChecker(
      {required this.regData, required this.crossData, required this.eventId}) {
    _participants = [];
    _absentees = [];
  }

  void crossCheck() {
    // Get the list from the map data
    List regNames = regData['Full Name'] ?? [];
    List regEmails = regData['Email'] ?? [];
    List regOrg = regData['Organization'] ?? [];

    if (regOrg.isEmpty) {
      regOrg = List<String>.generate(
          min(regNames.length, regEmails.length), (index) => '');
    }

    List crossNames = crossData['Full Name'] ?? [];
    List crossEmails = crossData['Email'] ?? [];

    List possibleParticipants = [];
    List possibleAbsentees = [];

    // Convert the names to lowercase and stores it to a new list
    List regSmallNames = regNames.map((e) => e.toLowerCase()).toList();
    List crossSmallNames = crossNames.map((e) => e.toLowerCase()).toList();

    // Iterate through the list and check if there is a matching participant
    for (int i = 0; i < min(regNames.length, regEmails.length); i++) {
      // Use the small Names for case insensitive comparison
      int match = crossSmallNames.indexOf(regSmallNames[i]);
      if (match >= 0) {
        //
        if (crossEmails[match] == regEmails[i]) {
          // Check if the particpant name exists in the possible Participants
          int index =
              _containsValue(possibleParticipants, 'Full Name', regNames[i]);

          if (index >= 0) {
            // Add the participants if the email is not the same
            if (!(possibleParticipants[index]['Email'] == regEmails[i])) {
              possibleParticipants.add({
                'Full Name': regNames[i],
                'Email': regEmails[i],
                'Organization': regOrg[i]
              });
            } else {
              possibleAbsentees.add({
                'Full Name': regNames[i],
                'Email': regEmails[i],
                'Organization': regOrg[i]
              });
            }
          } else {
            possibleParticipants.add({
              'Full Name': regNames[i],
              'Email': regEmails[i],
              'Organization': regOrg[i]
            });
          }
        } else {
          possibleAbsentees.add({
            'Full Name': regNames[i],
            'Email': regEmails[i],
            'Organization': regOrg[i]
          });
        }
      } else {
        possibleAbsentees.add({
          'Full Name': regNames[i],
          'Email': regEmails[i],
          'Organization': regOrg[i]
        });
      }
    }
    _addParticipants(possibleParticipants);
    _addAbsentees(possibleAbsentees);

    // print(possibleAbsentees);
  }

  int _containsValue(List listMap, String attribute, String value) {
    for (int i = 0; i < listMap.length; i++) {
      if (listMap[i].containsKey(attribute)) {
        if (listMap[i][attribute] == value) {
          return i;
        }
      }
    }
    return -1;
  }

  void _addParticipants(List map) {
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

  void _addAbsentees(List map) {
    for (var absent in map) {
      _absentees.add(
        ParticipantsTableCompanion.insert(
          eventsId: eventId,
          fullName: absent['Full Name'],
          email: absent['Email'],
          organization: Value(absent['Organization']),
          attended: const Value(false),
        ),
      );
    }
  }

  List<Insertable> get participants => _participants;
  List<Insertable> get absentees => _absentees;
}
