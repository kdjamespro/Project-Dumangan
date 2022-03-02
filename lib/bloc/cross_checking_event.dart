part of 'cross_checking_bloc.dart';

@immutable
abstract class CrossCheckingEvent {}

class CrossChekingEventInitialize extends CrossCheckingEvent {}

class CrossChekingEventEnable extends CrossCheckingEvent {}

class CrossChekingEventDisable extends CrossCheckingEvent {}

class CrossChekingEventStart extends CrossCheckingEvent {
  final List<File> files;
  CrossChekingEventStart({required this.files});
}
