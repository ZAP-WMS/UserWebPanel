import 'package:assingment/Planning_Pages/electrical_quality_checklist.dart';
import 'package:assingment/Planning_Pages/quality_checklist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../../../datasource/o&m_datasource/daily_sfudatasource.dart';
import '../../../widget/style.dart';
import 'daily.dart';

class DailyManagementHomePage extends StatefulWidget {
  String? cityName;
  String? depoName;
  DailyManagementHomePage({super.key, required this.cityName, this.depoName});

  @override
  State<DailyManagementHomePage> createState() =>
      _DailyManagementHomePageState();
}

class _DailyManagementHomePageState extends State<DailyManagementHomePage> {
  int _selectedIndex = 0;
  TextEditingController selectedDepoController = TextEditingController();
  String? selectedDate = DateFormat.yMMMMd().format(DateTime.now());
  String selectedDepot = '';
  List<dynamic> tabledata2 = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 6,
        initialIndex: _selectedIndex,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: blue,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Report',
                  style: appFontSize,
                ),
                Text(
                  'City - ${widget.cityName}     Depot - ${widget.depoName}',
                  style: const TextStyle(
                    fontSize: 11,
                  ),
                )
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size(double.infinity, 50),
              child: TabBar(
                labelColor: yellow,
                labelStyle: buttonWhite,
                unselectedLabelColor: white,
                indicator: MaterialIndicator(
                    horizontalPadding: 24,
                    bottomLeftRadius: 8,
                    bottomRightRadius: 8,
                    color: white,
                    paintingStyle: PaintingStyle.fill),
                tabs: const [
                  Tab(text: 'Charger Checklist'),
                  Tab(text: 'SFU Checklist'),
                  Tab(text: 'PSS Checklist'),
                  Tab(text: 'Transformer Checklist'),
                  Tab(text: 'RMU Checklist'),
                  Tab(text: 'ACDB Checklist'),
                ],
                onTap: (value) {
                  print('indexxx$value');
                  setState(() {
                    _selectedIndex = value;
                  });
                },
              ),
            ),
            actions: [
              Row(
                children: [
                  IconButton(
                      onPressed: () {
                        chooseDate(context);
                      },
                      icon: const Icon(Icons.calendar_today)),
                  Text(
                    selectedDate!,
                    style: TextStyle(color: white, fontSize: 18),
                  )
                ],
              ),
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

                      // Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => QualityChecklist(
                      //         cityName: widget.cityName,
                      //         depoName: selectedDepot,
                      //       ),
                      //     ));
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
              //  widget.isHeader!

              //      ?
              Padding(
                padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: lightblue),
                  child: TextButton(
                      onPressed: () {
                        dailyStoreData('selectedDate'!);
                      },
                      child: Text(
                        'Sync Data',
                        style: TextStyle(color: white, fontSize: 20),
                      )),
                ),
              )
            ],
          ),
          body: TabBarView(
            children: [
              DailyManagementPage(
                cityName: widget.cityName,
                depoName: widget.depoName,
                tabletitle: 'Charger Checklist',
                tabIndex: _selectedIndex,
              ),
              DailyManagementPage(
                cityName: widget.cityName,
                depoName: widget.depoName,
                tabletitle: 'SFU Checklist',
                tabIndex: _selectedIndex,
              ),
              DailyManagementPage(
                cityName: widget.cityName,
                depoName: widget.depoName,
                tabIndex: _selectedIndex,
                tabletitle: 'PSS Checklist',
              ),
              DailyManagementPage(
                cityName: widget.cityName,
                depoName: widget.depoName,
                tabletitle: 'Transformer Checklist',
                tabIndex: _selectedIndex,
              ),
              DailyManagementPage(
                cityName: widget.cityName,
                depoName: widget.depoName,
                tabletitle: 'RMU Checklist',
                tabIndex: _selectedIndex,
              ),
              DailyManagementPage(
                cityName: widget.cityName,
                depoName: widget.depoName,
                tabletitle: 'ACDB Checklist',
                tabIndex: _selectedIndex,
              )
            ],
          ),
        ));
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

  void dailyStoreData(String selectedDate) {
    Map<String, dynamic> tableData = Map();
    DailySFUManagementDataSource? _dailySfuDataSource;
    // late DailyChargerManagementDataSource _dailyChargerDataSource;
    // late DailyPssManagementDataSource _dailyPssDataSource;
    // late DailyTranformerDataSource _dailyTranformerDataSource;
    // late DailyRmuDataSource _dailyRmuDataSource;
    // late DailyAcdbManagementDataSource _dailyAcdbdatasource;
    for (var i in _dailySfuDataSource!.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' && data.columnName != 'Delete') {
          tableData[data.columnName] = data.value;
        }
      }

      tabledata2.add(tableData);
      tableData = {};
    }

    FirebaseFirestore.instance
        .collection('DailyManagementPage')
        .doc('${widget.depoName}')
        .collection(selectedDate.toString())
        .doc(userId)
        .set({
      'data': tabledata2,
    }).whenComplete(() {
      tabledata2.clear();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });
  }

  void chooseDate(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('All Date'),
              content: Container(
                  height: 400,
                  width: 500,
                  child: SfDateRangePicker(
                    view: DateRangePickerView.month,
                    showTodayButton: false,
                    onSelectionChanged:
                        (DateRangePickerSelectionChangedArgs args) {
                      // if (args.value is PickerDateRange) {
                      //   // rangeStartDate = args.value.startDate;
                      //   // rangeEndDate = args.value.endDate;
                      // } else {
                      //   final List<PickerDateRange> selectedRanges = args.value;
                      // }
                    },
                    selectionMode: DateRangePickerSelectionMode.single,
                    showActionButtons: true,
                    onSubmit: ((value) {
                      selectedDate = DateFormat.yMMMMd()
                          .format(DateTime.parse(value.toString()));
                      Navigator.pop(context);
                      setState(() {});
                    }),
                    onCancel: () {
                      Navigator.pop(context);
                    },
                  )),
            ));
  }
}
