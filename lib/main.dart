import 'dart:ffi';

import 'package:tahlil_analiz/models/Analysis.dart';
import 'package:tahlil_analiz/screens/AnalysisPage.dart';
import 'package:tahlil_analiz/screens/detailPage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:tahlil_analiz/screens/login_screen.dart';
import 'package:tahlil_analiz/screens/main_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;
  runApp(MaterialApp(
    home: LoginScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
