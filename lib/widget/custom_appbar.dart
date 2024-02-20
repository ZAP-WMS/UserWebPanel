import 'dart:html' as html;
import 'dart:io';
import 'package:assingment/overview/key_events2.dart';
import 'package:assingment/overview/material_vendor.dart';
import 'package:assingment/screen/overview_page.dart';
import 'package:assingment/widget/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../Authentication/auth_service.dart';
import '../Authentication/login_register.dart';
import '../Planning_Pages/jmr.dart';
import '../Planning_Pages/quality_checklist.dart';
import '../Planning_Pages/safety_checklist.dart';
import '../overview/closure_report.dart';
import '../overview/daily_project.dart';
import '../overview/depot_overview.dart';
import '../overview/detailed_Eng.dart';
import '../overview/key_events.dart';
import '../overview/monthly_project.dart';
import '../overview/testing_report.dart';
import '../provider/checkbox_provider.dart';
import '../provider/key_provider.dart';

class CustomAppBar extends StatefulWidget {
  String? cityname;
  int? progress;
  String? text;
  bool toOverviewPage;
  bool toOverview;
  bool toPlanning;
  bool toMaterial;
  bool toSubmission;
  bool toMonthly;
  bool toDetailEngineering;
  bool toJmr;
  bool toSafety;
  bool toChecklist;
  bool toTesting;
  bool toClosure;
  bool toEasyMonitoring;
  bool isDownload;
  VoidCallback? donwloadFunction;
  bool isprogress;
  dynamic totalValue;
  String? depotName;
  bool isCitiesPage;

  // final IconData? icon;
  final bool haveSynced;
  final bool haveSummary;
  final bool haveSend;
  final void Function()? sendEmail;
  final void Function()? store;
  VoidCallback? onTap;
  bool havebottom;
  bool havedropdown;
  bool isdetailedTab;
  bool showDepoBar;
  TabBar? tabBar;
  bool isDepoPage;

  CustomAppBar(
      {this.cityname,
      super.key,
      this.text,
      this.haveSend = false,
      this.haveSynced = false,
      this.haveSummary = false,
      this.sendEmail,
      this.store,
      this.onTap,
      this.havedropdown = false,
      this.havebottom = false,
      this.isdetailedTab = false,
      this.tabBar,
      this.showDepoBar = false,
      this.toChecklist = false,
      this.toTesting = false,
      this.toClosure = false,
      this.toEasyMonitoring = false,
      this.toSubmission = false,
      this.toOverviewPage = false,
      this.toOverview = false,
      this.toPlanning = false,
      this.toMaterial = false,
      this.toMonthly = false,
      this.toDetailEngineering = false,
      this.toJmr = false,
      this.toSafety = false,
      this.isprogress = false,
      this.totalValue,
      this.isDownload = false,
      this.donwloadFunction,
      this.progress,
      this.depotName,
      this.isCitiesPage = false,
      this.isDepoPage = false});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  KeyProvider? _keyProvider;
  CheckboxProvider? _checkboxProvider;
  dynamic userId;
  TextEditingController selectedDepoController = TextEditingController();
  String? rangeStartDate = DateFormat.yMMMMd().format(DateTime.now());
  String selectedDepot = '';

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _keyProvider = Provider.of<KeyProvider>(context, listen: false);
      _checkboxProvider = Provider.of<CheckboxProvider>(context, listen: false);
      _checkboxProvider!.fetchCcMaidId();
      _checkboxProvider!.fetchToMaidId();

      getUserId().whenComplete(() {
        setState(() {});
      });
    });

    super.initState();
  }

  Future<int> checkPercent() async {
    return widget.progress!.toInt();
  }

  List<String> _items = ['Item 1', 'Item 2', 'Item 3'];
  // List<bool> _checkedItems = [true, false, false];
  // String _selectedItem = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: widget.isCitiesPage ? true : false,
            backgroundColor: blue,
            title: widget.isCitiesPage
                ? const Text(
                    'Cities',
                    style: TextStyle(fontSize: 20),
                  )
                : widget.isDepoPage
                    ? Text(widget.cityname ?? "")
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.text.toString(),
                            style: appFontSize,
                          ),
                          Text(
                            'City - ${widget.cityname}     Depot - ${widget.depotName}',
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                          )
                        ],
                      ),
            actions: [
              widget.isprogress
                  ? FutureBuilder<int>(
                      future: checkPercent(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularPercentIndicator(radius: 2);
                        } else if (snapshot.hasData) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: SizedBox(
                              height: 18.0,
                              width: 40.0,
                              child: CircularPercentIndicator(
                                radius: 20.0,
                                lineWidth: 5.0,
                                percent: (Provider.of<KeyProvider>(context)
                                        .totalvalue
                                        .toInt()) /
                                    100,
                                center: Text(
                                  "${(widget.progress!.toInt()) / 100 * 100}% ",
                                  textAlign: TextAlign.center,
                                  style: captionWhite,
                                ),
                                progressColor: green,
                                backgroundColor: red,
                              ),
                            ),
                          );
                        }
                        return Container();
                      })
                  : Container(),
              widget.showDepoBar
                  ? Container(
                      margin: const EdgeInsets.all(8),
                      width: 200,
                      height: 30,
                      child: TypeAheadField(
                          animationStart: BorderSide.strokeAlignCenter,
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
                            widget.toOverviewPage
                                ? Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OverviewPage(
                                        cityName: widget.cityname,
                                        depoName: selectedDepot,
                                      ),
                                    ))
                                : widget.toOverview
                                    ? Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DepotOverview(
                                            cityName: widget.cityname,
                                            depoName: selectedDepot,
                                          ),
                                        ))
                                    : widget.toPlanning
                                        ? Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => KeyEvents2(
                                                depoName: suggestion,
                                                cityName: widget.cityname,
                                              ),
                                            ))
                                        : widget.toMaterial
                                            ? Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MaterialProcurement(
                                                    depoName: suggestion,
                                                    cityName: widget.cityname,
                                                  ),
                                                ))
                                            : widget.toSubmission
                                                ? Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DailyProject(
                                                        depoName: suggestion,
                                                        cityName:
                                                            widget.cityname,
                                                      ),
                                                    ))
                                                : widget.toMonthly
                                                    ? Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              MonthlyProject(
                                                            depoName:
                                                                suggestion,
                                                            cityName:
                                                                widget.cityname,
                                                          ),
                                                        ))
                                                    : widget.toDetailEngineering
                                                        ? Navigator
                                                            .pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          DetailedEng(
                                                                    cityName: widget
                                                                        .cityname,
                                                                    depoName:
                                                                        suggestion,
                                                                  ),
                                                                ))
                                                        : widget.toJmr
                                                            ? Navigator
                                                                .pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              Jmr(
                                                                        cityName:
                                                                            widget.cityname,
                                                                        depoName:
                                                                            suggestion,
                                                                      ),
                                                                    ))
                                                            : widget.toSafety
                                                                ? Navigator
                                                                    .pushReplacement(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              SafetyChecklist(
                                                                            cityName:
                                                                                widget.cityname,
                                                                            depoName:
                                                                                suggestion,
                                                                          ),
                                                                        ))
                                                                : widget.toChecklist
                                                                    ? Navigator.pushReplacement(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              QualityChecklist(
                                                                            cityName:
                                                                                widget.cityname,
                                                                            depoName:
                                                                                suggestion,
                                                                          ),
                                                                        ))
                                                                    : widget.toTesting
                                                                        ? Navigator.pushReplacement(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder: (context) => TestingReport(
                                                                                cityName: widget.cityname,
                                                                                depoName: suggestion,
                                                                              ),
                                                                            ))
                                                                        : widget.toClosure
                                                                            ? Navigator.pushReplacement(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                  builder: (context) => ClosureReport(
                                                                                    depoName: suggestion,
                                                                                    cityName: widget.cityname,
                                                                                  ),
                                                                                ))
                                                                            : widget.toEasyMonitoring
                                                                                ? Navigator.pushReplacement(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                      builder: (context) => KeyEvents(
                                                                                        depoName: selectedDepot,
                                                                                        cityName: widget.cityname,
                                                                                      ),
                                                                                    ))
                                                                                : ' ';
                          },
                          textFieldConfiguration: TextFieldConfiguration(
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.all(5.0),
                              hintText: 'Go To Depot',
                            ),
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                            controller: selectedDepoController,
                          )),
                    )
                  : Container(),
              const SizedBox(
                width: 10,
              ),
              widget.isprogress
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 300,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                legends(yellow, 'Base Line', black),
                                legends(green, 'On Time', black),
                                legends(red, 'Delay', white),
                              ],
                            )),
                        Consumer<KeyProvider>(
                          builder: (context, value, child) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 2, right: 10, left: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 130,
                                    color: green,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                          'Project Duration \n ${durationParse(value.startdate, value.endDate)} Days',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14, color: black)),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Container(
                                    width: 130,
                                    color: red,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                          'Project Delay \n ${durationParse(value.actualDate, value.endDate)}  Days ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14, color: white)),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Text('% Of Progress is '),
                                  SizedBox(
                                    height: 50.0,
                                    width: 40.0,
                                    child: CircularPercentIndicator(
                                      radius: 20.0,
                                      lineWidth: 4.0,
                                      percent:
                                          (value.perProgress.toInt()) / 100,
                                      center: Text(
                                        // value.getName.toString(),
                                        "${(value.perProgress.toInt())}% ",
                                        textAlign: TextAlign.center,
                                        style: captionWhite,
                                      ),
                                      progressColor: green,
                                      backgroundColor: red,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : Container(),
              widget.haveSend
                  ? Consumer<CheckboxProvider>(
                      builder: (context, value, child) {
                        // print(value.myBooleanValue);
                        return TextButton(
                            onPressed: widget.sendEmail,
                            // () {

                            // _showCheckboxDialog(context, _checkboxProvider!,
                            //     widget.depotName!);
                            // },
                            child: Text(
                              'Send Email',
                              style: TextStyle(color: white),
                            ));
                      },

                      // showDialog(
                      //     context: context,
                      //     builder: (context) => AlertDialog(
                      //         content: SizedBox(
                      //             height: 100,
                      //             child: Column(
                      //               mainAxisAlignment:
                      //                   MainAxisAlignment.spaceBetween,
                      //               children: [
                      //                 Text(
                      //                     'Employee ID: ${row.getCells()[0].value.toString()}'),
                      //                 Text(
                      //                     'Employee Name: ${row.getCells()[1].value.toString()}'),
                      //                 Text(
                      //                     'Employee Designation: ${row.getCells()[2].value.toString()}'),
                      //               ],
                      //             ))));
                      //  PopupMenuButton<int>(
                      //   icon: const Text('Send Email'),
                      //   itemBuilder: (BuildContext context) {
                      //     return _items.asMap().entries.map((entry) {
                      //       int index = entry.key;
                      //       String item = entry.value;
                      //       print('object${value.myBooleanValue[index]}');
                      //       return PopupMenuItem<int>(
                      //         value: index,
                      //         child: Row(
                      //           children: [
                      //             Checkbox(
                      //               value: value.myBooleanValue[index],
                      //               checkColor:
                      //                   white, // Change the color of the checkmark
                      //               activeColor: Theme.of(context)
                      //                   .colorScheme
                      //                   .secondary,

                      //               onChanged: (bool? newValue) {
                      //                 _checkboxProvider!.setMyBooleanValue(
                      //                     index, newValue!);
                      //               },
                      //             ),
                      //             Text(item),
                      //           ],
                      //         ),
                      //       );
                      //     }).toList();
                      //   },
                      //   onSelected: (int index) {
                      //     // Handle item selection
                      //     print('Selected item: ${_items[index]}');
                      //   },
                      // ),
                    )
                  : Container(),
              //    ],
              //   ),
              // Container(
              //     margin: const EdgeInsets.all(8.0),
              //     height: 500,
              //     width: 500,
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(2),
              //         color: Colors.blue),
              //     child: Column(
              //       children: [
              //         DropdownButton<String>(
              //           value:
              //               _selectedItem.isNotEmpty ? _selectedItem : null,
              //           hint:const Text('Select an item'),
              //           onChanged: (String? newValue) {
              //             setState(() {
              //               _selectedItem = newValue!;
              //             });
              //           },
              //           items: _items
              //               .map<DropdownMenuItem<String>>((String value) {
              //             return DropdownMenuItem<String>(
              //                 value: value,
              //                 child: ListView.builder(
              //                     shrinkWrap: true,
              //                     itemCount: _items.length,
              //                     itemBuilder:
              //                         (BuildContext context, int index) {
              //                       return CheckboxListTile(
              //                         title: Text(_items[index]),
              //                         value: _checked[index],
              //                         onChanged: (bool? value) {
              //                           setState(() {
              //                             _checked[index] = value!;
              //                           });
              //                         },
              //                       );
              //                     }));
              //           }).toList(),
              //         ),
              //       ],
              //     )
              //     //  TextButton(
              //     //     onPressed: widget.sendEmail,
              //     //     child: Text(
              //     //       'Send Email',
              //     //       style: TextStyle(color: white, fontSize: 15),
              //     //     )),
              //     )
              //   : Container(),
              widget.haveSummary
                  ? Container(
                      margin: const EdgeInsets.all(8.0),
                      height: 15,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Colors.blue),
                      child: TextButton(
                          onPressed: widget.onTap,
                          child: Text(
                            'View Summary',
                            style: TextStyle(color: white, fontSize: 15),
                          )),
                    )
                  : Container(),
              widget.haveSynced
                  ? Container(
                      margin: const EdgeInsets.all(8.0),
                      height: 15,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.blue),
                      child: TextButton(
                          onPressed: () {
                            widget.store!();
                          },
                          child: Text(
                            'Sync Data',
                            style: TextStyle(color: white, fontSize: 15),
                          )),
                    )
                  : Container(),
              widget.isDownload
                  ? Container(
                      margin: const EdgeInsets.all(5),
                      child: ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blue)),
                        onPressed: widget.donwloadFunction,
                        child: const Icon(Icons.download, color: Colors.white),
                      ),
                    )
                  : Container(),
              const SizedBox(width: 10),
              Container(
                  margin: const EdgeInsets.all(10.0),
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
                          const SizedBox(width: 5),
                          Text(
                            userId ?? '',
                            style: appFontSize,
                          )
                        ],
                      ))),
            ],
            bottom: widget.havebottom
                ? TabBar(
                    labelColor: Colors.yellow,
                    labelStyle: buttonWhite,
                    unselectedLabelColor: white,

                    //indicatorSize: TabBarIndicatorSize.label,
                    indicator: MaterialIndicator(
                      horizontalPadding: 24,
                      bottomLeftRadius: 8,
                      bottomRightRadius: 8,
                      color: almostblack,
                      paintingStyle: PaintingStyle.fill,
                    ),

                    tabs: const [
                      Tab(text: "PSS"),
                      Tab(text: "RMU"),
                      Tab(text: "PSS"),
                      Tab(text: "RMU"),
                      Tab(text: "PSS"),
                      Tab(text: "RMU"),
                      Tab(text: "PSS"),
                      Tab(text: "RMU"),
                      Tab(text: "PSS"),
                    ],
                  )
                : widget.isdetailedTab
                    ? TabBar(
                        labelColor: Colors.yellow,
                        labelStyle: buttonWhite,
                        unselectedLabelColor: white,

                        //indicatorSize: TabBarIndicatorSize.label,
                        indicator: MaterialIndicator(
                          horizontalPadding: 24,
                          bottomLeftRadius: 8,
                          bottomRightRadius: 8,
                          color: almostblack,
                          paintingStyle: PaintingStyle.fill,
                        ),

                        tabs: const [
                          Tab(text: "RFC Drawings of Civil Activities"),
                          Tab(
                              text:
                                  "EV Layout Drawings of Electrical Activities"),
                          Tab(text: "Shed Lighting Drawings & Specification"),
                        ],
                      )
                    : widget.tabBar));
  }

  Future<bool> onWillPop(BuildContext context) async {
    bool a = false;
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Close TATA POWER?",
                      style: subtitle1White,
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              //color: blue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            //color: blue,
                            child: Center(
                                child: Text(
                              "No",
                              style: button.copyWith(color: blue),
                            )),
                          ),
                        )),
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            a = true;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginRegister(),
                                ));
                            // exit(0);
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: blue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            //color: blue,
                            child: Center(
                                child: Text(
                              "Yes",
                              style: button,
                            )),
                          ),
                        ))
                      ],
                    )
                  ],
                ),
              ),
            ));
    return a;
  }

  Future<List<dynamic>> getDepoList(String pattern) async {
    List<dynamic> depoList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('DepoName')
        .doc(widget.cityname)
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

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
  }
}

// _showCheckboxDialog(
//     BuildContext context, CheckboxProvider checkboxProvider, String depoName) {
//   checkboxProvider.myCcBooleanValue.clear();
//   checkboxProvider.myToBooleanValue.clear();
//   checkboxProvider.myCcBooleanValue.add(false);
//   checkboxProvider.myToBooleanValue.add(false);
//   checkboxProvider.ccValue.clear();
//   checkboxProvider.toValue.clear();

//   // List<String>? currentToValue = [];
//   // List<String>? currentCcValue = [];

//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return Consumer<CheckboxProvider>(
//         builder: (context, value, child) {
//           return Container(
//             padding: const EdgeInsetsDirectional.all(0),
//             margin: const EdgeInsets.all(15),
//             width: MediaQuery.of(context).size.width * 0.5,
//             child: AlertDialog(
//               title: const Text('Choose Required Filled For Email'),
//               content: Row(mainAxisSize: MainAxisSize.max, children: [
//                 Expanded(
//                   child: Column(children: [
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       child: Text(
//                         'Choose To',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: black,
//                             fontSize: 18),
//                         textAlign: TextAlign.start,
//                       ),
//                     ),
//                     ...List.generate(
//                       value.myToMailValue.length,
//                       (index) {
//                         // print('iji$index');

//                         for (int i = 0; i <= value.myToMailValue.length; i++) {
//                           checkboxProvider.defaultToBooleanValue.add(false);
//                         }

//                         return Flexible(
//                           child: Row(
//                             children: [
//                               Checkbox(
//                                 // title: Text(value.myCcMailValue[index]),
//                                 value: value.myToBooleanValue[index],
//                                 onChanged: (bool? newboolean) {
//                                   if (newboolean != null) {
//                                     checkboxProvider.setMyToBooleanValue(
//                                         index, newboolean);
//                                   }

//                                   if (value.myToBooleanValue[index] != null &&
//                                       value.myToBooleanValue[index] == true) {
//                                     print('index$index');
//                                     checkboxProvider.getCurrentToValue(
//                                         index, value.myToMailValue[index]);
//                                   } else {
//                                     value.toValue
//                                         .remove(value.myToMailValue[index]);
//                                   }
//                                   print(value.ccValue);
//                                 },
//                               ),
//                               Text(
//                                 value.myToMailValue[index],
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ]),
//                 ),
//                 Expanded(
//                   child: Column(children: [
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       child: Text(
//                         'Choose Cc',
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: black,
//                             fontSize: 18),
//                         textAlign: TextAlign.start,
//                       ),
//                     ),
//                     ...List.generate(
//                       value.myCcMailValue.length,
//                       (index) {
//                         // print('iji$index');
//                         for (int i = 0; i <= value.myCcMailValue.length; i++) {
//                           checkboxProvider.defaultCcBooleanValue.add(false);
//                         }
//                         return Flexible(
//                           child: Row(
//                             children: [
//                               Checkbox(
//                                 value: value.myCcBooleanValue[index],
//                                 onChanged: (bool? newboolean) {
//                                   if (newboolean != null) {
//                                     checkboxProvider.setMyCcBooleanValue(
//                                         index, newboolean);
//                                   }
//                                   if (value.myCcBooleanValue[index] != null &&
//                                       value.myCcBooleanValue[index] == true) {
//                                     print('index$index');
//                                     checkboxProvider.getCurrentCcValue(
//                                         index, value.myCcMailValue[index]);
//                                   } else {
//                                     value.ccValue
//                                         .remove(value.myCcMailValue[index]);
//                                   }
//                                 },
//                               ),
//                               Text(value.myCcMailValue[index]),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ]),
//                 ),
//               ]),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('Close'),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     // Do something with the checked items
//                     print(checkboxProvider.ccValue);

//                     // sendEmail(
//                     //     'Daily Project Details of $depoName'
//                     //         .split('+')
//                     //         .join(' '),
//                     //     'hiii amirr how are you'.split('+').join(' '),
//                     //     'https://firebasestorage.googleapis.com/v0/b/tp-zap-solz.appspot.com/o/Downloaded%20File%2FDaily%20Report.pdf?alt=media&token=8c8918b5-d0f7-4fc0-8681-21d812634f1a',
//                     //     checkboxProvider.toValue,
//                     //     checkboxProvider.ccValue);

//                     Navigator.of(context).pop();
//                   },
//                   child: const Text('Send'),
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     },
//   );
// }

// sendEmail(String subject, String body, String attachmentUrl,
//     List<String> toRecipients, List<String> ccRecipients) {
//   // Construct the mailto URL

//   String encodedSubject = Uri.decodeComponent(subject);
//   String encodedBody = Uri.encodeComponent(body);
//   // String encodedAttachmentUrl = attachmentUrl;
//   String toParameter = toRecipients.map((cc) => cc).join(',');
//   String ccParameter = ccRecipients.map((cc) => cc).join(',');

//   final Uri params = Uri(
//     scheme: 'mailto',
//     path: '', // email address goes here
//     queryParameters: {
//       'subject': encodedSubject,
//       'body': body += '\n\nAttachment: $attachmentUrl',
//       // 'attachment': attachmentUrl,
//       //encodedAttachmentUrl, // attachment url if needed

//       'to': toParameter,
//       'cc': ccParameter,
//     },
//   );
//   print('gfgfh&$ccParameter');

//   // Encode and launch the mailto URL
//   html.window.open(params.toString(), 'email');
// }

legends(Color color, String title, Color textColor) {
  return Padding(
    padding: const EdgeInsets.only(top: 5, bottom: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            width: 75,
            height: 28,
            color: color,
            padding: const EdgeInsets.all(5),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w900, color: textColor),
            )),
      ],
    ),
  );
}

int durationParse(String fromtime, String todate) {
  DateTime startdate = DateFormat('dd-MM-yyyy').parse(fromtime);
  DateTime enddate = DateFormat('dd-MM-yyyy').parse(todate);
  return enddate.add(Duration(days: 1)).difference(startdate).inDays;
}
