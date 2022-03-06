import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:project_dumangan/model/attribute_mapping.dart';
import 'package:project_dumangan/model/crosscheck_mapping.dart';

import '/services/file_parser.dart';

part 'cross_checking_event.dart';
part 'cross_checking_state.dart';

class CrossCheckingBloc extends Bloc<CrossCheckingEvent, CrossCheckingState> {
  FileParser parser = FileParser();
  CrossCheckingBloc() : super(const CrossCheckingDisabled()) {
    on<CrossChekingInitialize>((event, emit) {
      emit(const CrossCheckingDisabled());
    });
    on<CrossChekingDisable>((event, emit) {
      emit(const CrossCheckingDisabled());
    });
    on<CrossChekingEnable>((event, emit) {
      emit(const CrossCheckingEnabled());
    });
    on<CrossChekingStart>((event, emit) async {
      await _parseFile(event, emit);
    });
    on<CrossCheckingProceed>((event, emit) async {
      await _parseCrossCheckingFile(event, emit);
    });
    on<CrossCheckingProcess>((event, emit) async {
      await _crossCheck(event, emit);
    });
  }

  Future<void> _parseFile(CrossChekingStart start, Emitter emit) async {
    emit(const CrossCheckingLoading());
    print(start.files.length);
    if (start.crossCheck) {
      emit((CrossCheckingAttribute(
          data: await parser.parseFile(start.files[0]),
          isEnabled: start.crossCheck,
          crossCheckFile: start.files[1])));
    } else {
      emit((CrossCheckingAttribute(
          data: await parser.parseFile(start.files[0]),
          isEnabled: start.crossCheck)));
    }
  }

  Future<void> _parseCrossCheckingFile(
      CrossCheckingProceed event, Emitter emit) async {
    emit(const CrossCheckingLoading());
    Map<String, List> crossCheckingData = await parser.parseFile(event.file);
    print(crossCheckingData);
    emit((CrossCheckingMapping(
        data: event.data,
        crossCheckingData: crossCheckingData,
        isEnabled: event.crossCheck)));
  }

  Future<void> _crossCheck(CrossCheckingProcess event, Emitter emit) async {
    emit(const CrossCheckingLoading());
    print(event.data.keys);
    print(event.attributeMap.getKeys());
    if (event.isEnabled) {
      print(event.crossCheckingData!.keys);
    }

    emit(const CrossCheckingFinished());
  }
}
