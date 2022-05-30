import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../models/Analysis.dart';

class AnalysisService{
  static List<Analysis> all_analysis = [];

  static AnalysisService _singleton = new AnalysisService._internal();

  factory AnalysisService(){
    return _singleton;
  }
  AnalysisService._internal();

  static Future getAnalysis () async{
    final String response =
  await rootBundle.loadString('assets/54478355056.json');
  final _data =json.decode(response);
    return _data;
    // final _response = await http.get(Uri.parse("http://10.0.2.2:3000/tahliller"));
    // if (_response.statusCode == 200){
    //   return json.decode(_response.body);
    // }
    // else {
    //   throw Exception("Yükleme başarısız.");
    // }

  }

  static Future<List<Analysis>> extractText(String file_path) async {
    // final result = await FilePicker.platform.pickFiles();
    int page_size = 0;
    PdfDocument document =
    PdfDocument(inputBytes: await _readDocumentData(file_path));
    page_size = document.pages.count;
    PdfTextExtractor extractor = PdfTextExtractor(document);
    String text = "";
    List<Analysis> analysis_list = [];
    String tarih = "";
    String ust_sinif = "";
    for (int i = 0; i < page_size - 1; i++) {
      // if(i ==0){

      text = extractor.extractText(startPageIndex: i);
      List<String> analysis = text.split("\n");
      analysis.removeRange(0, 6);
      analysis.removeAt(analysis.length - 1);
      for (int j = 0; j < analysis.length - 1; j++) {
        List<String> first2 = [analysis[j], analysis[j + 1], analysis[j + 2]];

        if (first2[2].contains("-")) {
          analysis_list
              .add(Analysis(analysis[j + 1], "", "", "", analysis[j], ""));
          tarih = analysis[j];
          ust_sinif = analysis[j + 1];
          if (analysis[j + 1].contains("İdrar analizi (Strip ile)")) {
            break;
          }
          j = j + 1;
          continue;
        }
        if (first2[0].contains("-")) {
          analysis_list.add(Analysis(analysis[j + 1], analysis[j + 2],
              analysis[j + 3], analysis[j + 4], tarih, ust_sinif));
          j = j + 4;
          continue;
        } else {
          analysis_list.add(Analysis(analysis[j + 1], analysis[j + 2],
              analysis[j + 3], analysis[j + 4], analysis[j], ""));
          j = j + 4;

          continue;
        }
      }

    }
    return analysis_list;
  }

  static Future<List<int>> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load(name);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }





}

