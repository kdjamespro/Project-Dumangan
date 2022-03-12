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
  final File file;
  final bool crossCheck;
  final Map<String, List> data;
  CrossCheckingProceed(
      {required this.file, required this.crossCheck, required this.data});
}

class CrossCheckingProcess extends CrossCheckingEvent {
  final MyDatabase db;
  final bool isEnabled;
  final Map<String, List> data;
  final AttributeMapping attributeMap;
  final Map<String, List>? crossCheckingData;
  final CrossCheckMapping? crossCheckMap;
  CrossCheckingProcess({
    required this.db,
    required this.data,
    required this.isEnabled,
    required this.attributeMap,
    this.crossCheckingData,
    this.crossCheckMap,
  });
}

class DbLoaded extends CrossCheckingEvent {}