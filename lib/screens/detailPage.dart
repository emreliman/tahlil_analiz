import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'details.dart';
import '../models/Analysis.dart';

enum Options { liste, grafik }

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
  var _popupMenuItemIndex = 0;

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
          title: Text(selected_list[0].islem_adi),
          actions: [
            PopupMenuButton(
              onSelected: (val) {
                _onMenuItemSelected(val as int);
              },
              itemBuilder: (ctx) => [
                _buildPopupMenuItem(
                    'Liste', Icons.library_books, Options.liste.index),
                _buildPopupMenuItem(
                    'Grafik', Icons.pie_chart, Options.grafik.index),
              ],
            )
          ],
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: 60.00,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(get_text(selected_list[0].islem_adi),
                            style: TextStyle(
                                fontSize: 16.00, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(
                height: 20,
                thickness: 1,
                endIndent: 0,
                color: Colors.grey,
              ),
              if (_popupMenuItemIndex == 0) ...[
                const SizedBox(
                  height: 10.00,
                ),
                Row(
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
                Expanded(
                  child: Card(
                    child: ListView.builder(
                        itemCount: selected_list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(selected_list[index].islem_adi),
                            subtitle: find_subtitle(selected_list[index]),
                            trailing: Text(selected_list[index].tarih),
                          );
                        }),
                  ),
                ),
              ] else if (_popupMenuItemIndex == 1) ...[
                Container(
                  child: SfCartesianChart(
                    primaryXAxis: CategoryAxis(),
                    primaryYAxis: NumericAxis(),
                    series: <ChartSeries>[
                      ColumnSeries<Analysis, String>(
                          dataSource: selected_list,
                          xValueMapper: (Analysis item, _) => item.tarih,
                          yValueMapper: (Analysis item, _) {
                            try{
                              return double.tryParse(item.sonuc);
                            }
                            catch (e){
                              return 0;
                            }
                          },
                          animationDuration: 3000,
                          pointColorMapper: (Analysis item, _) {
                          try {
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
                          }
                          catch(e){
                            return Colors.green;
                          }
                          })
                    ],
                  ),
                )
              ],
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
          : ["0","0"];
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
    String upper_islem = islem_adi.trim().toUpperCase();
    print(upper_islem);
    if (analyis_details.containsKey(upper_islem)) {
      return analyis_details[upper_islem]!;
    } else {
      return "Bu değer hakkında veri henüz bulunamadı...";
    }
  }

  PopupMenuItem _buildPopupMenuItem(
      String s, IconData pie_chart, int position) {
    return PopupMenuItem(
        value: position,
        child: Row(
          children: [Icon(pie_chart, color: Colors.black), Text(" " + s)],
        ));
  }

  void _onMenuItemSelected(int val) {
    setState(() {
      _popupMenuItemIndex = val;
    });

  }

  find_subtitle(Analysis selected_list) {
    if(selected_list.sonuc == null){
      return Text("Veri Yok");
    }
    else{
      return Text(selected_list.sonuc);
    }

  }


}
