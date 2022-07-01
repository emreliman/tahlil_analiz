import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:tahlil_analiz/data/analysis_service.dart';

import '../models/Analysis.dart';

class AnalysisBloc {
  final analysisStreamController = StreamController<List<Analysis>>.broadcast();
  List<Analysis> permanentData = [];

  Stream<List<Analysis>> get getStream => analysisStreamController.stream;

  void getAnalysis() async {
    // final response = await AnalysisService.getAnalysis();
    //
    // Iterable list = response["tahliller"];
    // List<Analysis> analysis =
    //     list.map((value) => Analysis.fromJson(value)).toList();

    Uint8List? text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/my_file.txt');
      text = await file.readAsBytes();
    } catch (e) {
      //catch
    }
    permanentData = await AnalysisService.getAll(text!);

    analysisStreamController.sink.add(permanentData);
  }

  void getAnalysisFromPdf() async {
    List<Analysis> analysis =
        await AnalysisService.extractText("assets/tahlil2.pdf");
    permanentData = analysis;
    analysisStreamController.sink.add(analysis);
  }

  void getAnalysisFromPdfP() async {
    analysisStreamController.sink.add(permanentData);
  }

  void statusPageGetRiskyAnalysis() async {
    Uint8List? text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/my_file.txt');
      text = await file.readAsBytes();
    } catch (e) {
      //catch
    }
    permanentData = await AnalysisService.getAll(text!);
    List<Analysis> dangerous = await waitDangerous(permanentData);
    analysisStreamController.sink.add(dangerous);
  }

  void getRiskyAnalysisFromPdf() async {
    // List<Analysis> analysis = await AnalysisService.extractText("assets/tahlil2.pdf");
    List<Analysis> dangerous = await waitDangerous(permanentData);

    analysisStreamController.sink.add(dangerous);
  }

  void getRiskyAnalysis() async {
    // final response = await AnalysisService.getAnalysis();
    // Iterable list = response["tahliller"];
    // List<Analysis> analysis =
    // list.map((value) => Analysis.fromJson(value)).toList();
    //
    // List<Analysis> dangerous = await wait_dangerous(analysis);
    List<Analysis> dangerous = await waitDangerous(permanentData);
    analysisStreamController.sink.add(dangerous);
  }

  void dispose() {
    analysisStreamController.close();
  }

  Future<List<Analysis>> waitDangerous(List<Analysis> analysis) async {
    List<Analysis> dangerous = [];
    List<Analysis> dangerAnalysis = [];
    for (int i = 0; i < analysis.length; i++) {
      if (i == 0) {
        dangerAnalysis.add(analysis[i]);
      } else if (dangerAnalysis
          .any((element) => element.islem_adi == analysis[i].islem_adi)) {
        continue;
      } else {
        dangerAnalysis.add(analysis[i]);
      }
    }

    for (var item in dangerAnalysis) {
      double upper;
      double lower;

      List<String> splitted = [];

      try {
        splitted = item.referans_degeri.split("-").length == 2
            ? item.referans_degeri.split("-")
            : ["0", "0"];

        upper = double.parse(splitted[1]);
        lower = double.parse(splitted[0]);
        double sonuc = double.parse(item.sonuc.toString());
        if (sonuc > upper || sonuc < lower) {
          dangerous.add(item);
        }
      } catch (e) {
        // pass
      }
    }

    return dangerous;
  }
}

final analysisBloc = AnalysisBloc();
