import 'package:assingment/components/page_routeBuilder.dart';
import 'package:assingment/screen/mumbai_depots.dart';
import 'package:assingment/screen/overview_page.dart';
import 'package:assingment/widget/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../components/loading_page.dart';
import '../widget/custom_appbar.dart';
import '../widget/custom_container.dart';

class DepotsPage extends StatefulWidget {
  String cityName;
  DepotsPage({super.key, required this.cityName});

  @override
  State<DepotsPage> createState() => _DepotsPageState();
}

class _DepotsPageState extends State<DepotsPage> {
  List imglist = [
    'assets/bus.jpg',
    'assets/bus.jpg',
    'assets/bus.jpg',
    'assets/bus.jpg',
    'assets/bus.jpg',
    'assets/bus.jpg',
  ];

  List<String> citiesname = [
    'Jammu',
    'Shrinagar',
    // 'Shivaji Nagar',
    // 'Backbay',
    // 'Worli ',
    // 'Wadala',
    // 'Dahisar',
    // 'Deonar'
  ];

  @override
  void initState() {
    getDepots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: CustomAppBar(
              isDepoPage: true,
              cityname: widget.cityName,
              text: ' ${widget.cityName} / Depots ',
              haveSynced: false,
            )),
        body: getDepots()
        // GridView.count(
        //     crossAxisCount: 2,
        //     children: List.generate(citiesname.length, (index) {
        //       return cards(Image.asset(imglist[index]), citiesname[index], index);
        //     })),
        );
  }

  getDepots() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('DepoName')
            .doc(widget.cityName)
            .collection('AllDepots')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.hasData != null) {
              if (snapshot.data!.docs.isNotEmpty) {
                return GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, childAspectRatio: 1.3),
                  itemBuilder: (context, index) {
                    return cards(
                        context,
                        snapshot.data!.docs[index]['DepoName'],
                        snapshot.data!.docs[index]['DepoUrl'],
                        OverviewPage(
                          cityName: widget.cityName,
                          depoName: snapshot.data!.docs[index]['DepoName'],
                        ),
                        index);
                    // cards(
                    //   snapshot.data!.docs[index]['DepoUrl'],
                    //   snapshot.data!.docs[index]['DepoName'],
                    // );
                  },
                );
              } else {
                return NodataAvailable();
              }
            } else {
              return LoadingPage();
            }
          }
          return LoadingPage();
        });
  }

  // Widget cards(String img, String title) {
  //   return Padding(
  //     padding: const EdgeInsets.all(10.0),
  //     child: Stack(
  //       children: [
  //         Column(
  //           children: [
  //             Container(
  //               height: 150,
  //               width: 150,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(20),
  //                 color: blue,
  //                 boxShadow: const [
  //                   BoxShadow(
  //                     color: Colors.black,
  //                     blurRadius: 2.0,
  //                     spreadRadius: 0.0,
  //                     offset:
  //                         Offset(2.0, 2.0), // shadow direction: bottom right
  //                   )
  //                 ],
  //                 image: DecorationImage(
  //                     image: NetworkImage(
  //                       img,
  //                     ),
  //                     fit: BoxFit.fill),
  //               ),
  //             ),
  //             SizedBox(height: 10),
  //             ElevatedButton(
  //                 style: ElevatedButton.styleFrom(
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(10)),
  //                     backgroundColor: blue),
  //                 onPressed: () {
  //                   Navigator.push(
  //                       context,
  //                       MaterialPageRoute(
  //                         builder: (context) => OverviewPage(
  //                             cityName: widget.cityName, depoName: title),
  //                       ));
  //                 },
  //                 child: Text(
  //                   title,
  //                   style: appFontSize,
  //                 ))
  //             // Container(
  //             //   padding: const EdgeInsets.only(left: 60),
  //             //   alignment: Alignment.center,
  //             //   height: 20,
  //             //   //   width: 100,
  //             //   // color: blue,
  //             //   child: Text(
  //             //     title,
  //             //     style: TextStyle(
  //             //         color: white, fontWeight: FontWeight.bold, fontSize: 18),
  //             //   ),
  //             // )
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

// void onToScreen(int index) {
//   Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DepotsPage(),
//       ));
// }

  NodataAvailable() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: EdgeInsets.all(10),
        height: 1000,
        width: 1000,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: blue)),
        child: Column(children: [
          Image.asset(
            'assets/Tata-Power.jpeg',
          ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/sustainable.jpeg',
                height: 100,
                width: 100,
              ),
              SizedBox(width: 50),
              Image.asset(
                'assets/Green.jpeg',
                height: 100,
                width: 100,
              )
            ],
          ),
          const SizedBox(height: 50),
          Center(
            child: Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: blue)),
              child: const Text(
                '     No Depots available yet \n Please wait for admin process',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
          )
        ]),
      ),
    )
        // Text(
        //   "No Depot Available at This Time....",
        //   style: TextStyle(color: black),
        // ),
        );
  }
}
