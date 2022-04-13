import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

// Note: Foreign key is not enable by default in sqlite3. To enable it, use:
// beforeOpen: (details) async {
//   await customStatement('PRAGMA foreign_keys = ON');
// }
// USE THIS BEFORE OPENING THE DATABASE

class ParticipantsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get eventsId => integer().references(EventsTable, #id)();
  TextColumn get fullName => text()();
  TextColumn get email => text()();
  BoolColumn get attended => boolean().withDefault(const Constant(false))();
  TextColumn get organization => text().nullable()();
}

class EventsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get location => text().nullable()();
  DateTimeColumn get date => dateTime()();
  IntColumn get participants => integer().withDefault(const Constant(0))();
  IntColumn get absentees => integer().withDefault(const Constant(0))();
  IntColumn get certificatesGenerated =>
      integer().withDefault(const Constant(0))();
}

class CertificatesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get participantsId =>
      integer().references(ParticipantsTable, #id).customConstraint('UNIQUE')();
  IntColumn get eventId => integer()();
  TextColumn get filename => text()();
  BoolColumn get sended => boolean().withDefault(const Constant(false))();
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [ParticipantsTable, EventsTable, CertificatesTable])
class MyDatabase extends _$MyDatabase {
  MyDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (m) async {
        return m.createAll();
      },
    );
  }

  Stream<List<EventsTableData>> getEvents() {
    return select(eventsTable).watch();
  }

  Stream<List<ParticipantsTableData>> getParticipants(int eventsId) {
    return (select(participantsTable)
          ..where((row) => row.eventsId.equals(eventsId)))
        .watch();
  }

  Future<List<ParticipantsTableData>> getAttendedParticipants(
      int eventsId) async {
    return await (select(participantsTable)
          ..where((row) =>
              row.eventsId.equals(eventsId) & row.attended.equals(true)))
        .get();
  }

  Future<String> getParticipantEmail(int participantId) async {
    return await customSelect(
      'SELECT email FROM participants_table WHERE id = ?',
      variables: [Variable.withInt(participantId)],
      readsFrom: {participantsTable},
    ).map((row) => row.read<String>('email')).getSingle();
  }

  Future<List<CertificatesTableData>> getCertificates(int eventsId) async {
    return await (select(certificatesTable)
          ..where((row) => row.eventId.equals(eventsId)))
        .get();
  }

  Future<void> addEvent(EventsTableCompanion event) {
    return into(eventsTable).insert(event);
  }

  Future updateEvent(int eventId, int participants, int absentees) async {
    return (update(eventsTable)..where((row) => row.id.equals(eventId)))
        .write(EventsTableCompanion(
      participants: Value(participants),
      absentees: Value(absentees),
    ));
  }

  Future updateCertStatus(int certId) async {
    return (update(certificatesTable)..where((row) => row.id.equals(certId)))
        .write(const CertificatesTableCompanion(sended: Value(true)));
  }

  Future updateEventCertificates(int eventId, int certGenerated) async {
    return await (update(eventsTable)..where((row) => row.id.equals(eventId)))
        .write(EventsTableCompanion(
      certificatesGenerated: Value(certGenerated),
    ));
  }

  Future<void> increaseParticipantCount(int eventId, int increase) {
    return customUpdate(
      'UPDATE events_table SET participants = participants + 1 WHERE event_id = ?',
      variables: [Variable.withInt(eventId)],
    );
  }

  Future<void> addParticipant(ParticipantsTableCompanion participant) {
    into(participantsTable).insert(participant);
    return increaseParticipantCount(participant.eventsId.value, 1);
  }

  Future<void> addBatchParticipants(List<Insertable> queryList) async {
    await batch((batch) {
      batch.insertAll(participantsTable, queryList);
    });
  }

  Future<void> addCertificates(List<Insertable> queryList) async {
    await batch((batch) {
      for (Insertable query in queryList) {
        batch.insert(certificatesTable, query,
            onConflict: DoUpdate((old) => query,
                target: [certificatesTable.participantsId]));
      }
    });
  }

  Future<int> getParticipantsCount(int eventId) async {
    if (eventId < 0) {
      return 0;
    }
    return await customSelect(
      'SELECT COUNT (*) as count FROM participants_table WHERE events_id = ?',
      variables: [Variable.withInt(eventId)],
      readsFrom: {participantsTable},
    ).map((row) => row.read<int>('count')).getSingle();
  }

  Future deleteParticipants(int id) {
    return (delete(participantsTable)..where((tbl) => tbl.eventsId.equals(id)))
        .go();
  }

  Future deleteParticipant(int participantId) {
    if (participantId < 0) {
      return Future(() {});
    } else {
      return (delete(participantsTable)
            ..where((tbl) => tbl.id.equals(participantId)))
          .go();
    }
  }

  Future deleteEvent(int eventId) {
    return (delete(eventsTable)..where((tbl) => tbl.id.equals(eventId))).go();
  }

  Stream<int> eventParticipantsCount(int eventId) {
    return customSelect(
      'SELECT participants FROM events_table WHERE events_id = ?',
      variables: [Variable.withInt(eventId)],
      readsFrom: {eventsTable},
    ).map((row) => row.read<int>('participants')).watchSingle();
  }

  Stream<int> eventAbsenteesCount(int eventId) {
    return customSelect(
      'SELECT absentees FROM events_table WHERE events_id = ?',
      variables: [Variable.withInt(eventId)],
      readsFrom: {eventsTable},
    ).map((row) => row.read<int>('participants')).watchSingle();
  }

  Future<List<int>> getParticipantsIds(int eventId) async {
    List<int> ids = [];
    if (eventId < 0) {
      return [];
    }
    List results = await customSelect(
      'SELECT id FROM participants_table WHERE events_id = ?',
      variables: [Variable.withInt(eventId)],
      readsFrom: {participantsTable},
    ).get();

    for (QueryRow row in results) {
      ids.add(row.read<int>('id'));
    }

    return ids;
  }
}
