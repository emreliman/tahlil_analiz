
import 'package:flutter/material.dart';

import '../blocs/analysis_bloc.dart';
import '../models/Analysis.dart';

class StatusPage extends StatefulWidget {
   StatusPage({Key? key}) : super(key: key);

  @override
  State<StatusPage> createState() => _StatusPageState();
}

class _StatusPageState extends State<StatusPage> {
  final _mystream = AnalysisBloc();

  @override
  void initState() {
    _mystream.statusPageGetRiskyAnalysis();
    super.initState();
  }
  @override
  void dispose() {
    _mystream.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Durumum"),
      ),
      body: Container(
        child: Column(
          children:<Widget> [
           const SizedBox(height: 30),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(150),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 10,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child:const  FittedBox(
                fit: BoxFit.fitHeight,
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage: AssetImage("assets/heart.png"),
                ),
              ),
            )


            ,
        StreamBuilder<List<Analysis>>(
          stream: _mystream.getStream,
          builder: (context, snapshot){
    if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
    return const Text("Lütfen Bekleyiniz..");
    } else if (snapshot.data == null) {
    return const Text("Data yok..");
    } else {
      return Expanded(child: ListView.builder(
      padding: const EdgeInsets.all(8),
    itemCount: snapshot.data!.length,
    itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
               const Divider(color: Colors.black),
                Container(
                height: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('${snapshot.data![index].islem_adi}:'),
                    Text("${snapshot.data![index].referans_degeri}:"),
                    Text("${snapshot.data![index].sonuc}",style: TextStyle(color: Colors.red))

                  ],
                ),
                ),
                Divider(color: Colors.black)
              ],
            );
            }
      ));
    }

          },

        )
          ],
        ),
      ),
    );
  }
}
