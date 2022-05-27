import 'package:flutter/material.dart';
import 'package:tahlil_analiz/screens/main_screen.dart';

import '../data/analysis_service.dart';

class LoginScreen extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(10),

            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Tahlil Analiz',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'E-nabız ile giriş',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    autofocus: true,
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'T.C. Kimlik Numarası ',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    autofocus: true,
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-nabız Şifresi',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    //forgot password screen
                  },
                  child: const Text(
                    'Şifreyi Unuttum',
                  ),
                ),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text('Giriş'),
                      onPressed: () {
                        control_names(context);
                      },
                    )),
              ],
            ),
          ),
    );
  }

  void control_names(BuildContext context) {
    doit();

    print(nameController.text);
    print(passwordController.text);
    if (nameController.text == 'ahmet' && passwordController.text == '12') {
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) =>const MainScreen()));
      FocusManager.instance.primaryFocus?.unfocus();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void doit() async {
    List result = await AnalysisService.getAnalysis();
  }
}
