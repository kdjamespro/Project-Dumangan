import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:project_dumangan/database/database.dart';
import 'package:project_dumangan/model/attribute_mapping.dart';
import 'package:project_dumangan/model/crosscheck_mapping.dart';
import 'package:project_dumangan/services/crosschecker.dart';
import 'package:project_dumangan/services/map_participants.dart';

import '/services/file_parser.dart';

part 'cross_checking_event.dart';
part 'cross_checking_state.dart';

class CrossCheckingBloc extends Bloc<CrossCheckingEvent, CrossCheckingState> {
  MyDatabase db;
  FileParser parser = FileParser();
  CrossCheckingBloc({required this.db}) : super(const CrossCheckingDisabled()) {
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
    emit((CrossCheckingMapping(
        data: event.data,
        crossCheckingData: crossCheckingData,
        isEnabled: event.crossCheck)));
  }

  Future<void> _crossCheck(CrossCheckingProcess event, Emitter emit) async {
    emit(const CrossCheckingLoading());
    List key1 = event.attributeMap.getKeys();
    List val1 = event.attributeMap.getValues();
    Map regData = {};
    for (int i = 0; i < min(key1.length, val1.length); i++) {
      regData[val1[i]] = event.data[key1[i]];
    }

    if (event.isEnabled) {
      Map crossData = {};

      List key2 = event.crossCheckMap!.getKeys();
      List val2 = event.crossCheckMap!.getValues();

      for (int i = 0; i < min(key2.length, val2.length); i++) {
        crossData[val2[i]] = event.crossCheckingData![key2[i]];
      }
      CrossChecker check = CrossChecker(regData: regData, crossData: crossData);
      check.crossCheck();
      await db.addBatchParticipants(check.participants);
      await db.addBatchParticipants(check.absentees);
    } else {
      MapParticipants query = MapParticipants(regData: regData);
      await db.addBatchParticipants(query.participants);
    }

    emit(const CrossCheckingFinished());
  }
}
