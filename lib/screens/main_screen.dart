import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:tahlil_analiz/screens/statusPage.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/Analysis.dart';
import 'AnalysisPage.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _mainScreenState createState() => _mainScreenState();
}


class _mainScreenState extends State<MainScreen> {
  Analysis selected_analysis = Analysis("", "", "", "", "", "");
  @override
  void initState() {
    super.initState();
    Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent.withAlpha(150),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Tahlil Analiz",
          style: TextStyle(color: Colors.white70),
        ),
        centerTitle: true,
      ),
      body: builMainBody(context),
    );
  }

  Widget builMainBody(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Column(
        key: ObjectKey('FirstRow'),
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]),
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                child: Text("Durumum",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 25)),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 100),
                  maximumSize: Size(200, 100),
                  primary: Colors.lightGreen.withAlpha(155),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => StatusPage()));
                },
              ),
            ),
          ),
          SizedBox(height: 30.00),
          Center(
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]),
              margin: EdgeInsets.all(10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(200, 200),
                  maximumSize: Size(200, 200),
                  primary: Colors.lightBlue.withOpacity(0.5),
                ),
                // change the page ------------------------
                onPressed: () {

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  AnalysisPage(true)));
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    "Tahliller",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 30.00),
          Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ]),
            child: ElevatedButton(
              onPressed: () async {
                // final result = await FilePicker.platform.pickFiles();
                // if (result == null) return;

                // final file = result.files.first;
      //           FilePickerResult? result = await FilePicker.platform.pickFiles(
      //             type: FileType.custom,
      //             allowedExtensions: ['pdf'],
      //           );
      //           String file_path ="";
      // if (result != null) {
      // PlatformFile file = result.files.first;
      // final file_int =  file.bytes;
      // file_path = file.path!;
      // }
                Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>AnalysisPage(false)));



              },
              child: const Text('Pdf Yükle', style: TextStyle(fontSize: 25.00)),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(200, 200),
                maximumSize: Size(200, 200),
                primary: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _extractText(String file_path) async {
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
    for (int i = 0; i < page_size - 2; i++) {
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
          print("ahmet");
          continue;
        }
        if (first2[0].contains("-")) {
          analysis_list.add(Analysis(analysis[j + 1], analysis[j + 2],
              analysis[j + 3], analysis[j + 4], tarih, ust_sinif));
          print("j");
          j = j + 4;
          continue;
        } else {
          analysis_list.add(Analysis(analysis[j + 1], analysis[j + 2],
              analysis[j + 3], analysis[j + 4], analysis[j], ""));
          print("kardas");
          j = j + 4;

          continue;
        }
      }

      // }

    }
//Create a new instance of the PdfTextExtractor.

//Extract all the text from the document.

    // for (int i = 0; i < abc.length; i++) {
    //   if (abc[i].toString() == "") {
    //     abc.removeAt(i);
    //   } else if (forbidden_strings.contains(abc[i])) {
    //     abc.removeAt(i);
    //   }
    // }
    print("before");
    // List<String> new_abc = [];

    // new_abc = abc.where((element) => element != "").toList();
    // new_abc = new_abc[5].split("-");
    // asdas = double.parse(new_abc[0]) +1;
    // print("${new_abc[0]}  ${asdas}");
    // for (int a = 0; a < new_abc.length; a++) {
    //   print("${new_abc[a]} ${a} ");
    // }

    // text = extractor.extractText(startPageIndex: 0);
    // List<String> analysis = text.split("\n");
    //     analysis.removeRange(0, 7);
    //     analysis.removeAt(analysis.length-1);
    // text = analysis.join("\n");
//Display the text.
    _showResult(text);
  }

  Future<List<int>> _readDocumentData(String name) async {
    final ByteData data = await rootBundle.load(name);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  void _showResult(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Tahlil Sonuçları'),
            content: Scrollbar(
              child: SingleChildScrollView(
                child: Text(text),
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
              ),
            ),
            actions: [
              ElevatedButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                  ))
            ],
          );
        });
  }

  void openFile(PlatformFile file) {
    OpenFile.open(file.path!);
  }
}
