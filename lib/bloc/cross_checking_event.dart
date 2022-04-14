part of 'cross_checking_bloc.dart';

@immutable
abstract class CrossCheckingEvent {}

class CrossChekingInitialize extends CrossCheckingEvent {}

class CrossChekingEnable extends CrossCheckingEvent {}

class CrossChekingDisable extends CrossCheckingEvent {}

class CrossChekingStart extends CrossCheckingEvent {
  final List<File> files;
  final bool crossCheck;
  CrossChekingStart({required this.files, required this.crossCheck});
}

class CrossCheckingProceed extends CrossCheckingEvent {
  final Map<String, List> crossData;
  final bool crossCheck;
  final Map<String, List> data;
  CrossCheckingProceed(
      {required this.crossData, required this.crossCheck, required this.data});
}

class CrossCheckingProcess extends CrossCheckingEvent {
  final MyDatabase db;
  final bool isEnabled;
  final Map<String, List> data;
  final AttributeMapping attributeMap;
  final Map<String, List>? crossCheckingData;
  final CrossCheckMapping? crossCheckMap;
  final int eventId;
  CrossCheckingProcess({
    required this.eventId,
    required this.db,
    required this.data,
    required this.isEnabled,
    required this.attributeMap,
    this.crossCheckingData,
    this.crossCheckMap,
  });
}

class DbLoaded extends CrossCheckingEvent {
  final int participants;
  final int absentees;
  DbLoaded({required this.participants, required this.absentees});
}
