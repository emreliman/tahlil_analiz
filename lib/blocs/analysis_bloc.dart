import 'dart:async';

import 'package:tahlil_analiz/data/analysis_service.dart';

import '../models/Analysis.dart';

class AnalysisBloc {
  final analysisStreamController = StreamController<List<Analysis>>.broadcast();

  Stream<List<Analysis>> get getStream => analysisStreamController.stream;

  void getAnalysis() async {
    final response = await AnalysisService.getAnalysis();

    Iterable list = response;
    List<Analysis> analysis =
        list.map((value) => Analysis.fromJson(value)).toList();

    analysisStreamController.sink.add(analysis);
  }
  void dispose(){
  analysisStreamController.close();
  }
}

final analysisBloc = AnalysisBloc();
