import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../models/Analysis.dart';

class AnalysisService{
  static List<Analysis> allAnalysis = [];

  static final AnalysisService _singleton =  AnalysisService._internal();

  factory AnalysisService(){
    return _singleton;
  }
  AnalysisService._internal();

  // static Future getAnalysis () async{
  //   final String response =
  // await rootBundle.loadString('assets/.json');
  // final _data =json.decode(response);
  //   return _data;
  //   // final _response = await http.get(Uri.parse("http://10.0.2.2:3000/tahliller"));
  //   // if (_response.statusCode == 200){
  //   //   return json.decode(_response.body);
  //   // }
  //   // else {
  //   //   throw Exception("Yükleme başarısız.");
  //   // }
  //
  // }

  static Future<List<Analysis>> extractText(String filePath) async {
    // final result = await FilePicker.platform.pickFiles();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    Uint8List? fileInt;

    if (result != null) {
      PlatformFile file = result.files.first;
      fileInt =  file.bytes;
      // print(file.name);
      // print(file.bytes);
      // print(file.size);
      // print(file.extension);
      // print(file.path);
      // Get the application document directory
//       Directory appDocDir = await getApplicationDocumentsDirectory();
// // Get the absolute path
//       String appDocPath = appDocDir.path;
// // Copy it to the new file
// //       final File fileForFirebase = File(pdf.path);
//       final File newFile = await file.copy('$appDocPath/your_file_name.${file.extension}');

    }


    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/my_file.txt');
    await file.writeAsBytes(fileInt!);

    return getAll(fileInt);


  }

  static Future<List<Analysis>> getAll(Uint8List fileInt) async {
    int pageSize = 0;
    PdfDocument document =
    PdfDocument(inputBytes:fileInt);
    //  File(file_path).re await _readDocumentData(file_path)
    pageSize = document.pages.count;
    PdfTextExtractor extractor = PdfTextExtractor(document);
    String text = "";
    List<Analysis> analysisList = [];
    String tarih = "";
    String ustSinif = "";
    for (int i = 0; i < pageSize ; i++) {
      // if(i ==0){

      text = extractor.extractText(startPageIndex: i);
      List<String> analysis = text.split("\n");
      analysis.removeRange(0, 6);
      analysis.removeAt(analysis.length - 1);
      for (int j = 0; j < analysis.length - 1; j++) {
        List<String> first2 = [analysis[j], analysis[j + 1], analysis[j + 2]];

        if (first2[2].contains("-")) {
          analysisList
              .add(Analysis(analysis[j + 1], "", "", "", analysis[j], ""));
          tarih = analysis[j];
          ustSinif = analysis[j + 1];
          if (analysis[j + 1].contains("İdrar analizi (Strip ile)")) {
            break;
          }
          j = j + 1;
          continue;
        }
        if (first2[0].contains("-")) {
          analysisList.add(Analysis(analysis[j + 1], analysis[j + 2],
              analysis[j + 3], analysis[j + 4], tarih, ustSinif));
          j = j + 4;
          continue;
        } else {
          analysisList.add(Analysis(analysis[j + 1], analysis[j + 2],
              analysis[j + 3], analysis[j + 4], analysis[j], ""));
          j = j + 4;

          continue;
        }
      }

    }
    // dispose
    document.dispose();
    return analysisList;
  }







}

