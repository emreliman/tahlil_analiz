import 'package:flutter/material.dart';
import "package:charts_flutter/flutter.dart" as charts;
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/Analysis.dart';

class DetailPage extends StatefulWidget {
  List<Analysis> selected_list;

  DetailPage(this.selected_list);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _DetailPage(this.selected_list);
  }
}

class _DetailPage extends State {
  List<Analysis> selected_list = [];
  List<Analysis> data = [];
  Map<String, List<String>> _details = {
    "PLT": [
      "Vücutta kanın pıhtılaşmasını sağlayan hücre pulcuklara PLT,"
          " platelet, trombosit adları verilmektedir. ",
      """Yüksek Olması Durumunda :
         – Kanın damar içinde pıhtı atması riski artmasıyla, hayati tehlikenin 
         ortaya çıkması
  – Yüksek kolesterol, şeker hastalığı ve tansiyon dengesizliği sorunlarının
   getirebileceği
   risklerin artması""",
      """Düşük Olması Durumunda: 
      – Basit bir kanamalı durumda bile fazla kan kaybedilmesi,
– PLT sayısının 10.000'in altına düştüğü durumlarda beyin kanaması, """
    ],
  };

  _DetailPage(List<Analysis> selected_list) {
    this.selected_list = selected_list;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Detay"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10.00,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "İşlem",
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: 20.00,
                      ),
                    ),
                    SizedBox(
                      width: 200.00,
                    ),
                    Text(
                      "Tarih",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 20.00),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Card(
                  child: ListView.builder(
                      itemCount: selected_list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(selected_list[index].islem_adi),
                          subtitle: Text(selected_list[index].sonuc),
                          trailing: Text(selected_list[index].tarih),
                        );
                      }),
                ),
              ),
              Expanded(
                child: Container(
                  height:60.00,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Text(get_text(selected_list[0].islem_adi), style: TextStyle(fontSize: 16.00, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
              Container(
                child: SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  primaryYAxis: NumericAxis(),
                  series: <ChartSeries>[
                    ColumnSeries<Analysis, String>(
                        dataSource: selected_list,
                        xValueMapper: (Analysis item, _) => item.tarih,
                        yValueMapper: (Analysis item, _) {
                          return double.tryParse(item.sonuc);
                        },
                        animationDuration: 3000,
                        pointColorMapper: (Analysis item, _) {
                          double upper;
                          double lower;
                          double sonuc = double.parse(item.sonuc);
                          List<String> splitted;
                          splitted = item.referans_degeri == null
                              ? ['0', '0']
                              : item.referans_degeri.split("-");
                          upper = double.parse(splitted[1]);
                          lower = double.parse(splitted[0]);
                          if (sonuc > upper || sonuc < lower) {
                            return Colors.red;
                          } else {
                            return Colors.green;
                          }
                        })
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  get_colour(Analysis item, _) {
    double upper;
    double lower;

    List<String> splitted = [];
    try {
      splitted = item.referans_degeri.split("-").length == 2
          ? item.referans_degeri.split("-")
          : [""];
      if (splitted == [""]) {
        return Colors.lightGreen;
      } else {
        upper = double.parse(splitted[1]);
        lower = double.parse(splitted[0]);
        double sonuc = double.parse(item.sonuc);
        if (sonuc > upper || sonuc < lower) {
          return Colors.red;
        } else {
          return Colors.lightGreen;
        }
      }
    } catch (e) {
      return Colors.lightGreen;
    }
  }

  String get_text(String islem_adi) {
    if(_details.containsKey(islem_adi)){
      return _details[islem_adi]![0]+_details[islem_adi]![1]+_details[islem_adi]![2];
    }
    else {
      return "";
    }

  }


}
