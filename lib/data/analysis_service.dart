import 'dart:convert';

import 'package:http/http.dart' as http;
import '../models/Analysis.dart';

class AnalysisService{
  static List<Analysis> all_analysis = [];

  static AnalysisService _singleton = new AnalysisService._internal();

  factory AnalysisService(){
    return _singleton;
  }
  AnalysisService._internal();

  static Future getAnalysis () async{
    final _response = await http.get(Uri.parse("http://10.0.2.2:3000/tahliller"));
    if (_response.statusCode == 200){
      return json.decode(_response.body);
    }
    else {
      throw Exception("Yükleme başarısız.");
    }

  }


}

