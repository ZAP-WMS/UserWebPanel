import 'dart:async';
import 'package:assingment/overview/Jmr/jmr_home.dart';
import 'package:assingment/components/loading_page.dart';
import 'package:assingment/widget/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../Authentication/auth_service.dart';
import '../KeysEvents/Grid_DataTable.dart';

class Jmr extends StatefulWidget {
  int? finalLenOfView;
  String? cityName;
  String? depoName;
  Jmr({
    super.key,
    this.cityName,
    this.depoName,
    this.finalLenOfView,
  });

  @override
  State<Jmr> createState() => _JmrState();
}

class _JmrState extends State<Jmr> {
  TextEditingController selectedDepoController = TextEditingController();
  List currentTabList = [];
  String selectedDepot = '';
  int _selectedIndex = 0;
  bool _isLoading = true;
  List tabsForJmr = ['Civil', 'Electrical'];

  dynamic userId;
  List<String> title = [
    'R1',
    'R2',
    'R3',
    'R4',
    'R5',
    'R6',
    'R7',
    'R8',
    'R9',
    'R10'
  ];

  @override
  void initState() {
    getUserId().whenComplete(() => {
          getJmrLen(5),
        });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            actions: [
              Container(
                margin: const EdgeInsets.all(5.0),
                padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0),
                width: 200,
                height: 30,
                child: TypeAheadField(
                    animationStart: BorderSide.strokeAlignCenter,
                    hideOnLoading: true,
                    suggestionsCallback: (pattern) async {
                      return await getDepoList(pattern);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(
                          suggestion.toString(),
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      selectedDepoController.text = suggestion.toString();
                      selectedDepot = suggestion.toString();

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Jmr(
                              cityName: widget.cityName,
                              depoName: selectedDepot,
                            ),
                          ));
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                      decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.all(5.0),
                          hintText: 'Go To Depot'),
                      style: const TextStyle(fontSize: 15),
                      controller: selectedDepoController,
                    )),
              ),
              Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: GestureDetector(
                      onTap: () {
                        onWillPop(context);
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/logout.png',
                            height: 20,
                            width: 20,
                          ),
                          SizedBox(width: 5),
                          Text(
                            userId ?? '',
                            style: const TextStyle(fontSize: 18),
                          )
                        ],
                      ))),
            ],
            title: Text('${widget.cityName} / ${widget.depoName} / JMR'),
            backgroundColor: blue,
            bottom: TabBar(
              onTap: (value) {
                _selectedIndex = value;
                getJmrLen(5);
              },
              labelColor: white,
              labelStyle: buttonWhite,
              unselectedLabelColor: Colors.black,
              //indicatorSize: TabBarIndicatorSize.label,
              indicator: MaterialIndicator(
                  horizontalPadding: 24,
                  bottomLeftRadius: 8,
                  bottomRightRadius: 8,
                  color: white,
                  paintingStyle: PaintingStyle.fill),
              tabs: const [
                Tab(text: 'Civil Engineer'),
                Tab(text: 'Electrical Engineer'),
              ],
            ),
          ),
          body: _isLoading
              ? LoadingPage()
              : TabBarView(children: [
                  GridView.builder(
                      itemCount: 5,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisExtent: 250,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return cardlist(title[index], index, title[index],
                            'Civil', currentTabList[index]);
                      }),
                  GridView.builder(
                      itemCount: 5,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisExtent: 250,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return cardlist(title[index], index, title[index],
                            'Electrical', currentTabList[index]);
                      }),
                ]),
        ));
  }

  Widget cardlist(String title, int index, String title2, String Designation,
      int jmrListIndex) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        height: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: black)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  bottom: 8.0, left: 2.0, right: 2.0, top: 6.0),
              decoration:
                  const BoxDecoration(border: Border(bottom: BorderSide())),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {},
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      index != 0
                          ? currentTabList[index - 1] == 0
                              ? showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                        backgroundColor: Colors.blue[600],
                                        icon: const Icon(
                                          Icons.warning_amber,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                        title: const Text(
                                          'Please Create Jmr Orderly',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 13),
                                        ));
                                  },
                                )
                              : Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => JMRPage(
                                      showTable: false,
                                      title: '$Designation-$title',
                                      jmrTab: title,
                                      cityName: widget.cityName,
                                      depoName: widget.depoName,
                                      jmrIndex: index + 1,
                                      tabName: tabsForJmr[_selectedIndex],
                                    ),
                                  ),
                                ).then((_) {
                                  setState(() {
                                    currentTabList.clear();
                                    getJmrLen(5);
                                  });
                                })
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JMRPage(
                                  showTable: false,
                                  title: '$Designation-$title',
                                  jmrTab: title,
                                  cityName: widget.cityName,
                                  depoName: widget.depoName,
                                  jmrIndex: index + 1,
                                  tabName: tabsForJmr[_selectedIndex],
                                ),
                              ),
                            ).then((_) {
                              setState(() {
                                currentTabList.clear();
                                getJmrLen(5);
                              });
                            });
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: blue),
                    child: const Text(
                      'Create New JMR',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            SizedBox(
              height: 140,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: jmrListIndex,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('JMR${index + 1}'),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JMRPage(
                                    title:
                                        '$Designation-$title-JMR${index + 1}',
                                    jmrTab: title,
                                    cityName: widget.cityName,
                                    depoName: widget.depoName,
                                    showTable: true,
                                    dataFetchingIndex: index + 1,
                                    tabName: tabsForJmr[_selectedIndex],
                                  ),
                                )).then((_) {
                              setState(() {
                                getJmrLen(5);
                              });
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          child: const Text('View'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _space(double i) {
    return SizedBox(
      height: i,
    );
  }

  //Function for Reading Jmr List Length For Creating Jmr List below Create New JMR

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
  }

  Future<void> getJmrLen(int currentIndex) async {
    List<dynamic> eachTabJmrList = [];
    setState(() {
      _isLoading = true;
    });
    for (int i = 0; i < currentIndex; i++) {
      int tempNum = 0;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('JMRCollection')
          .doc(widget.depoName)
          .collection('Table')
          .doc('${tabsForJmr[_selectedIndex]}JmrTable')
          .collection('userId')
          .doc(userId)
          .collection('jmrTabName')
          .doc(title[i])
          .collection('jmrTabIndex')
          .get();
      tempNum = querySnapshot.docs.length;
      eachTabJmrList.add(tempNum);
    }
    currentTabList = eachTabJmrList;
    setState(() {
      _isLoading = false;
    });
  }

  Future<List<dynamic>> getDepoList(String pattern) async {
    List<dynamic> depoList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('DepoName')
        .doc(widget.cityName)
        .collection('AllDepots')
        .get();

    depoList = querySnapshot.docs.map((deponame) => deponame.id).toList();

    if (pattern.isNotEmpty) {
      depoList = depoList
          .where((element) => element
              .toString()
              .toUpperCase()
              .startsWith(pattern.toUpperCase()))
          .toList();
    }

    return depoList;
  }
}
