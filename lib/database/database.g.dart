// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class EventsTableData extends DataClass implements Insertable<EventsTableData> {
  final int id;
  final String name;
  final String? description;
  final String? location;
  final DateTime date;
  final int participants;
  final int absentees;
  final int certificatesGenerated;
  EventsTableData(
      {required this.id,
      required this.name,
      this.description,
      this.location,
      required this.date,
      required this.participants,
      required this.absentees,
      required this.certificatesGenerated});
  factory EventsTableData.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return EventsTableData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      description: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}description']),
      location: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}location']),
      date: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}date'])!,
      participants: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}participants'])!,
      absentees: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}absentees'])!,
      certificatesGenerated: const IntType().mapFromDatabaseResponse(
          data['${effectivePrefix}certificates_generated'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String?>(description);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String?>(location);
    }
    map['date'] = Variable<DateTime>(date);
    map['participants'] = Variable<int>(participants);
    map['absentees'] = Variable<int>(absentees);
    map['certificates_generated'] = Variable<int>(certificatesGenerated);
    return map;
  }

  EventsTableCompanion toCompanion(bool nullToAbsent) {
    return EventsTableCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      date: Value(date),
      participants: Value(participants),
      absentees: Value(absentees),
      certificatesGenerated: Value(certificatesGenerated),
    );
  }

  factory EventsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EventsTableData(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      location: serializer.fromJson<String?>(json['location']),
      date: serializer.fromJson<DateTime>(json['date']),
      participants: serializer.fromJson<int>(json['participants']),
      absentees: serializer.fromJson<int>(json['absentees']),
      certificatesGenerated:
          serializer.fromJson<int>(json['certificatesGenerated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'location': serializer.toJson<String?>(location),
      'date': serializer.toJson<DateTime>(date),
      'participants': serializer.toJson<int>(participants),
      'absentees': serializer.toJson<int>(absentees),
      'certificatesGenerated': serializer.toJson<int>(certificatesGenerated),
    };
  }

  EventsTableData copyWith(
          {int? id,
          String? name,
          String? description,
          String? location,
          DateTime? date,
          int? participants,
          int? absentees,
          int? certificatesGenerated}) =>
      EventsTableData(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        location: location ?? this.location,
        date: date ?? this.date,
        participants: participants ?? this.participants,
        absentees: absentees ?? this.absentees,
        certificatesGenerated:
            certificatesGenerated ?? this.certificatesGenerated,
      );
  @override
  String toString() {
    return (StringBuffer('EventsTableData(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('location: $location, ')
          ..write('date: $date, ')
          ..write('participants: $participants, ')
          ..write('absentees: $absentees, ')
          ..write('certificatesGenerated: $certificatesGenerated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, location, date,
      participants, absentees, certificatesGenerated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EventsTableData &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.location == this.location &&
          other.date == this.date &&
          other.participants == this.participants &&
          other.absentees == this.absentees &&
          other.certificatesGenerated == this.certificatesGenerated);
}

class EventsTableCompanion extends UpdateCompanion<EventsTableData> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> location;
  final Value<DateTime> date;
  final Value<int> participants;
  final Value<int> absentees;
  final Value<int> certificatesGenerated;
  const EventsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.location = const Value.absent(),
    this.date = const Value.absent(),
    this.participants = const Value.absent(),
    this.absentees = const Value.absent(),
    this.certificatesGenerated = const Value.absent(),
  });
  EventsTableCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.description = const Value.absent(),
    this.location = const Value.absent(),
    required DateTime date,
    this.participants = const Value.absent(),
    this.absentees = const Value.absent(),
    this.certificatesGenerated = const Value.absent(),
  })  : name = Value(name),
        date = Value(date);
  static Insertable<EventsTableData> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String?>? description,
    Expression<String?>? location,
    Expression<DateTime>? date,
    Expression<int>? participants,
    Expression<int>? absentees,
    Expression<int>? certificatesGenerated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (location != null) 'location': location,
      if (date != null) 'date': date,
      if (participants != null) 'participants': participants,
      if (absentees != null) 'absentees': absentees,
      if (certificatesGenerated != null)
        'certificates_generated': certificatesGenerated,
    });
  }

  EventsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<String?>? description,
      Value<String?>? location,
      Value<DateTime>? date,
      Value<int>? participants,
      Value<int>? absentees,
      Value<int>? certificatesGenerated}) {
    return EventsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      date: date ?? this.date,
      participants: participants ?? this.participants,
      absentees: absentees ?? this.absentees,
      certificatesGenerated:
          certificatesGenerated ?? this.certificatesGenerated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String?>(description.value);
    }
    if (location.present) {
      map['location'] = Variable<String?>(location.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (participants.present) {
      map['participants'] = Variable<int>(participants.value);
    }
    if (absentees.present) {
      map['absentees'] = Variable<int>(absentees.value);
    }
    if (certificatesGenerated.present) {
      map['certificates_generated'] =
          Variable<int>(certificatesGenerated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EventsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('location: $location, ')
          ..write('date: $date, ')
          ..write('participants: $participants, ')
          ..write('absentees: $absentees, ')
          ..write('certificatesGenerated: $certificatesGenerated')
          ..write(')'))
        .toString();
  }
}

class $EventsTableTable extends EventsTable
    with TableInfo<$EventsTableTable, EventsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EventsTableTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String?> description = GeneratedColumn<String?>(
      'description', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _locationMeta = const VerificationMeta('location');
  @override
  late final GeneratedColumn<String?> location = GeneratedColumn<String?>(
      'location', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  final VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime?> date = GeneratedColumn<DateTime?>(
      'date', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _participantsMeta =
      const VerificationMeta('participants');
  @override
  late final GeneratedColumn<int?> participants = GeneratedColumn<int?>(
      'participants', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  final VerificationMeta _absenteesMeta = const VerificationMeta('absentees');
  @override
  late final GeneratedColumn<int?> absentees = GeneratedColumn<int?>(
      'absentees', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: const Constant(0));
  final VerificationMeta _certificatesGeneratedMeta =
      const VerificationMeta('certificatesGenerated');
  @override
  late final GeneratedColumn<int?> certificatesGenerated =
      GeneratedColumn<int?>('certificates_generated', aliasedName, false,
          type: const IntType(),
          requiredDuringInsert: false,
          defaultValue: const Constant(0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        description,
        location,
        date,
        participants,
        absentees,
        certificatesGenerated
      ];
  @override
  String get aliasedName => _alias ?? 'events_table';
  @override
  String get actualTableName => 'events_table';
  @override
  VerificationContext validateIntegrity(Insertable<EventsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('location')) {
      context.handle(_locationMeta,
          location.isAcceptableOrUnknown(data['location']!, _locationMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('participants')) {
      context.handle(
          _participantsMeta,
          participants.isAcceptableOrUnknown(
              data['participants']!, _participantsMeta));
    }
    if (data.containsKey('absentees')) {
      context.handle(_absenteesMeta,
          absentees.isAcceptableOrUnknown(data['absentees']!, _absenteesMeta));
    }
    if (data.containsKey('certificates_generated')) {
      context.handle(
          _certificatesGeneratedMeta,
          certificatesGenerated.isAcceptableOrUnknown(
              data['certificates_generated']!, _certificatesGeneratedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EventsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return EventsTableData.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $EventsTableTable createAlias(String alias) {
    return $EventsTableTable(attachedDatabase, alias);
  }
}

class ParticipantsTableData extends DataClass
    implements Insertable<ParticipantsTableData> {
  final int id;
  final int eventsId;
  final String fullName;
  final String email;
  final bool attended;
  final String? organization;
  ParticipantsTableData(
      {required this.id,
      required this.eventsId,
      required this.fullName,
      required this.email,
      required this.attended,
      this.organization});
  factory ParticipantsTableData.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return ParticipantsTableData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      eventsId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}events_id'])!,
      fullName: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}full_name'])!,
      email: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}email'])!,
      attended: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}attended'])!,
      organization: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}organization']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['events_id'] = Variable<int>(eventsId);
    map['full_name'] = Variable<String>(fullName);
    map['email'] = Variable<String>(email);
    map['attended'] = Variable<bool>(attended);
    if (!nullToAbsent || organization != null) {
      map['organization'] = Variable<String?>(organization);
    }
    return map;
  }

  ParticipantsTableCompanion toCompanion(bool nullToAbsent) {
    return ParticipantsTableCompanion(
      id: Value(id),
      eventsId: Value(eventsId),
      fullName: Value(fullName),
      email: Value(email),
      attended: Value(attended),
      organization: organization == null && nullToAbsent
          ? const Value.absent()
          : Value(organization),
    );
  }

  factory ParticipantsTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ParticipantsTableData(
      id: serializer.fromJson<int>(json['id']),
      eventsId: serializer.fromJson<int>(json['eventsId']),
      fullName: serializer.fromJson<String>(json['fullName']),
      email: serializer.fromJson<String>(json['email']),
      attended: serializer.fromJson<bool>(json['attended']),
      organization: serializer.fromJson<String?>(json['organization']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'eventsId': serializer.toJson<int>(eventsId),
      'fullName': serializer.toJson<String>(fullName),
      'email': serializer.toJson<String>(email),
      'attended': serializer.toJson<bool>(attended),
      'organization': serializer.toJson<String?>(organization),
    };
  }

  ParticipantsTableData copyWith(
          {int? id,
          int? eventsId,
          String? fullName,
          String? email,
          bool? attended,
          String? organization}) =>
      ParticipantsTableData(
        id: id ?? this.id,
        eventsId: eventsId ?? this.eventsId,
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        attended: attended ?? this.attended,
        organization: organization ?? this.organization,
      );
  @override
  String toString() {
    return (StringBuffer('ParticipantsTableData(')
          ..write('id: $id, ')
          ..write('eventsId: $eventsId, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('attended: $attended, ')
          ..write('organization: $organization')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, eventsId, fullName, email, attended, organization);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ParticipantsTableData &&
          other.id == this.id &&
          other.eventsId == this.eventsId &&
          other.fullName == this.fullName &&
          other.email == this.email &&
          other.attended == this.attended &&
          other.organization == this.organization);
}

class ParticipantsTableCompanion
    extends UpdateCompanion<ParticipantsTableData> {
  final Value<int> id;
  final Value<int> eventsId;
  final Value<String> fullName;
  final Value<String> email;
  final Value<bool> attended;
  final Value<String?> organization;
  const ParticipantsTableCompanion({
    this.id = const Value.absent(),
    this.eventsId = const Value.absent(),
    this.fullName = const Value.absent(),
    this.email = const Value.absent(),
    this.attended = const Value.absent(),
    this.organization = const Value.absent(),
  });
  ParticipantsTableCompanion.insert({
    this.id = const Value.absent(),
    required int eventsId,
    required String fullName,
    required String email,
    this.attended = const Value.absent(),
    this.organization = const Value.absent(),
  })  : eventsId = Value(eventsId),
        fullName = Value(fullName),
        email = Value(email);
  static Insertable<ParticipantsTableData> custom({
    Expression<int>? id,
    Expression<int>? eventsId,
    Expression<String>? fullName,
    Expression<String>? email,
    Expression<bool>? attended,
    Expression<String?>? organization,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (eventsId != null) 'events_id': eventsId,
      if (fullName != null) 'full_name': fullName,
      if (email != null) 'email': email,
      if (attended != null) 'attended': attended,
      if (organization != null) 'organization': organization,
    });
  }

  ParticipantsTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? eventsId,
      Value<String>? fullName,
      Value<String>? email,
      Value<bool>? attended,
      Value<String?>? organization}) {
    return ParticipantsTableCompanion(
      id: id ?? this.id,
      eventsId: eventsId ?? this.eventsId,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      attended: attended ?? this.attended,
      organization: organization ?? this.organization,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (eventsId.present) {
      map['events_id'] = Variable<int>(eventsId.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (attended.present) {
      map['attended'] = Variable<bool>(attended.value);
    }
    if (organization.present) {
      map['organization'] = Variable<String?>(organization.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ParticipantsTableCompanion(')
          ..write('id: $id, ')
          ..write('eventsId: $eventsId, ')
          ..write('fullName: $fullName, ')
          ..write('email: $email, ')
          ..write('attended: $attended, ')
          ..write('organization: $organization')
          ..write(')'))
        .toString();
  }
}

class $ParticipantsTableTable extends ParticipantsTable
    with TableInfo<$ParticipantsTableTable, ParticipantsTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ParticipantsTableTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _eventsIdMeta = const VerificationMeta('eventsId');
  @override
  late final GeneratedColumn<int?> eventsId = GeneratedColumn<int?>(
      'events_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      defaultConstraints: 'REFERENCES events_table (id)');
  final VerificationMeta _fullNameMeta = const VerificationMeta('fullName');
  @override
  late final GeneratedColumn<String?> fullName = GeneratedColumn<String?>(
      'full_name', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String?> email = GeneratedColumn<String?>(
      'email', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _attendedMeta = const VerificationMeta('attended');
  @override
  late final GeneratedColumn<bool?> attended = GeneratedColumn<bool?>(
      'attended', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (attended IN (0, 1))',
      defaultValue: const Constant(false));
  final VerificationMeta _organizationMeta =
      const VerificationMeta('organization');
  @override
  late final GeneratedColumn<String?> organization = GeneratedColumn<String?>(
      'organization', aliasedName, true,
      type: const StringType(), requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, eventsId, fullName, email, attended, organization];
  @override
  String get aliasedName => _alias ?? 'participants_table';
  @override
  String get actualTableName => 'participants_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<ParticipantsTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('events_id')) {
      context.handle(_eventsIdMeta,
          eventsId.isAcceptableOrUnknown(data['events_id']!, _eventsIdMeta));
    } else if (isInserting) {
      context.missing(_eventsIdMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(_fullNameMeta,
          fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta));
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
          _emailMeta, email.isAcceptableOrUnknown(data['email']!, _emailMeta));
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('attended')) {
      context.handle(_attendedMeta,
          attended.isAcceptableOrUnknown(data['attended']!, _attendedMeta));
    }
    if (data.containsKey('organization')) {
      context.handle(
          _organizationMeta,
          organization.isAcceptableOrUnknown(
              data['organization']!, _organizationMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ParticipantsTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return ParticipantsTableData.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $ParticipantsTableTable createAlias(String alias) {
    return $ParticipantsTableTable(attachedDatabase, alias);
  }
}

class CertificatesTableData extends DataClass
    implements Insertable<CertificatesTableData> {
  final int id;
  final int participantsId;
  final int eventId;
  final String filename;
  final bool sended;
  CertificatesTableData(
      {required this.id,
      required this.participantsId,
      required this.eventId,
      required this.filename,
      required this.sended});
  factory CertificatesTableData.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return CertificatesTableData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      participantsId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}participants_id'])!,
      eventId: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}event_id'])!,
      filename: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}filename'])!,
      sended: const BoolType()
          .mapFromDatabaseResponse(data['${effectivePrefix}sended'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['participants_id'] = Variable<int>(participantsId);
    map['event_id'] = Variable<int>(eventId);
    map['filename'] = Variable<String>(filename);
    map['sended'] = Variable<bool>(sended);
    return map;
  }

  CertificatesTableCompanion toCompanion(bool nullToAbsent) {
    return CertificatesTableCompanion(
      id: Value(id),
      participantsId: Value(participantsId),
      eventId: Value(eventId),
      filename: Value(filename),
      sended: Value(sended),
    );
  }

  factory CertificatesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CertificatesTableData(
      id: serializer.fromJson<int>(json['id']),
      participantsId: serializer.fromJson<int>(json['participantsId']),
      eventId: serializer.fromJson<int>(json['eventId']),
      filename: serializer.fromJson<String>(json['filename']),
      sended: serializer.fromJson<bool>(json['sended']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'participantsId': serializer.toJson<int>(participantsId),
      'eventId': serializer.toJson<int>(eventId),
      'filename': serializer.toJson<String>(filename),
      'sended': serializer.toJson<bool>(sended),
    };
  }

  CertificatesTableData copyWith(
          {int? id,
          int? participantsId,
          int? eventId,
          String? filename,
          bool? sended}) =>
      CertificatesTableData(
        id: id ?? this.id,
        participantsId: participantsId ?? this.participantsId,
        eventId: eventId ?? this.eventId,
        filename: filename ?? this.filename,
        sended: sended ?? this.sended,
      );
  @override
  String toString() {
    return (StringBuffer('CertificatesTableData(')
          ..write('id: $id, ')
          ..write('participantsId: $participantsId, ')
          ..write('eventId: $eventId, ')
          ..write('filename: $filename, ')
          ..write('sended: $sended')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, participantsId, eventId, filename, sended);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CertificatesTableData &&
          other.id == this.id &&
          other.participantsId == this.participantsId &&
          other.eventId == this.eventId &&
          other.filename == this.filename &&
          other.sended == this.sended);
}

class CertificatesTableCompanion
    extends UpdateCompanion<CertificatesTableData> {
  final Value<int> id;
  final Value<int> participantsId;
  final Value<int> eventId;
  final Value<String> filename;
  final Value<bool> sended;
  const CertificatesTableCompanion({
    this.id = const Value.absent(),
    this.participantsId = const Value.absent(),
    this.eventId = const Value.absent(),
    this.filename = const Value.absent(),
    this.sended = const Value.absent(),
  });
  CertificatesTableCompanion.insert({
    this.id = const Value.absent(),
    required int participantsId,
    required int eventId,
    required String filename,
    this.sended = const Value.absent(),
  })  : participantsId = Value(participantsId),
        eventId = Value(eventId),
        filename = Value(filename);
  static Insertable<CertificatesTableData> custom({
    Expression<int>? id,
    Expression<int>? participantsId,
    Expression<int>? eventId,
    Expression<String>? filename,
    Expression<bool>? sended,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (participantsId != null) 'participants_id': participantsId,
      if (eventId != null) 'event_id': eventId,
      if (filename != null) 'filename': filename,
      if (sended != null) 'sended': sended,
    });
  }

  CertificatesTableCompanion copyWith(
      {Value<int>? id,
      Value<int>? participantsId,
      Value<int>? eventId,
      Value<String>? filename,
      Value<bool>? sended}) {
    return CertificatesTableCompanion(
      id: id ?? this.id,
      participantsId: participantsId ?? this.participantsId,
      eventId: eventId ?? this.eventId,
      filename: filename ?? this.filename,
      sended: sended ?? this.sended,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (participantsId.present) {
      map['participants_id'] = Variable<int>(participantsId.value);
    }
    if (eventId.present) {
      map['event_id'] = Variable<int>(eventId.value);
    }
    if (filename.present) {
      map['filename'] = Variable<String>(filename.value);
    }
    if (sended.present) {
      map['sended'] = Variable<bool>(sended.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CertificatesTableCompanion(')
          ..write('id: $id, ')
          ..write('participantsId: $participantsId, ')
          ..write('eventId: $eventId, ')
          ..write('filename: $filename, ')
          ..write('sended: $sended')
          ..write(')'))
        .toString();
  }
}

class $CertificatesTableTable extends CertificatesTable
    with TableInfo<$CertificatesTableTable, CertificatesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CertificatesTableTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _participantsIdMeta =
      const VerificationMeta('participantsId');
  @override
  late final GeneratedColumn<int?> participantsId = GeneratedColumn<int?>(
      'participants_id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: true,
      $customConstraints: 'UNIQUE');
  final VerificationMeta _eventIdMeta = const VerificationMeta('eventId');
  @override
  late final GeneratedColumn<int?> eventId = GeneratedColumn<int?>(
      'event_id', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _filenameMeta = const VerificationMeta('filename');
  @override
  late final GeneratedColumn<String?> filename = GeneratedColumn<String?>(
      'filename', aliasedName, false,
      type: const StringType(), requiredDuringInsert: true);
  final VerificationMeta _sendedMeta = const VerificationMeta('sended');
  @override
  late final GeneratedColumn<bool?> sended = GeneratedColumn<bool?>(
      'sended', aliasedName, false,
      type: const BoolType(),
      requiredDuringInsert: false,
      defaultConstraints: 'CHECK (sended IN (0, 1))',
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, participantsId, eventId, filename, sended];
  @override
  String get aliasedName => _alias ?? 'certificates_table';
  @override
  String get actualTableName => 'certificates_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<CertificatesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('participants_id')) {
      context.handle(
          _participantsIdMeta,
          participantsId.isAcceptableOrUnknown(
              data['participants_id']!, _participantsIdMeta));
    } else if (isInserting) {
      context.missing(_participantsIdMeta);
    }
    if (data.containsKey('event_id')) {
      context.handle(_eventIdMeta,
          eventId.isAcceptableOrUnknown(data['event_id']!, _eventIdMeta));
    } else if (isInserting) {
      context.missing(_eventIdMeta);
    }
    if (data.containsKey('filename')) {
      context.handle(_filenameMeta,
          filename.isAcceptableOrUnknown(data['filename']!, _filenameMeta));
    } else if (isInserting) {
      context.missing(_filenameMeta);
    }
    if (data.containsKey('sended')) {
      context.handle(_sendedMeta,
          sended.isAcceptableOrUnknown(data['sended']!, _sendedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CertificatesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return CertificatesTableData.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $CertificatesTableTable createAlias(String alias) {
    return $CertificatesTableTable(attachedDatabase, alias);
  }
}

abstract class _$MyDatabase extends GeneratedDatabase {
  _$MyDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $EventsTableTable eventsTable = $EventsTableTable(this);
  late final $ParticipantsTableTable participantsTable =
      $ParticipantsTableTable(this);
  late final $CertificatesTableTable certificatesTable =
      $CertificatesTableTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [eventsTable, participantsTable, certificatesTable];
}
