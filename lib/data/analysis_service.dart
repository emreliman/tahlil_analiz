import 'dart:convert';
import 'package:flutter/services.dart';
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


}

