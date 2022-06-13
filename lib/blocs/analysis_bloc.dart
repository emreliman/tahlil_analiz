import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:tahlil_analiz/data/analysis_service.dart';

import '../models/Analysis.dart';

class AnalysisBloc {
  final analysisStreamController = StreamController<List<Analysis>>.broadcast();
  List<Analysis> permanent_data = [];
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
        print("Couldn't read file");
      }
      permanent_data = await AnalysisService.get_all(text!);


    analysisStreamController.sink.add(permanent_data);
  }
  void getAnalysisFromPdf() async {
   List<Analysis> analysis = await AnalysisService.extractText("assets/tahlil2.pdf");
   permanent_data = analysis;
   analysisStreamController.sink.add(analysis);
  }
  void getAnalysisFromPdfP() async {

    analysisStreamController.sink.add(permanent_data);
  }
  void status_page_get_risky_analysis() async{
    Uint8List? text;
    try {
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File('${directory.path}/my_file.txt');
      text = await file.readAsBytes();
    } catch (e) {
      print("Couldn't read file");
    }
    permanent_data = await AnalysisService.get_all(text!);
    List<Analysis> dangerous = await wait_dangerous(permanent_data);
    analysisStreamController.sink.add(dangerous);
  }

  void getRiskyAnalysisFromPdf()async{
    // List<Analysis> analysis = await AnalysisService.extractText("assets/tahlil2.pdf");
    List<Analysis> dangerous = await wait_dangerous(permanent_data);

    analysisStreamController.sink.add(dangerous);
  }
  void get_risky_Analysis() async {
    // final response = await AnalysisService.getAnalysis();
    // Iterable list = response["tahliller"];
    // List<Analysis> analysis =
    // list.map((value) => Analysis.fromJson(value)).toList();
    //
    // List<Analysis> dangerous = await wait_dangerous(analysis);
    List<Analysis> dangerous = await wait_dangerous(permanent_data);
    analysisStreamController.sink.add(dangerous);
  }

  void dispose(){
  analysisStreamController.close();
  }

  Future<List<Analysis>> wait_dangerous(List<Analysis> analysis) async {
    List<Analysis> dangerous = [];
    List<Analysis> danger_analysis = [];
    for(int i=0; i<analysis.length;i++){
      if (i == 0){
        danger_analysis.add(analysis[i]);
      }
      else if (danger_analysis.any((element) => element.islem_adi == analysis[i].islem_adi)){
        continue;
      }
      else{
        danger_analysis.add(analysis[i]);
      }
    }


    danger_analysis.forEach((item){
      double upper;
      double lower;

      List<String> splitted = [];


      try {
        splitted = item.referans_degeri.split("-").length == 2
            ? item.referans_degeri.split("-")
            : ["0","0"];

        upper = double.parse(splitted[1]);
        lower = double.parse(splitted[0]);
        double sonuc = double.parse(item.sonuc.toString());
        if (sonuc > upper || sonuc < lower) {
          
          dangerous.add(item);
        }

      }
      catch (e) {
        // pass
      }



    });
    return dangerous;

  }
}

final analysisBloc = AnalysisBloc();
