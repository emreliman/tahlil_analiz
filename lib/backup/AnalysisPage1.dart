import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/Analysis.dart';
import '../screens/detailPage.dart';


class AnalysisPage extends StatefulWidget {
  const AnalysisPage({Key? key}) : super(key: key);

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  List _items = [];
  List<Analysis> new_data = [];
  var _item_view = [];
  List selected_list = [];

  @override
  void initState() {
    readJson();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Analysis"),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10.00,
            ),
            Container(
              child: Text("Tüm Değerler",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30.00,
                    color: Color(0xCE4747FF),
                    wordSpacing: 4.0,
                  )),
            ),
            SizedBox(
              height: 10.00,
            ),
            Expanded(
              child: Container(
                child: GridView.count(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  crossAxisCount: 3,
                  primary: true,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  children: List.generate(_items.length, (index) {
                    return Card(
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            get_colour(_items[index]),
                            Colors.white,
                          ],
                        )),
                        child: ListTile(
                            title: Center(
                                child: Text(
                              _items[index]["Islem_Adi"],
                              style: TextStyle(
                                  fontSize: 20.00, fontFamily: "Roboto"),
                            )),
                            onTap: () {
                              search_item(_items[index]);

                              setState(() {
                                new_data = get_analysis();
                              });

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          new DetailPage(new_data)));
                            }),
                      ),
                    );
                  }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> readJson() async {

    final String response =
        await rootBundle.loadString('assets/54478355056.json');
    List data = json.decode(response);
    setState(() {
      this._items = data; 
    });

    for (var item in data) {
      bool init = false;
      for (var p in _item_view) {

        if (item["Islem_Adi"] == p["Islem_Adi"]) {
          init = false;
        } else {
          init = true;
        }
      }
      if (init != true) {
        setState(() {
          _item_view.add(item);
        });
      }
    }
  }

  void search_item(var selected_item) {
    selected_list = _items
        .where((e) =>
            e["Islem_Adi"].toString() == selected_item["Islem_Adi"].toString())
        .toList();
  }

  List<Analysis> get_analysis() {
    List<Analysis> new_data = [];
    for (var i = 0; i < selected_list.length; i++) {
      new_data.add(Analysis(
          selected_list[i]["Islem_Adi"],
          selected_list[i]["Sonuc"],
          selected_list[i]["Sonuc_Birimi"],
          selected_list[i]["Referans_Degeri"],
          selected_list[i]["Tarih"],
          selected_list[i]["Ust_Sinif"]));
    }
    return new_data;
  }

  get_colour(var item) {
    double upper;
    double lower;

    List<String>? splitted;
    splitted = item["Referans_Degeri"].toString().split("-").length == 2
        ? item["Referans_Degeri"].toString().split("-")
        : null;
    if (splitted == null) {
      return Colors.lightGreen;
    } else {
      upper = double.parse(splitted[1]);
      lower = double.parse(splitted[0]);
      double sonuc = double.parse(item["Sonuc"].toString());
      if (sonuc > upper || sonuc < lower) {
        return Colors.red;
      } else {
        return Colors.lightGreen;
      }
    }
  }
}

// Future<void> readJson() async {
//   bool init = false;
//   final String response =
//   await rootBundle.loadString('assets/54478355056.json');
//   final data =json.decode(response);
//   for (var i = 0; i < data.length; i++) {
//
//     _items.add(new Analysis(
//         data[i]["Islem_Adi"],
//         data[i]["Sonuc"],
//         data[i]["Sonuc_Birimi"],
//         data[i]["Referans_Degeri"],
//         data[i]["Tarih"],
//         data[i]["Ust_Sinif"]));
//
//   }
//   for (var item in _items) {
//     for (var p in _item_view) {
//       if (item.toString() == p.toString()) {
//         init = true;
//       } else {
//         init = false;
//       }
//     }
//     if (init == false) {
//       setState(() {
//         _item_view.add(item);
//       });
//
//
//     }
//   }
// }

// Expanded
// (
// child: Padding
// (
// padding: const EdgeInsets.all(16.0
// )
// ,
// child: ListView.builder(scrollDirection: Axis.vertical,shrinkWrap: true
// ,
// itemCount: _item_view.length,itemBuilder: (
//
// BuildContext context, int
// index) {
// return Card(
// child: ListTile(
// title: Text(_item_view[index]["Islem_Adi"]),
// tileColor: get_colour(_item_view[index]),
// onTap: () {
// search_item(_item_view[index]);
//
// setState(() {
// new_data = get_analysis();
// });
//
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) =>
// new DetailPage(new_data)));
// },
// ),
// );
// })
// ,
// )
// )
