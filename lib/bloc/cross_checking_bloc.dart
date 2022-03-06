import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '/services/file_parser.dart';

part 'cross_checking_event.dart';
part 'cross_checking_state.dart';

class CrossCheckingBloc extends Bloc<CrossCheckingEvent, CrossCheckingState> {
  FileParser parser = FileParser();
  CrossCheckingBloc() : super(const CrossCheckingDisabled()) {
    on<CrossChekingEventInitialize>((event, emit) {
      emit(const CrossCheckingDisabled());
    });
    on<CrossChekingEventDisable>((event, emit) {
      emit(const CrossCheckingDisabled());
    });
    on<CrossChekingEventEnable>((event, emit) {
      emit(const CrossCheckingEnabled());
    });
    on<CrossChekingEventStart>((event, emit) async {
      await _parseFile(event, emit);
    });
  }

  Future<void> _parseFile(CrossChekingEventStart start, Emitter emit) async {
    emit(const CrossCheckingStart());
    for (var file in start.files) {
      await parser.parseFile(file);
    }
    await Future.delayed(const Duration(seconds: 3));
    emit(const CrossCheckingFinished());
  }
}
