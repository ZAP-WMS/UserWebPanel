import 'package:assingment/screen/overview_page.dart';
import 'package:assingment/widget/style.dart';
import 'package:flutter/material.dart';

class MumbaiDepotsPage extends StatefulWidget {
  const MumbaiDepotsPage({super.key});

  @override
  State<MumbaiDepotsPage> createState() => _MumbaiDepotsPageState();
}

class _MumbaiDepotsPageState extends State<MumbaiDepotsPage> {
  List imglist = [
    'assets/bus.jpg',
    'assets/bus.jpg',
    'assets/bus.jpg',
    'assets/bus.jpg',
    'assets/bus.jpg',
    'assets/bus.jpg',
  ];
  List<String> citiesname = [
    // 'Jammu',
    // 'Shrinagar',
    'Shivaji Nagar',
    'Backbay',
    'Worli ',
    'Wadala',
    'Dahisar',
    'Deonar'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Depots'),
        backgroundColor: blue,
      ),
      body: GridView.count(
          crossAxisCount: 2,
          children: List.generate(citiesname.length, (index) {
            return cards(Image.asset(imglist[index]), citiesname[index], index);
          })),
    );
  }

  Widget cards(Image img, String title, int index) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: GestureDetector(
          onTap: (() {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OverviewPage(
                    depoName: 'nn',
                  ),
                ));
          }),
          child: Container(
            child: Column(
              children: [
                Image.asset(
                  imglist[index],
                  fit: BoxFit.fill,
                ),
                Text(title),
              ],
            ),
          ),
        ));
  }

  void onToScreen(int index) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MumbaiDepotsPage(),
        ));
  }
}
