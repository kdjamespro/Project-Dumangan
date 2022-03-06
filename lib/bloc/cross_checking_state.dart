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

class CrossCheckingLoading extends CrossCheckingState {
  const CrossCheckingLoading() : super();
}

class CrossCheckingAttribute extends CrossCheckingState {
  final Map<String, List> data;
  final bool isEnabled;
  final File? crossCheckFile;
  const CrossCheckingAttribute(
      {required this.data, required this.isEnabled, this.crossCheckFile})
      : super();
}

class CrossCheckingMapping extends CrossCheckingState {
  final bool isEnabled;
  final Map<String, List> data;
  final Map<String, List> crossCheckingData;
  const CrossCheckingMapping(
      {required this.crossCheckingData,
      required this.data,
      required this.isEnabled})
      : super();
}

class CrossCheckingFinished extends CrossCheckingState {
  const CrossCheckingFinished() : super();
}
