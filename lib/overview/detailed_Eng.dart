import 'package:assingment/components/loading_page.dart';
import 'package:assingment/datasource/detailedeng_datasource.dart';
import 'package:assingment/model/detailed_engModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../Authentication/auth_service.dart';
import '../KeysEvents/Grid_DataTable.dart';
import '../datasource/detailedengEV_datasource.dart';
import '../datasource/detailedengShed_datasource.dart';
import '../widget/style.dart';

List<dynamic> globalIndexDetailedList = [];
List<bool> isShowPinIconInDetail = [false, false, false];

class DetailedEng extends StatefulWidget {
  String? cityName;
  String? depoName;
  String? userId;
  DetailedEng(
      {super.key, required this.cityName, required this.depoName, this.userId});

  @override
  State<DetailedEng> createState() => _DetailedEngtState();
}

class _DetailedEngtState extends State<DetailedEng>
    with TickerProviderStateMixin {
  List<String> tabNames = [
    'RFC LAYOUT DRAWING',
    'EV LAYOUT DRAWING',
    'Shed LAYOUT DRAWING',
  ];

  List<DetailedEngModel> DetailedProject = <DetailedEngModel>[];
  List<DetailedEngModel> DetailedProjectev = <DetailedEngModel>[];
  List<DetailedEngModel> DetailedProjectshed = <DetailedEngModel>[];
  late DetailedEngSourceShed _detailedEngSourceShed;
  late DetailedEngSource _detailedDataSource;
  late DetailedEngSourceEV _detailedEngSourceev;
  late DataGridController _dataGridController;
  List<dynamic> tabledata2 = [];
  List<dynamic> ev_tabledatalist = [];
  List<dynamic> shed_tabledatalist = [];
  TabController? _controller;
  int _selectedIndex = 0;
  bool isLoading = false;
  Stream? _stream;
  Stream? _stream1;
  Stream? _stream2;
  var alldata;
  bool _isloading = true;
  TextEditingController selectedDepoController = TextEditingController();

  @override
  void initState() {
    checkAvailableImage().whenComplete(() {
      _detailedDataSource = DetailedEngSource(
          DetailedProject,
          context,
          widget.cityName.toString(),
          widget.depoName.toString(),
          widget.userId!);
      _dataGridController = DataGridController();

      // DetailedProjectev = getmonthlyReportEv();
      _detailedEngSourceev = DetailedEngSourceEV(
          DetailedProjectev,
          context,
          widget.cityName.toString(),
          widget.depoName.toString(),
          widget.userId!);
      _dataGridController = DataGridController();

      // DetailedProjectshed = getmonthlyReportEv();
      _detailedEngSourceShed = DetailedEngSourceShed(
          DetailedProjectshed,
          context,
          widget.cityName.toString(),
          widget.depoName.toString(),
          widget.userId!);
      _dataGridController = DataGridController();
      _controller = TabController(length: 3, vsync: this);

      _stream = FirebaseFirestore.instance
          .collection('DetailEngineering')
          .doc('${widget.depoName}')
          .collection('RFC LAYOUT DRAWING')
          .doc(widget.userId!)
          .snapshots();

      _stream1 = FirebaseFirestore.instance
          .collection('DetailEngineering')
          .doc('${widget.depoName}')
          .collection('EV LAYOUT DRAWING')
          .doc(widget.userId!)
          .snapshots();

      _stream2 = FirebaseFirestore.instance
          .collection('DetailEngineering')
          .doc('${widget.depoName}')
          .collection('Shed LAYOUT DRAWING')
          .doc(widget.userId!)
          .snapshots();

      _isloading = false;
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: const Duration(milliseconds: 500),
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: white,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Detailed Engineering',
                  style: appFontSize,
                ),
                Text(
                  'City - ${widget.cityName}     Depot - ${widget.depoName}' ??
                      '',
                  style: const TextStyle(
                    fontSize: 11,
                  ),
                )
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8.0),
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
                        title: Text(suggestion.toString()),
                      );
                    },
                    onSuggestionSelected: (suggestion) {
                      selectedDepoController.text = suggestion.toString();

                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailedEng(
                              cityName: widget.cityName,
                              depoName: suggestion.toString(),
                            ),
                          ));
                    },
                    textFieldConfiguration: TextFieldConfiguration(
                      decoration: const InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding: EdgeInsets.all(5.0),
                          hintText: 'Go To Depot'),
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                      controller: selectedDepoController,
                    )),
              ),
              Container(
                margin: const EdgeInsets.all(10.0),
                height: 15,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2), color: Colors.blue),
                child: TextButton(
                    onPressed: () {
                      _showDialog(context);
                      StoreData();
                    },
                    child: Text(
                      'Sync Data',
                      style: TextStyle(color: white, fontSize: 20),
                    )),
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                            widget.userId! ?? '',
                            style: const TextStyle(fontSize: 18),
                          )
                        ],
                      ))),
            ],
            bottom: TabBar(
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.bold),
              indicatorWeight: 3.0,
              unselectedLabelColor: Colors.grey,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold),
              labelColor: blue,
              onTap: (value) {
                _selectedIndex = value;
                _isloading = true;
                setState(() {});
                checkAvailableImage().whenComplete(() {
                  setState(() {
                    _isloading = false;
                  });
                });
              },
              tabs: const [
                Tab(text: "RFC Drawings of Civil Activities"),
                Tab(text: "EV Layout Drawings of Electrical Activities"),
                Tab(text: "Shed Lighting Drawings & Specification"),
              ],
            ),
            flexibleSpace: Container(
              height: 55,
              color: blue,
            )),
        body: TabBarView(children: [
          tabScreen(),
          tabScreen1(),
          tabScreen2(),
        ]),
      ),
    );
  }

  void StoreData() {
    tabledata2.clear();
    Map<String, dynamic> table_data = Map();
    Map<String, dynamic> ev_table_data = Map();
    Map<String, dynamic> shed_table_data = Map();

    for (var i in _detailedDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' &&
            data.columnName != 'ViewDrawing' &&
            data.columnName != "Delete" &&
            data.columnName != "Add") {
          table_data[data.columnName] = data.value;
        }
      }

      tabledata2.add(table_data);
      table_data = {};
      print(tabledata2);
    }

    FirebaseFirestore.instance
        .collection('DetailEngineering')
        .doc('${widget.depoName}')
        .collection('RFC LAYOUT DRAWING')
        .doc(widget.userId!)
        .set({
      'data': tabledata2,
    }).whenComplete(() {
      tabledata2.clear();
      for (var i in _detailedEngSourceev.dataGridRows) {
        for (var data in i.getCells()) {
          if (data.columnName != 'button' &&
              data.columnName != 'ViewDrawing' &&
              data.columnName != "Delete" &&
              data.columnName != "Add") {
            ev_table_data[data.columnName] = data.value;
          }
        }

        ev_tabledatalist.add(ev_table_data);
        ev_table_data = {};
      }

      FirebaseFirestore.instance
          .collection('DetailEngineering')
          .doc('${widget.depoName}')
          .collection('EV LAYOUT DRAWING')
          .doc(widget.userId!)
          .set({
        'data': ev_tabledatalist,
      }).whenComplete(() {
        ev_tabledatalist.clear();
        for (var i in _detailedEngSourceShed.dataGridRows) {
          for (var data in i.getCells()) {
            if (data.columnName != 'button' &&
                data.columnName != 'ViewDrawing' &&
                data.columnName != "Delete" &&
                data.columnName != "Add") {
              shed_table_data[data.columnName] = data.value;
            }
          }

          shed_tabledatalist.add(shed_table_data);
          shed_table_data = {};
        }

        FirebaseFirestore.instance
            .collection('DetailEngineering')
            .doc('${widget.depoName}')
            .collection('Shed LAYOUT DRAWING')
            .doc(widget.userId!)
            .set({
          'data': shed_tabledatalist,
        }).whenComplete(() {
          shed_tabledatalist.clear();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Data are synced'),
            backgroundColor: blue,
          ));
        });
      });
      // tabledata2.clear();
    });
  }

  List<DetailedEngModel> getmonthlyReportEv() {
    return [
      DetailedEngModel(
        siNo: 2,
        title: '',
        number: null,
        preparationDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        submissionDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        approveDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        releaseDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      ),
    ];
  }

  List<DetailedEngModel> getmonthlyReportShed() {
    return [
      DetailedEngModel(
        siNo: 2,
        title: '',
        number: null,
        preparationDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        submissionDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        approveDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        releaseDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      ),
    ];
  }

  List<DetailedEngModel> getmonthlyReport() {
    return [
      // DetailedEngModel(
      //   siNo: 1,
      //   title: 'RFC Drawings of Civil Activities',
      //   number: 0,
      //   preparationDate: '',
      //   submissionDate: '',
      //   approveDate: '',
      //   releaseDate: '',
      // ),
      DetailedEngModel(
        siNo: 1,
        title: '',
        number: null,
        preparationDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        submissionDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        approveDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        releaseDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      ),
      // DetailedEngModel(
      //   siNo: 3,
      //   title: 'EV Layout Drawings of Electrical Activities',
      //   number: 0,
      //   preparationDate: '',
      //   submissionDate: '',
      //   approveDate: '',
      //   releaseDate: '',
      // ),
      // DetailedEngModel(
      //   siNo: 2,
      //   title: 'Electrical Work',
      //   number: null,
      //   preparationDate: DateFormat('dd-MM-yyyy') .format(DateTime.now()),
      //   submissionDate: DateFormat('dd-MM-yyyy') .format(DateTime.now()),
      //   approveDate: DateFormat('dd-MM-yyyy') .format(DateTime.now()),
      //   releaseDate: DateFormat('dd-MM-yyyy') .format(DateTime.now()),
      // ),
      // DetailedEngModel(
      //   siNo: 5,
      //   title: 'Shed Lighting Drawings & Specification',
      //   number: 0,
      //   preparationDate: '',
      //   submissionDate: '',
      //   approveDate: '',
      //   releaseDate: '',
      // ),
      // DetailedEngModel(
      //   siNo: 3,
      //   title: 'Illumination Design',
      //   number: null,
      //   preparationDate: DateFormat('dd-MM-yyyy') .format(DateTime.now()),
      //   submissionDate: DateFormat('dd-MM-yyyy') .format(DateTime.now()),
      //   approveDate: DateFormat('dd-MM-yyyy') .format(DateTime.now()),
      //   releaseDate: DateFormat('dd-MM-yyyy') .format(DateTime.now()),
      // ),
    ];
  }

  tabScreen() {
    return Scaffold(
        body: _isloading
            ? LoadingPage()
            : Column(children: [
                Expanded(
                    child: SfDataGridTheme(
                  data: SfDataGridThemeData(
                      headerColor: white, gridLineColor: blue),
                  child: StreamBuilder(
                    stream: _stream,
                    builder: (context, snapshot) {
                      DetailedProject.clear();
                      if (!snapshot.hasData || snapshot.data.exists == false) {
                        return SfDataGrid(
                            source: _selectedIndex == 0
                                ? _detailedDataSource
                                : _detailedEngSourceev,
                            allowEditing: true,
                            frozenColumnsCount: 3,
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            selectionMode: SelectionMode.single,
                            navigationMode: GridNavigationMode.cell,
                            columnWidthMode: ColumnWidthMode.auto,
                            editingGestureType: EditingGestureType.tap,
                            headerRowHeight: 50,
                            controller: _dataGridController,
                            rowHeight: 50,
                            onQueryRowHeight: (details) {
                              return details
                                  .getIntrinsicRowHeight(details.rowIndex);
                            },
                            columns: [
                              GridColumn(
                                visible: false,
                                columnName: 'SiNo',
                                autoFitPadding: tablepadding,
                                allowEditing: true,
                                width: 80,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Si.No.',
                                      overflow: TextOverflow.values.first,
                                      textAlign: TextAlign.center,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'button',
                                width: 120,
                                allowEditing: false,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('Upload drawing ',
                                      textAlign: TextAlign.center,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ViewDrawing',
                                width: 100,
                                allowEditing: false,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('View drawing ',
                                      textAlign: TextAlign.center,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Title',
                                allowEditing: true,
                                width: 300,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Description',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Number',
                                allowEditing: true,
                                width: 130,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Drawing number',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'PreparationDate',
                                allowEditing: false,
                                width: 130,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Preparation date',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'SubmissionDate',
                                allowEditing: false,
                                width: 130,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('Submission date',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ApproveDate',
                                allowEditing: false,
                                width: 130,
                                label: Container(
                                  alignment: Alignment.center,
                                  child: Text('Approve date',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ReleaseDate',
                                allowEditing: false,
                                width: 140,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Release date',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Add',
                                autoFitPadding: tablepadding,
                                allowEditing: false,
                                width: 85,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Add row',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor,

                                    //    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Delete',
                                autoFitPadding: tablepadding,
                                allowEditing: false,
                                width: 100,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Delete row',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                            ]);
                      } else {
                        alldata = '';
                        _detailedDataSource.buildDataGridRows();
                        _detailedDataSource.updateDatagridSource();
                        alldata = snapshot.data['data'] as List<dynamic>;
                        alldata.forEach((element) {
                          DetailedProject.add(
                              DetailedEngModel.fromjsaon(element));
                          _detailedDataSource = DetailedEngSource(
                              DetailedProject,
                              context,
                              widget.cityName.toString(),
                              widget.depoName.toString(),
                              widget.userId!);
                        });
                        _dataGridController = DataGridController();

                        return SfDataGrid(
                            source: _selectedIndex == 0
                                ? _detailedDataSource
                                : _detailedEngSourceev,
                            allowEditing: true,
                            frozenColumnsCount: 3,
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            selectionMode: SelectionMode.single,
                            navigationMode: GridNavigationMode.cell,
                            columnWidthMode: ColumnWidthMode.auto,
                            rowHeight: 50,
                            editingGestureType: EditingGestureType.tap,
                            controller: _dataGridController,
                            onQueryRowHeight: (details) {
                              return details
                                  .getIntrinsicRowHeight(details.rowIndex);
                            },
                            columns: [
                              GridColumn(
                                visible: false,
                                columnName: 'SiNo',
                                autoFitPadding: tablepadding,
                                allowEditing: true,
                                width: 80,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Si.No.',
                                      overflow: TextOverflow.values.first,
                                      textAlign: TextAlign.center,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'button',
                                width: 120,
                                allowEditing: false,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Upload drawing ',
                                      textAlign: TextAlign.center,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ViewDrawing',
                                width: 100,
                                allowEditing: false,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('View drawing ',
                                      textAlign: TextAlign.center,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Title',
                                autoFitPadding: tablepadding,
                                allowEditing: true,
                                width: 300,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Description',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Number',
                                autoFitPadding: tablepadding,
                                allowEditing: true,
                                width: 130,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Drawing number',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'PreparationDate',
                                autoFitPadding: tablepadding,
                                allowEditing: false,
                                width: 130,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Preparation date',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'SubmissionDate',
                                autoFitPadding: tablepadding,
                                allowEditing: false,
                                width: 130,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Submission date',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ApproveDate',
                                autoFitPadding: tablepadding,
                                allowEditing: false,
                                width: 130,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Approve date',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ReleaseDate',
                                autoFitPadding: tablepadding,
                                allowEditing: false,
                                width: 140,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Release date',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Add',
                                autoFitPadding: tablepadding,
                                allowEditing: false,
                                width: 85,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Add row',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Delete',
                                autoFitPadding: tablepadding,
                                allowEditing: false,
                                width: 100,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Delete row',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                            ]);
                      }
                    },
                  ),
                )),
              ]),
        floatingActionButton: FloatingActionButton(
          onPressed: (() {
            globalIndexDetailedList.add(0);
            isShowPinIconInDetail.add(false);
            DetailedProject.add(DetailedEngModel(
              siNo: 1,
              title: '',
              number: null,
              preparationDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
              submissionDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
              approveDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
              releaseDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
            ));
            _detailedDataSource.buildDataGridRows();
            _detailedDataSource.updateDatagridSource();
          }),
          child: const Icon(Icons.add),
        ));
  }

  tabScreen1() {
    return Scaffold(
      body: _isloading
          ? LoadingPage()
          : Column(children: [
              Expanded(
                  child: SfDataGridTheme(
                data: SfDataGridThemeData(
                    headerColor: white, gridLineColor: blue),
                child: StreamBuilder(
                  stream: _stream1,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data.exists == false) {
                      return SfDataGrid(
                          source: _selectedIndex == 0
                              ? _detailedDataSource
                              : _detailedEngSourceev,
                          allowEditing: true,
                          frozenColumnsCount: 2,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          selectionMode: SelectionMode.single,
                          navigationMode: GridNavigationMode.cell,
                          columnWidthMode: ColumnWidthMode.auto,
                          editingGestureType: EditingGestureType.tap,
                          controller: _dataGridController,
                          headerRowHeight: 50,
                          rowHeight: 50,
                          onQueryRowHeight: (details) {
                            return details
                                .getIntrinsicRowHeight(details.rowIndex);
                          },
                          columns: [
                            GridColumn(
                              visible: false,
                              columnName: 'SiNo',
                              autoFitPadding: tablepadding,
                              allowEditing: true,
                              width: 80,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Si.No.',
                                    overflow: TextOverflow.values.first,
                                    textAlign: TextAlign.center,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'button',
                              width: 120,
                              allowEditing: false,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Upload drawing ',
                                    textAlign: TextAlign.center,
                                    style: tableheaderwhitecolor),
                              ),
                            ),
                            GridColumn(
                              columnName: 'ViewDrawing',
                              width: 100,
                              allowEditing: false,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('View drawing ',
                                    textAlign: TextAlign.center,
                                    style: tableheaderwhitecolor),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Title',
                              autoFitPadding: tablepadding,
                              allowEditing: true,
                              width: 300,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Description',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Number',
                              autoFitPadding: tablepadding,
                              allowEditing: true,
                              width: 130,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Drawing number',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'PreparationDate',
                              autoFitPadding: tablepadding,
                              allowEditing: false,
                              width: 130,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Preparation date',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'SubmissionDate',
                              autoFitPadding: tablepadding,
                              allowEditing: false,
                              width: 130,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Submission date',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'ApproveDate',
                              autoFitPadding: tablepadding,
                              allowEditing: false,
                              width: 130,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Approve date',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'ReleaseDate',
                              autoFitPadding: tablepadding,
                              allowEditing: false,
                              width: 140,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Release date',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Add',
                              autoFitPadding: tablepadding,
                              allowEditing: false,
                              width: 85,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Add row',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Delete',
                              autoFitPadding: tablepadding,
                              allowEditing: false,
                              width: 100,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Delete row',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                          ]);
                    } else {
                      alldata = '';
                      alldata = snapshot.data['data'] as List<dynamic>;
                      DetailedProjectev.clear();
                      _detailedEngSourceev.buildDataGridRowsEV();
                      _detailedEngSourceev.updateDatagridSource();
                      alldata.forEach((element) {
                        DetailedProjectev.add(
                            DetailedEngModel.fromjsaon(element));
                        _detailedEngSourceev = DetailedEngSourceEV(
                            DetailedProjectev,
                            context,
                            widget.cityName.toString(),
                            widget.depoName.toString(),
                            widget.userId!);
                        _dataGridController = DataGridController();
                      });

                      return SfDataGrid(
                          source: _selectedIndex == 0
                              ? _detailedDataSource
                              : _detailedEngSourceev,
                          allowEditing: true,
                          frozenColumnsCount: 2,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          selectionMode: SelectionMode.single,
                          navigationMode: GridNavigationMode.cell,
                          columnWidthMode: ColumnWidthMode.auto,
                          editingGestureType: EditingGestureType.tap,
                          rowHeight: 50,
                          headerRowHeight: 50,
                          controller: _dataGridController,
                          onQueryRowHeight: (details) {
                            return details
                                .getIntrinsicRowHeight(details.rowIndex);
                          },
                          columns: [
                            GridColumn(
                              visible: false,
                              columnName: 'SiNo',
                              autoFitPadding: tablepadding,
                              allowEditing: true,
                              width: 80,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Si.No.',
                                    overflow: TextOverflow.values.first,
                                    textAlign: TextAlign.center,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'button',
                              width: 120,
                              allowEditing: false,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Upload drawing ',
                                    textAlign: TextAlign.center,
                                    style: tableheaderwhitecolor),
                              ),
                            ),
                            GridColumn(
                              columnName: 'ViewDrawing',
                              width: 100,
                              allowEditing: false,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('View drawing ',
                                    textAlign: TextAlign.center,
                                    style: tableheaderwhitecolor),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Title',
                              autoFitPadding: tablepadding,
                              allowEditing: true,
                              width: 300,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Description',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Number',
                              autoFitPadding: tablepadding,
                              allowEditing: true,
                              width: 130,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Drawing number',
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'PreparationDate',
                              autoFitPadding: tablepadding,
                              allowEditing: false,
                              width: 130,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Preparation date',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'SubmissionDate',
                              autoFitPadding: tablepadding,
                              allowEditing: false,
                              width: 130,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Submission date',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'ApproveDate',
                              autoFitPadding: tablepadding,
                              allowEditing: false,
                              width: 130,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Approve date',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'ReleaseDate',
                              autoFitPadding: tablepadding,
                              allowEditing: false,
                              width: 140,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Release date',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Add',
                              autoFitPadding: tablepadding,
                              allowEditing: false,
                              width: 85,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Add row',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Delete',
                              autoFitPadding: tablepadding,
                              allowEditing: false,
                              width: 100,
                              label: Container(
                                padding: tablepadding,
                                alignment: Alignment.center,
                                child: Text('Delete row',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                          ]);
                    }
                  },
                ),
              )),
            ]),
      floatingActionButton: FloatingActionButton(
        onPressed: (() {
          globalIndexDetailedList.add(0);
          isShowPinIconInDetail.add(false);
          if (_selectedIndex == 0) {
            DetailedProjectev.add(DetailedEngModel(
              siNo: 1,
              title: 'EV Layout',
              number: null,
              preparationDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
              submissionDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
              approveDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
              releaseDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
            ));
            _detailedDataSource.buildDataGridRows();
            _detailedDataSource.updateDatagridSource();
          }
          if (_selectedIndex == 1) {
            DetailedProjectev.add(DetailedEngModel(
              siNo: 1,
              title: 'EV Layout',
              number: null,
              preparationDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
              submissionDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
              approveDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
              releaseDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
            ));
            _detailedEngSourceev.buildDataGridRowsEV();
            _detailedEngSourceev.updateDatagridSource();
          }
        }),
        child: const Icon(Icons.add),
      ),
    );
  }

  tabScreen2() {
    return Scaffold(
        body: _isloading
            ? LoadingPage()
            : Column(children: [
                Expanded(
                    child: SfDataGridTheme(
                  data: SfDataGridThemeData(
                      headerColor: white, gridLineColor: blue),
                  child: StreamBuilder(
                    stream: _stream2,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data.exists == false) {
                        return SfDataGrid(
                            source: _selectedIndex == 0
                                ? _detailedDataSource
                                : _detailedEngSourceShed,
                            allowEditing: true,
                            frozenColumnsCount: 2,
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            selectionMode: SelectionMode.single,
                            navigationMode: GridNavigationMode.cell,
                            columnWidthMode: ColumnWidthMode.auto,
                            rowHeight: 50,
                            headerRowHeight: 50,
                            editingGestureType: EditingGestureType.tap,
                            controller: _dataGridController,
                            onQueryRowHeight: (details) {
                              return details
                                  .getIntrinsicRowHeight(details.rowIndex);
                            },
                            columns: [
                              GridColumn(
                                visible: false,
                                columnName: 'SiNo',
                                autoFitPadding: tablepadding,
                                allowEditing: true,
                                width: 80,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Si.No.',
                                      overflow: TextOverflow.values.first,
                                      textAlign: TextAlign.center,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'button',
                                width: 120,
                                allowEditing: false,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Upload drawing ',
                                      textAlign: TextAlign.center,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ViewDrawing',
                                width: 100,
                                allowEditing: false,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('View drawing ',
                                      textAlign: TextAlign.center,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Title',
                                autoFitPadding: tablepadding,
                                allowEditing: true,
                                width: 300,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Description',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Number',
                                autoFitPadding: tablepadding,
                                allowEditing: true,
                                width: 130,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Drawing number',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'PreparationDate',
                                autoFitPadding: tablepadding,
                                allowEditing: false,
                                width: 130,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Preparation date',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'SubmissionDate',
                                autoFitPadding: tablepadding,
                                allowEditing: false,
                                width: 130,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Submission date',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ApproveDate',
                                autoFitPadding: tablepadding,
                                allowEditing: false,
                                width: 130,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Approve date',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ReleaseDate',
                                autoFitPadding: tablepadding,
                                allowEditing: false,
                                width: 140,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Release date',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Add',
                                autoFitPadding: tablepadding,
                                allowEditing: false,
                                width: 85,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Add row',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Delete',
                                autoFitPadding: tablepadding,
                                allowEditing: false,
                                width: 100,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Delete row',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                            ]);
                      } else {
                        alldata = '';
                        alldata = snapshot.data['data'] as List<dynamic>;
                        DetailedProjectshed.clear();
                        _detailedEngSourceShed.buildDataGridRowsShed();
                        _detailedEngSourceShed.updateDatagridSource();
                        alldata.forEach((element) {
                          DetailedProjectshed.add(
                              DetailedEngModel.fromjsaon(element));
                          _detailedEngSourceShed = DetailedEngSourceShed(
                              DetailedProjectshed,
                              context,
                              widget.cityName.toString(),
                              widget.depoName.toString(),
                              widget.userId!);
                          _dataGridController = DataGridController();
                        });

                        return SfDataGrid(
                            source: _selectedIndex == 0
                                ? _detailedDataSource
                                : _detailedEngSourceShed,
                            allowEditing: true,
                            frozenColumnsCount: 2,
                            gridLinesVisibility: GridLinesVisibility.both,
                            headerGridLinesVisibility: GridLinesVisibility.both,
                            selectionMode: SelectionMode.single,
                            navigationMode: GridNavigationMode.cell,
                            rowHeight: 50,
                            headerRowHeight: 50,
                            columnWidthMode: ColumnWidthMode.auto,
                            editingGestureType: EditingGestureType.tap,
                            controller: _dataGridController,
                            onQueryRowHeight: (details) {
                              return details
                                  .getIntrinsicRowHeight(details.rowIndex);
                            },
                            columns: [
                              GridColumn(
                                visible: false,
                                columnName: 'SiNo',
                                autoFitPadding: tablepadding,
                                allowEditing: true,
                                width: 80,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Si.No.',
                                      overflow: TextOverflow.values.first,
                                      textAlign: TextAlign.center,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'button',
                                width: 120,
                                allowEditing: false,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Upload drawing ',
                                      textAlign: TextAlign.center,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ViewDrawing',
                                width: 100,
                                allowEditing: false,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('View drawing ',
                                      textAlign: TextAlign.center,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Title',
                                autoFitPadding: tablepadding,
                                allowEditing: true,
                                width: 300,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Description',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Number',
                                autoFitPadding: tablepadding,
                                allowEditing: true,
                                width: 130,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Drawing number',
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'PreparationDate',
                                autoFitPadding: tablepadding,
                                allowEditing: false,
                                width: 130,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Preparation date',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'SubmissionDate',
                                autoFitPadding: tablepadding,
                                allowEditing: false,
                                width: 130,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Submission date',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ApproveDate',
                                autoFitPadding: tablepadding,
                                allowEditing: false,
                                width: 130,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Approve date',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'ReleaseDate',
                                autoFitPadding: tablepadding,
                                allowEditing: false,
                                width: 130,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Release date',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Add',
                                autoFitPadding: tablepadding,
                                allowEditing: false,
                                width: 85,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Add row',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                              GridColumn(
                                columnName: 'Delete',
                                autoFitPadding: tablepadding,
                                allowEditing: false,
                                width: 100,
                                label: Container(
                                  padding: tablepadding,
                                  alignment: Alignment.center,
                                  child: Text('Delete row',
                                      overflow: TextOverflow.values.first,
                                      style: tableheaderwhitecolor
                                      //    textAlign: TextAlign.center,
                                      ),
                                ),
                              ),
                            ]);
                      }
                    },
                  ),
                )),
              ]),
        floatingActionButton: FloatingActionButton(
          onPressed: (() {
            globalIndexDetailedList.add(0);
            isShowPinIconInDetail.add(false);
            DetailedProjectshed.add(DetailedEngModel(
              siNo: 1,
              title: 'Shed Lighting',
              number: null,
              preparationDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
              submissionDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
              approveDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
              releaseDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
            ));
            _detailedEngSourceShed.buildDataGridRowsShed();
            _detailedEngSourceShed.updateDatagridSource();
          }),
          child: const Icon(Icons.add),
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

  void _showDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        content: SizedBox(
          height: 50,
          width: 50,
          child: Center(
            child: CircularProgressIndicator(
              color: blue,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> checkAvailableImage() async {
    List<dynamic> tempGlobalList = [];
    List<bool> tempIsShowPinDetail = [];

    int loopLen = 0;

    List<String> storageTitles = [
      'DetailedEngRFC',
      'DetailedEngEV',
      'DetailedEngShed'
    ];

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('DetailEngineering')
        .doc(widget.depoName)
        .collection(tabNames[_selectedIndex])
        .doc(widget.userId)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      List<dynamic> mapDataList = data['data'];

      loopLen = mapDataList.length;

      for (int i = 0; i < loopLen; i++) {
        String drawingNumber = '${mapDataList[i]['Number']}';

        final storage = FirebaseStorage.instance;
        final path =
            '${storageTitles[_selectedIndex]}/${widget.cityName}/${widget.depoName}/${widget.userId}/$drawingNumber/${i + 1}';

        ListResult result = await storage.ref().child(path).listAll();
        if (result.items.isNotEmpty) {
          tempIsShowPinDetail.add(true);
        } else {
          tempIsShowPinDetail.add(false);
        }
        tempGlobalList.add(result.items.length);
      }
      globalIndexDetailedList = tempGlobalList;
      isShowPinIconInDetail = tempIsShowPinDetail;

      print(' global index list : ${globalIndexDetailedList}');
    }

    // for (int i = 0; i < listLen.length; i++) {
    //   final storage = FirebaseStorage.instance
    //       .ref()
    //       .child('${storageTitles[_selectedIndex]}/');
    // }
  }
}
