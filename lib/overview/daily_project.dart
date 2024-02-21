import 'package:assingment/FirebaseApi/firebase_api.dart';
import 'package:assingment/Planning_Pages/civil_quality_checklist.dart';
import 'package:assingment/datasource/dailyproject_datasource.dart';
import 'package:assingment/widget/appbar_back_date.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../Authentication/auth_service.dart';
import '../Planning_Pages/summary.dart';
import '../components/loading_page.dart';
import '../model/daily_projectModel.dart';
import '../widget/style.dart';

List<bool> isShowPinIcon = [];
List<int> globalItemLengthList = [];

String? selectedDate = DateFormat.yMMMMd().format(DateTime.now());

class DailyProject extends StatefulWidget {
  String? cityName;
  String? depoName;

  DailyProject({super.key, required this.cityName, required this.depoName});

  @override
  State<DailyProject> createState() => _DailyProjectState();
}

class _DailyProjectState extends State<DailyProject> {
  bool isImagesAvailable = false;
  List<DailyProjectModel> dailyproject = <DailyProjectModel>[];
  late DailyDataSource _dailyDataSource;
  late DataGridController _dataGridController;
  List<dynamic> tabledata2 = [];
  Stream? _stream;
  var alldata;
  dynamic userId;
  bool _isloading = true;
  String pagetitle = 'Daily Report';

  @override
  void initState() {
    selectedDate = DateFormat.yMMMMd().format(DateTime.now());

    getUserId().whenComplete(() async {
      await checkIsImageAvail();
      getmonthlyReport();
      // dailyproject = getmonthlyReport();
      _dailyDataSource = DailyDataSource(dailyproject, context,
          widget.cityName!, widget.depoName!, selectedDate!, userId);
      _dataGridController = DataGridController();

      _isloading = false;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dailyproject.clear();
    _stream = FirebaseFirestore.instance
        .collection('DailyProject3')
        .doc('${widget.depoName}')
        .collection(selectedDate.toString())
        .doc(userId)
        .snapshots();

    return Scaffold(
      appBar: PreferredSize(
        // ignore: sort_child_properties_last
        child: CustomAppBarBackDate(
            toDaily: true,
            cityName: widget.cityName,
            text: 'Daily Report',
            depoName: widget.depoName,
            //  ${DateFormat.yMMMMd().format(DateTime.now())}',
            haveSynced: true,
            haveSummary: true,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewSummary(
                    cityName: widget.cityName.toString(),
                    depoName: widget.depoName.toString(),
                    id: 'Daily Report',
                    userId: userId,
                  ),
                )),
            store: () {
              _showDialog(context);
              // FirebaseApi().nestedKeyEventsField(
              //     'DailyProject3', widget.depoName!, 'userId', userId);
              storeData();
            },
            choosedate: () {
              chooseDate(context);
            }),
        preferredSize: const Size.fromHeight(
          50,
        ),
      ),
      body: _isloading
          ? LoadingPage()
          : Column(children: [
              Expanded(
                  child: StreamBuilder(
                stream: _stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingPage();
                  } else if (!snapshot.hasData ||
                      snapshot.data.exists == false) {
                    // dailyproject = getmonthlyReport();

                    _dailyDataSource = DailyDataSource(
                      dailyproject,
                      context,
                      widget.cityName!,
                      widget.depoName!,
                      selectedDate!,
                      userId,
                    );

                    _dataGridController = DataGridController();

                    return SfDataGridTheme(
                      data: SfDataGridThemeData(
                          headerColor: white, gridLineColor: blue),
                      child: SfDataGrid(
                          source: _dailyDataSource,
                          allowEditing: true,
                          frozenColumnsCount: 2,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          selectionMode: SelectionMode.single,
                          navigationMode: GridNavigationMode.cell,
                          columnWidthMode: ColumnWidthMode.fitByCellValue,
                          editingGestureType: EditingGestureType.tap,
                          rowHeight: 50,
                          controller: _dataGridController,
                          onQueryRowHeight: (details) {
                            return details
                                .getIntrinsicRowHeight(details.rowIndex);
                          },
                          columns: [
                            GridColumn(
                              columnName: 'Date',
                              visible: false,
                              allowEditing: true,
                              width: 150,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Date',
                                    overflow: TextOverflow.values.first,
                                    textAlign: TextAlign.center,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'SiNo',
                              visible: false,
                              allowEditing: true,
                              width: 70,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Si.no.',
                                    overflow: TextOverflow.values.first,
                                    textAlign: TextAlign.center,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'TypeOfActivity',
                              allowEditing: true,
                              width: 200,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Type of activity',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'ActivityDetails',
                              allowEditing: true,
                              width: 220,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Activity details',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Progress',
                              allowEditing: true,
                              columnWidthMode: ColumnWidthMode.fill,
                              width: 300,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Progress',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Status',
                              allowEditing: true,
                              width: 280,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Remark / Status',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'upload',
                              allowEditing: false,
                              width: 130,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Upload image',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'view',
                              allowEditing: false,
                              width: 120,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('View image',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Add',
                              allowEditing: false,
                              width: 100,
                              label: Container(
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
                              allowEditing: false,
                              width: 120,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Delete row',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                          ]),
                    );
                  } else {
                    alldata = '';
                    alldata = snapshot.data['data'] as List<dynamic>;
                    int listLen = snapshot.data['data'].length;
                    if (isImagesAvailable == false) {
                      isShowPinIcon.clear();
                      globalItemLengthList.clear();
                      for (int i = 0; i < listLen; i++) {
                        isShowPinIcon.add(false);
                        globalItemLengthList.add(0);
                      }
                      print('isShow - $isShowPinIcon');
                      print('globalList - $globalItemLengthList');
                    }

                    dailyproject.clear();
                    _dailyDataSource.buildDataGridRows();
                    _dailyDataSource.updateDatagridSource();
                    alldata.forEach((element) {
                      dailyproject.add(DailyProjectModel.fromjson(element));
                      _dailyDataSource = DailyDataSource(
                        dailyproject,
                        context,
                        widget.cityName!,
                        widget.depoName!,
                        selectedDate!,
                        userId,
                      );
                      _dataGridController = DataGridController();
                      _dailyDataSource.buildDataGridRows();
                      _dailyDataSource.updateDatagridSource();
                    });

                    return SfDataGridTheme(
                      data: SfDataGridThemeData(
                          headerColor: white, gridLineColor: blue),
                      child: SfDataGrid(
                          source: _dailyDataSource,
                          allowEditing: true,
                          frozenColumnsCount: 2,
                          gridLinesVisibility: GridLinesVisibility.both,
                          headerGridLinesVisibility: GridLinesVisibility.both,
                          selectionMode: SelectionMode.single,
                          navigationMode: GridNavigationMode.cell,
                          editingGestureType: EditingGestureType.tap,
                          rowHeight: 50,
                          controller: _dataGridController,
                          onQueryRowHeight: (details) {
                            return details
                                .getIntrinsicRowHeight(details.rowIndex);
                          },
                          columns: [
                            GridColumn(
                              columnName: 'Date',
                              visible: false,
                              allowEditing: true,
                              width: 70,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Date',
                                    overflow: TextOverflow.values.first,
                                    textAlign: TextAlign.center,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'SiNo',
                              visible: false,
                              allowEditing: true,
                              width: 70,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Si.no.',
                                    overflow: TextOverflow.values.first,
                                    textAlign: TextAlign.center,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'TypeOfActivity',
                              allowEditing: true,
                              width: 200,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Type of activity',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'ActivityDetails',
                              allowEditing: true,
                              width: 220,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Activity details',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Progress',
                              allowEditing: true,
                              width: 300,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Progress',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Status',
                              allowEditing: true,
                              width: 280,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Remark / Status',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'upload',
                              allowEditing: false,
                              width: 150,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Upload image',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'view',
                              allowEditing: false,
                              width: 110,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('view image',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Add',
                              allowEditing: false,
                              width: 100,
                              label: Container(
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
                              allowEditing: false,
                              width: 120,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Delete row',
                                    overflow: TextOverflow.values.first,
                                    style: tableheaderwhitecolor
                                    //    textAlign: TextAlign.center,
                                    ),
                              ),
                            ),
                          ]),
                    );
                  }
                },
              ))
            ]),
      floatingActionButton: FloatingActionButton(
          onPressed: (() {
            globalItemLengthList.add(0);
            isShowPinIcon.add(false);
            dailyproject.add(DailyProjectModel(
                siNo: 1,
                // date: DateFormat().add_yMd(storeData()).format(DateTime.now()),
                // state: "Maharashtra",
                // depotName: 'depotName',
                typeOfActivity: '',
                activityDetails: "",
                progress: '',
                status: ''));
            _dailyDataSource.buildDataGridRows();
            _dailyDataSource.updateDatagridSource();
          }),
          child: const Icon(Icons.add)),
    );
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
  }

  void storeData() {
    Map<String, dynamic> tableData = Map();
    for (var i in _dailyDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' && data.columnName != 'Delete') {
          tableData[data.columnName] = data.value;
          tableData.addAll({"Date": selectedDate});
        }
      }

      tabledata2.add(tableData);
      tableData = {};
    }

    FirebaseFirestore.instance
        .collection('DailyProject3')
        .doc('${widget.depoName}')
        .collection(selectedDate.toString())
        .doc(userId)
        // .doc(DateFormat.yMMMMd().format(DateTime.now()))
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

  List<DailyProjectModel> getmonthlyReport() {
    return [
      DailyProjectModel(
          siNo: 1,
          // date: DateFormat().add_yMd().format(DateTime.now()),
          // state: "Maharashtra",
          // depotName: 'depotName',
          typeOfActivity: '',
          activityDetails: '',
          progress: '',
          status: '')
    ];
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

  void chooseDate(BuildContext context) {
    isImagesAvailable = false;
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

  Future<void> checkIsImageAvail() async {
    isImagesAvailable = false;
    isShowPinIcon.clear();
    globalItemLengthList.clear();
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('DailyProject3')
        .doc(widget.depoName)
        .collection(selectedDate.toString())
        .doc(userId)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> mapData =
          documentSnapshot.data() as Map<String, dynamic>;
      List<dynamic> data = mapData['data'];

      final storage = FirebaseStorage.instance;

      for (int i = 0; i < data.length; i++) {
        ListResult listResult = await storage
            .ref()
            .child(
                '/Daily Report/${widget.cityName}/${widget.depoName}/$userId/${selectedDate.toString()}/${i + 1}')
            .listAll();

        if (listResult.items.isNotEmpty) {
          isImagesAvailable = true;
          globalItemLengthList.add(listResult.items.length);
          isShowPinIcon.add(true);
        } else {
          globalItemLengthList.add(0);
          isShowPinIcon.add(false);
        }
      }
      print('isShowPinIcon - $isShowPinIcon');
    }
  }
}
