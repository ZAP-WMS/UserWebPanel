import 'package:assingment/FirebaseApi/firebase_api.dart';
import 'package:assingment/datasource/monthlyproject_datasource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../Authentication/auth_service.dart';
import '../Planning_Pages/summary.dart';
import '../components/loading_page.dart';
import '../model/monthly_projectModel.dart';
import '../widget/custom_appbar.dart';
import '../widget/style.dart';

class MonthlyProject extends StatefulWidget {
  String? cityName;
  String? depoName;

  MonthlyProject({super.key, required this.cityName, required this.depoName});

  @override
  State<MonthlyProject> createState() => _MonthlyProjectState();
}

class _MonthlyProjectState extends State<MonthlyProject> {
  List<MonthlyProjectModel> monthlyProject = <MonthlyProjectModel>[];
  late MonthlyDataSource monthlyDataSource;
  late DataGridController _dataGridController;
  List<dynamic> tabledata2 = [];
  Stream? _stream;
  dynamic alldata;
  bool _isloading = true;
  String title = 'Monthly Project';
  dynamic userId;

  @override
  void initState() {
    getUserId().whenComplete(() {
      _stream = FirebaseFirestore.instance
          .collection('MonthlyProjectReport2')
          .doc('${widget.depoName}')
          // .collection('AllMonthData')
          .collection('userId')
          .doc(userId)
          .collection('Monthly Data')
          // .collection('MonthData')
          .doc(DateFormat.yMMM().format(DateTime.now()))
          .snapshots();
      _isloading = false;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          // ignore: sort_child_properties_last
          child: CustomAppBar(
            depotName: widget.depoName,
            showDepoBar: true,
            toMonthly: true,
            cityname: widget.cityName,
            text:
                ' ${widget.cityName}/ ${widget.depoName} / Monthly Report / ${DateFormat('MMMM').format(DateTime.now())}',
            haveSummary: true,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewSummary(
                    cityName: widget.cityName.toString(),
                    depoName: widget.depoName.toString(),
                    id: 'Monthly Report',
                    userId: userId,
                  ),
                )),
            haveSynced: true,
            store: () {
              // _showDialog(context);
              // FirebaseApi().defaultKeyEventsField(
              //     'MonthlyProjectReport', widget.depoName!);
              FirebaseApi().nestedKeyEventsField(
                  'MonthlyProjectReport2', widget.depoName!, 'userId', userId);
              storeData();
            },
          ),
          preferredSize: const Size.fromHeight(50)),
      body: _isloading
          ? LoadingPage()
          : StreamBuilder(
              stream: _stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingPage();
                } else if (!snapshot.hasData || snapshot.data.exists == false) {
                  monthlyProject = getmonthlyReport();
                  monthlyDataSource =
                      MonthlyDataSource(monthlyProject, context);
                  _dataGridController = DataGridController();

                  return Column(
                    children: [
                      Expanded(
                          flex: 1,
                          child: SfDataGridTheme(
                            data: SfDataGridThemeData(
                                headerColor: white, gridLineColor: blue),
                            child: SfDataGrid(
                                source: monthlyDataSource,
                                allowEditing: true,
                                frozenColumnsCount: 2,
                                gridLinesVisibility: GridLinesVisibility.both,
                                headerGridLinesVisibility:
                                    GridLinesVisibility.both,
                                selectionMode: SelectionMode.single,
                                navigationMode: GridNavigationMode.cell,
                                headerRowHeight: 50,
                                rowHeight: 50,
                                columnWidthMode: ColumnWidthMode.fill,
                                editingGestureType: EditingGestureType.tap,
                                controller: _dataGridController,
                                onQueryRowHeight: (details) {
                                  return details
                                      .getIntrinsicRowHeight(details.rowIndex);
                                },
                                columns: [
                                  GridColumn(
                                    columnName: 'ActivityNo',
                                    allowEditing: false,
                                    width: 160,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                          'Activities SI. No as per Gant Chart',
                                          overflow: TextOverflow.values.first,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: blue)
                                          //    textAlign: TextAlign.center,
                                          ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'ActivityDetails',
                                    allowEditing: false,
                                    width: 240,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Activities Details',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: blue)),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Progress',
                                    allowEditing: true,
                                    width: 250,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Progress',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: blue)
                                          //    textAlign: TextAlign.center,
                                          ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Status',
                                    allowEditing: true,
                                    width: 250,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Remark/Status',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: blue)
                                          //    textAlign: TextAlign.center,
                                          ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Action',
                                    allowEditing: true,
                                    width: 250,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Next Month Action Plan',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: blue)
                                          //    textAlign: TextAlign.center,
                                          ),
                                    ),
                                  ),
                                ]),
                          )),
                    ],
                  );
                } else {
                  alldata = snapshot.data['data'] as List<dynamic>;
                  monthlyProject.clear();
                  alldata.forEach((element) {
                    monthlyProject.add(MonthlyProjectModel.fromjson(element));
                    monthlyDataSource =
                        MonthlyDataSource(monthlyProject, context);
                    _dataGridController = DataGridController();
                  });
                  return Column(
                    children: [
                      Expanded(
                          flex: 1,
                          child: SfDataGridTheme(
                            data: SfDataGridThemeData(headerColor: blue),
                            child: SfDataGrid(
                                source: monthlyDataSource,
                                allowEditing: true,
                                frozenColumnsCount: 2,
                                gridLinesVisibility: GridLinesVisibility.both,
                                headerGridLinesVisibility:
                                    GridLinesVisibility.both,
                                selectionMode: SelectionMode.single,
                                navigationMode: GridNavigationMode.cell,
                                headerRowHeight: 50,
                                rowHeight: 50,
                                columnWidthMode: ColumnWidthMode.auto,
                                editingGestureType: EditingGestureType.tap,
                                controller: _dataGridController,
                                onQueryRowHeight: (details) {
                                  return details
                                      .getIntrinsicRowHeight(details.rowIndex);
                                },
                                columns: [
                                  GridColumn(
                                    columnName: 'ActivityNo',
                                    allowEditing: false,
                                    width: 160,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                          'Activities SI. No as per Gant Chart',
                                          overflow: TextOverflow.values.first,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: blue)
                                          //    textAlign: TextAlign.center,
                                          ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'ActivityDetails',
                                    allowEditing: false,
                                    width: 240,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Activities Details',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: blue)),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Progress',
                                    allowEditing: true,
                                    width: 250,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Progress',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: blue)
                                          //    textAlign: TextAlign.center,
                                          ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Status',
                                    allowEditing: true,
                                    width: 250,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Remark/Status',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: blue)
                                          //    textAlign: TextAlign.center,
                                          ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Action',
                                    allowEditing: true,
                                    width: 250,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Next Month Action Plan',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: blue)
                                          //    textAlign: TextAlign.center,
                                          ),
                                    ),
                                  ),
                                ]),
                          )),
                    ],
                  );
                }
              }),
    );
  }

  void storeData() {
    Map<String, dynamic> table_data = Map();
    for (var i in monthlyDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button') {
          table_data[data.columnName] = data.value;
        }
        table_data['User ID'] = userId;
      }

      tabledata2.add(table_data);
      table_data = {};
    }

    FirebaseFirestore.instance
        .collection('MonthlyProjectReport2')
        .doc('${widget.depoName}')
        // .collection('AllMonthData')
        .collection('userId')
        .doc(userId)
        .collection('Monthly Data')
        // .collection('MonthData')
        .doc(DateFormat.yMMM().format(DateTime.now()))
        .set({
      'data': tabledata2,
    }).whenComplete(() {
      tabledata2.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
  }

  List<MonthlyProjectModel> getmonthlyReport() {
    return [
      MonthlyProjectModel(
          activityNo: 'A1',
          activityDetails: 'Letter of Award From TML',
          // months: 'Jan',
          // duration: 1,
          // startDate: DateFormat().add_yMd().format(DateTime.now()),
          // endDate: DateFormat().add_yMd().format(DateTime.now()),
          progress: '',
          status: '',
          action: ''),
      MonthlyProjectModel(
          activityNo: 'A2',
          activityDetails:
              'Site Survey, Job scope finalization  and Proposed layout submission',
          // months: 'Jan',
          // duration: 1,
          // startDate: DateFormat().add_yMd().format(DateTime.now()),
          // endDate: DateFormat().add_yMd().format(DateTime.now()),
          progress: '',
          status: '',
          action: ''),
      MonthlyProjectModel(
          activityNo: 'A3',
          activityDetails:
              'Detailed Engineering for Approval of  Civil & Electrical  Layout, GA Drawing from TML',
          // months: 'Jan',
          // duration: 1,
          // startDate: DateFormat().add_yMd().format(DateTime.now()),
          // endDate: DateFormat().add_yMd().format(DateTime.now()),
          progress: '',
          status: '',
          action: ''),
      MonthlyProjectModel(
          activityNo: 'A4',
          activityDetails: 'Site Mobalization activity Completed',
          // months: 'Jan',
          // duration: 1,
          // startDate: DateFormat().add_yMd().format(DateTime.now()),
          // endDate: DateFormat().add_yMd().format(DateTime.now()),
          progress: '',
          status: '',
          action: ''),
      MonthlyProjectModel(
          activityNo: 'A5',
          activityDetails: 'Approval of statutory clearances of BUS Depot',
          // months: 'Jan',
          // duration: 1,
          // startDate: DateFormat().add_yMd().format(DateTime.now()),
          // endDate: DateFormat().add_yMd().format(DateTime.now()),
          progress: '',
          status: '',
          action: ''),
      MonthlyProjectModel(
          activityNo: 'A6',
          activityDetails: 'Procurement of Order Finalisation Completed',
          // months: 'Jan',
          // duration: 1,
          // startDate: DateFormat().add_yMd().format(DateTime.now()),
          // endDate: DateFormat().add_yMd().format(DateTime.now()),
          progress: '',
          status: '',
          action: ''),
      MonthlyProjectModel(
          activityNo: 'A7',
          activityDetails: 'Receipt of all Materials at Site',
          // months: 'Jan',
          // duration: 1,
          // startDate: DateFormat().add_yMd().format(DateTime.now()),
          // endDate: DateFormat().add_yMd().format(DateTime.now()),
          progress: '',
          status: '',
          action: ''),
      MonthlyProjectModel(
          activityNo: 'A8',
          activityDetails: 'Civil Infra Development completed at Bus Depot',
          // months: 'Jan',
          // duration: 1,
          // startDate: DateFormat().add_yMd().format(DateTime.now()),
          // endDate: DateFormat().add_yMd().format(DateTime.now()),
          progress: '',
          status: '',
          action: ''),
      MonthlyProjectModel(
          activityNo: 'A9',
          activityDetails:
              'Electrical Infra Development completed at Bus Depot',
          // months: 'Jan',
          // duration: 1,
          // startDate: DateFormat().add_yMd().format(DateTime.now()),
          // endDate: DateFormat().add_yMd().format(DateTime.now()),
          progress: '',
          status: '',
          action: ''),
      MonthlyProjectModel(
          activityNo: 'A10',
          activityDetails: 'Bus Depot work Completed & Handover to TML',
          // months: 'Jan',
          // duration: 1,
          // startDate: DateFormat().add_yMd().format(DateTime.now()),
          // endDate: DateFormat().add_yMd().format(DateTime.now()),
          progress: '',
          status: '',
          action: ''),
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
}
