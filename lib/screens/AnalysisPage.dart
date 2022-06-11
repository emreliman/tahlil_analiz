import 'package:flutter/material.dart';
import '../blocs/analysis_bloc.dart';
import '../models/Analysis.dart';
import 'detailPage.dart';

enum Options { Hepsi, Riskli }

class AnalysisPage extends StatefulWidget {
  bool from_web;
   AnalysisPage(bool? from_web):
  from_web=from_web ?? true;

  @override
  State<AnalysisPage> createState() => _AnalysisPageState(from_web);
}

class _AnalysisPageState extends State<AnalysisPage> {
  List<Analysis> selected_list = [];
  bool from_web = true;

  final _mystream = AnalysisBloc();
  var _popupMenuItemIndex = 0;
  _AnalysisPageState(bool? from_web):
  from_web =from_web ?? true;

  @override
  void initState() {
    if(from_web){
      _mystream.getAnalysis();
      WidgetsBinding.instance
          .addPostFrameCallback((_) {
        const snackBar = SnackBar(
          backgroundColor: Colors.lightGreen,

          content: Text("Veriler web'den çekildi!"),
        );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });

    }
    else{
      WidgetsBinding.instance
          .addPostFrameCallback((_) {
        const snackBar = SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text("Veriler pdf'den çekildi!"),
        );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
      _mystream.getAnalysisFromPdf();

    }
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
        title: Text("Analysis"),
        backgroundColor: Colors.transparent,
        actions: [
          PopupMenuButton(
            onSelected: (val) {
              _onMenuItemSelected(val as int);
            },
            itemBuilder: (ctx) => [
              _buildPopupMenuItem(
                  'Hepsi', Icons.all_inbox, Options.Hepsi.index),
              _buildPopupMenuItem(
                  'Riskli', Icons.heart_broken, Options.Riskli.index),
            ],
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10.00,
            ),
            if(_popupMenuItemIndex ==0)...[
              Container(
                child: const Text("Tüm Değerler",
                    textAlign: TextAlign.center,
                    style:  TextStyle(
                      fontSize: 30.00,
                      color: Color(0xCE4747FF),
                      wordSpacing: 4.0,
                    )),
              )
            ]
            else ...[
              Container(
                child: const Text("Riskli Değerler",
                    textAlign: TextAlign.center,
                    style:  TextStyle(
                      fontSize: 30.00,
                      color: Color(0xCE4747FF),
                      wordSpacing: 4.0,
                    )),
              )
            ]
            ,
            const SizedBox(
              height: 10.00,
            ),
            StreamBuilder<List<Analysis>>(
                stream: _mystream.getStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Text("Lütfen Bekleyiniz..");
                  } else if (snapshot.data == null) {
                    return const Text("Data yok..");
                  } else {
                    return Expanded(
                      child: GridView.count(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        crossAxisCount: 3,
                        primary: true,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 18,
                        children:
                            List.generate(snapshot.data!.length, (index) {
                          return Card(
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                begin: Alignment.topRight,
                                end: Alignment.bottomLeft,
                                colors: [
                                  get_colour(snapshot.data![index]),
                                  Colors.white,
                                ],
                              )),
                              child: ListTile(
                                  title: Center(
                                      child: Text(
                                    snapshot.data![index].islem_adi,
                                    style:const  TextStyle(
                                        fontSize: 20.00,
                                        fontFamily: "Roboto"),
                                  )),
                                  onTap: () {
                                    search_item(snapshot.data![index],
                                        snapshot.data!);
                                    //
                                    // setState(() {
                                    //   new_data = get_analysis();
                                    // });

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                 DetailPage(
                                                    selected_list)));
                                  }),
                            ),
                          );
                        }),
                      ),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }

  // Future<void> readJson() async {
  //   final List data = [];
  //
  //   for (var item in data) {
  //     bool init = false;
  //     for (var p in _item_view) {
  //       if (item["Islem_Adi"] == p["Islem_Adi"]) {
  //         init = false;
  //       } else {
  //         init = true;
  //       }
  //     }
  //     if (init != true) {
  //       setState(() {
  //         _item_view.add(item);
  //       });
  //     }
  //   }
  // }

  void search_item(Analysis selectedItem, List<Analysis> snapshot) {
    setState(() {
      selected_list =
          snapshot.where((e) => e.islem_adi == selectedItem.islem_adi).toList();
    });
  }

  get_colour(Analysis item) {
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
        double sonuc = double.parse(item.sonuc.toString());
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

  void _onMenuItemSelected(int val) {
    setState(() {
      _popupMenuItemIndex = val;
    });
    if (_popupMenuItemIndex == 0){
      if(from_web){
        _mystream.getAnalysis();
      }
      else{
        _mystream.getAnalysisFromPdfP();
      }

    }
    else{
      if(from_web){
        _mystream.get_risky_Analysis();
      }
      else{
        _mystream.getRiskyAnalysisFromPdf();
      }

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
