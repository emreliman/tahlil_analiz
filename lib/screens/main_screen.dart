import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:tahlil_analiz/screens/statusPage.dart';

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
    return Column(
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
              child: Text("Durumum",textAlign: TextAlign.center,
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AnalysisPage()));
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
            onPressed: () {
              // final result = await FilePicker.platform.pickFiles();
              // if (result == null) return;
              //
              // final file = result.files.first;

              _extractText();
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
    );
  }

  void _extractText() async {
    List<String> forbidden_strings = [
      "Tarih",
      "Tahlil",
      "Sonuç",
      "Sonuç Birimi",
      "Referans Değeri"
    ];
    // final result = await FilePicker.platform.pickFiles();
    PdfDocument document =
        PdfDocument(inputBytes: await _readDocumentData('assets/tahlil.pdf'));

//Create a new instance of the PdfTextExtractor.
    PdfTextExtractor extractor = PdfTextExtractor(document);

//Extract all the text from the document.
    String text = extractor.extractText();
    List<String> abc = text.split("\n");
    abc.removeRange(0, 7);
    for (int i = 0; i < abc.length; i++) {
      if (abc[i].toString() == "") {
        abc.removeAt(i);
      } else if (forbidden_strings.any((element) => element == abc[i])) {
        abc.removeAt(i);
      }
    }
    print("before");
    List<String> new_abc = [];
    new_abc = abc.where((element) => element != "").toList();
    print(new_abc[5]);
    for (int a = 0; a < new_abc.length; a++) {
      print("${new_abc[a]} ${a} ");
    }
    text = abc.join("\n");

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
