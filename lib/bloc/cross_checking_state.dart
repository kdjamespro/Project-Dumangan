part of 'cross_checking_bloc.dart';

@immutable
abstract class CrossCheckingState {
  const CrossCheckingState();
}

class CrossCheckingEnabled extends CrossCheckingState {
  const CrossCheckingEnabled() : super();
}

class CrossCheckingDisabled extends CrossCheckingState {
  const CrossCheckingDisabled() : super();
}

class CrossCheckingStart extends CrossCheckingState {
  const CrossCheckingStart() : super();
}

class CrossCheckingMapping extends CrossCheckingState {}

class CrossCheckingFinished extends CrossCheckingState {
  const CrossCheckingFinished() : super();
}
