import 'package:assingment/components/loading_page.dart';
import 'package:assingment/components/page_routeBuilder.dart';
import 'package:assingment/screen/depots_page.dart';
import 'package:assingment/screen/mumbai_depots.dart';
import 'package:assingment/widget/custom_container.dart';
import 'package:assingment/widget/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widget/custom_appbar.dart';

class CitiesPage extends StatefulWidget {
  const CitiesPage({super.key});

  @override
  State<CitiesPage> createState() => _CitiesPageState();
}

class _CitiesPageState extends State<CitiesPage> {
  List<String> citiesname = [
    'Mumbai',
    'Delhi',
    'Bengaluru',
    'Ahmedabad',
    'Kolkata',
    'Jammu & Shrinagar',
    'Lucknow',
    'Patna',
  ];
  List imglist = [
    'assets/depots/Mumbai.jpg',
    'assets/depots/Delhi.jpg',
    'assets/depots/Bengluru.jpg',
    'assets/depots/Ahmedabad.jpg',
    'assets/depots/Kolkata.jpg',
    'assets/depots/Jammu.jpg',
    'assets/depots/Lucknow.jpg',
    'assets/depots/patna.jpg',
  ];
  List<Widget> menuWidget = [
    const MumbaiDepotsPage(),
    const MumbaiDepotsPage(),
    const MumbaiDepotsPage(),
    const MumbaiDepotsPage(),
    const MumbaiDepotsPage(),
    // const DepotsPage(),
    const MumbaiDepotsPage(),
    const MumbaiDepotsPage(),
    const MumbaiDepotsPage(),
    const MumbaiDepotsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: CustomAppBar(
              isCitiesPage: true,
              text: 'Cities',
              haveSynced: false,
            )),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('CityName')
              .orderBy('CityName')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                itemCount: snapshot.data!.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4, childAspectRatio: 1.3),
                itemBuilder: (context, index) {
                  return cards(
                      context,
                      snapshot.data!.docs[index]['CityName'],
                      snapshot.data!.docs[index]['ImageUrl'],
                      DepotsPage(
                          cityName: snapshot.data!.docs[index]['CityName']),
                      index);
                },
              );
            } else {
              return LoadingPage();
            }
          },
        )

        // GridView.count(
        //   crossAxisCount: 2,
        //   // childAspectRatio: 0.89,
        //   // crossAxisSpacing: 7,
        //   // mainAxisSpacing: 7,
        //   children: List.generate(citiesname.length, (index) {
        //     return cards(citiesname[index], index);
        //   }),
        // ),
        );
  }

  // Widget cards(String img, String title, int index) {
  //   return Padding(
  //     padding: const EdgeInsets.all(10.0),
  //     child: Column(
  //       children: [
  //         Container(
  //           height: 150,
  //           width: 150,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(20),
  //             color: blue,
  //             image:
  //                 DecorationImage(image: NetworkImage(img), fit: BoxFit.cover),
  //             boxShadow: const [
  //               BoxShadow(
  //                 color: Colors.black,
  //                 blurRadius: 2.0,
  //                 spreadRadius: 0.0,
  //                 offset: Offset(2.0, 2.0), // shadow direction: bottom right
  //               )
  //             ],
  //           ),
  //         ),
  //         const SizedBox(
  //           height: 10,
  //         ),
  //         ElevatedButton(
  //             style: ElevatedButton.styleFrom(
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(10.0)),
  //               //   minimumSize: MediaQuery.of(context).size,
  //               backgroundColor: blue,
  //             ),
  //             onPressed: () {
  //               Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => DepotsPage(cityName: title),
  //                   ));
  //             },
  //             child: Text(
  //               title,
  //               style: appFontSize,
  //             )),
  //       ],
  //     ),
  //   );
  // }

  void onToScreen(int index) {
    Navigator.push(context, CustomPageRoute(page: menuWidget[index])
        // MaterialPageRoute(
        //   builder: (context) => menuWidget[index],
        // )
        );
  }
}
