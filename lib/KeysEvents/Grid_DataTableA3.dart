import 'package:assingment/Planning_Pages/quality_checklist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gantt_chart/gantt_chart.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../Authentication/auth_service.dart';
import '../FirebaseApi/firebase_api.dart';
import '../components/loading_page.dart';
import '../datasource/employee_datasource.dart';
import '../model/employee.dart';
import '../overview/key_events.dart';
import '../widget/custom_appbar.dart';
import '../widget/keyboard_listener.dart';
import '../widget/style.dart';

/// The application that contains datagrid on it.

/// The home page of the application which hosts the datagrid.
class StatutoryAprovalA3 extends StatefulWidget {
  /// Creates the home page.
  String? userid;
  String? depoName;
  String? cityName;
  StatutoryAprovalA3(
      {Key? key, required this.userid, this.depoName, this.cityName})
      : super(key: key);

  @override
  _StatutoryAprovalA3State createState() => _StatutoryAprovalA3State();
}

class _StatutoryAprovalA3State extends State<StatutoryAprovalA3> {
  late EmployeeDataSource _employeeDataSource;
  List<Employee> _employees = <Employee>[];
  late DataGridController _dataGridController;
  //  List<DataGridRow> dataGridRows = [];
  DataGridRow? dataGridRow;
  RowColumnIndex? rowColumnIndex;
  GridColumn? column;
  List<dynamic> tabledata2 = [];
  bool _isLoading = false;
  bool _isInit = true;
  List<double> weight = [];
  List<int> yAxis = [];
  List<ChartData> chartData = [];
  Stream? _stream;
  var alldata;
  bool specificUser = true;
  QuerySnapshot? snap;
  dynamic companyId;
  List<String> startDate = [];
  List<String> endDate = [];
  List<String> actualstart = [];
  List<String> actualend = [];
  List<int> srNo = [];
  List<GanttEventBase> ganttdata = [];
  final scrollController = ScrollController();

  @override
  void initState() {
    getUserId();
    identifyUser();
    _stream = FirebaseFirestore.instance
        .collection('KeyEventsTable')
        .doc(widget.depoName!)
        .collection('KeyDataTable')
        .doc(widget.userid)
        .collection('KeyAllEvents')
        .doc('${widget.depoName}A3')
        .snapshots();
    super.initState();
  }
  // @override
  // void didChangeDependencies() {
  //   if (_isInit) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //     getFirestoreData().whenComplete(() {
  //       setState(() {
  //         if (_employees.length == 0 || _employees.isEmpty) {
  //           _employees = getEmployeeData();
  //         }
  //         _isLoading = false;
  //         _employeeDataSource = EmployeeDataSource(_employees, context);
  //         _dataGridController = DataGridController();
  //       });
  //       // _employeeDataSource = EmployeeDataSource(_employees);
  //       // _dataGridController = DataGridController();
  //     });
  //     //getFirestoreData() as List<Employee>;
  //     // getEmployeeData();

  //   }
  //   _isInit = false;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return keyBoardArrow(
      scrollController: scrollController,
      myScaffold: Scaffold(
        appBar: PreferredSize(
          // ignore: sort_child_properties_last
          child: CustomAppBar(
            text: 'Key Events / ${widget.depoName!} /A3',
            haveSynced: specificUser ? true : false,
            store: () {
              FirebaseApi()
                  .defaultKeyEventsField('KeyEventsTable', widget.depoName!);
              FirebaseApi().nestedKeyEventsField(
                'KeyEventsTable',
                widget.depoName!,
                'KeyDataTable',
                widget.userid!,
              );
              StoreData();
            },
          ),
          preferredSize: Size.fromHeight(50),
        ),
        body: _isLoading
            ? LoadingPage()
            : StreamBuilder(
                stream: _stream,
                builder: (context, snapshot) {
                  ganttdata = [];
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingPage();
                  }
                  if (!snapshot.hasData || snapshot.data.exists == false) {
                    _employees = getEmployeeData();
                    _employeeDataSource = EmployeeDataSource(
                        _employees,
                        context,
                        widget.userid!,
                        widget.cityName,
                        widget.depoName);
                    _dataGridController = DataGridController();

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: _employees.length * 66,
                            child: Row(
                              children: [
                                Expanded(
                                  child: SfDataGrid(
                                    source: _employeeDataSource,
                                    allowEditing: true,
                                    frozenColumnsCount: 2,
                                    gridLinesVisibility:
                                        GridLinesVisibility.both,
                                    headerGridLinesVisibility:
                                        GridLinesVisibility.both,
                                    selectionMode: SelectionMode.single,
                                    navigationMode: GridNavigationMode.cell,
                                    columnWidthMode: ColumnWidthMode.auto,
                                    editingGestureType: EditingGestureType.tap,
                                    controller: _dataGridController,
                                    // onQueryRowHeight: (details) {
                                    //   return details.rowIndex == 0 ? 60.0 : 49.0;
                                    // },
                                    columns: [
                                      GridColumn(
                                        columnName: 'srNo',
                                        autoFitPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10),
                                        allowEditing: true,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Sr No',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.values.first,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                            //    textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Activity',
                                        width: 220,
                                        allowEditing: true,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Activity',
                                            overflow: TextOverflow.values.first,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      // GridColumn(
                                      //   columnName: 'viewbutton',
                                      //   width: 130,
                                      //   allowEditing: false,
                                      //   label: Container(
                                      //     padding: const EdgeInsets.all(8.0),
                                      //     alignment: Alignment.center,
                                      //     child: const Text('View File ',
                                      //         style: TextStyle(
                                      //             fontWeight: FontWeight.bold,
                                      //             fontSize: 16)),
                                      //   ),
                                      // ),
                                      // GridColumn(
                                      //   columnName: 'uploadbutton',
                                      //   width: 130,
                                      //   allowEditing: false,
                                      //   label: Container(
                                      //     padding: const EdgeInsets.all(8.0),
                                      //     alignment: Alignment.center,
                                      //     child: const Text('View File ',
                                      //         style: TextStyle(
                                      //             fontWeight: FontWeight.bold,
                                      //             fontSize: 16)),
                                      //   ),
                                      // ),
                                      GridColumn(
                                        columnName: 'OriginalDuration',
                                        allowEditing: true,
                                        width: 100,
                                        autoFitPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10),
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text('Original Duration',
                                              overflow:
                                                  TextOverflow.values.first,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'StartDate',
                                        allowEditing: false,
                                        //   width: 180,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text('Start Date',
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'EndDate',
                                        allowEditing: false,
                                        //   width: 180,
                                        label: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          alignment: Alignment.center,
                                          child: Text('End Date',
                                              textAlign: TextAlign.center,
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'ActualStart',
                                        allowEditing: false,
                                        width: 160,
                                        label: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          alignment: Alignment.center,
                                          child: Text('Actual Start',
                                              textAlign: TextAlign.center,
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'ActualEnd',
                                        allowEditing: false,
                                        width: 140,
                                        label: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          alignment: Alignment.center,
                                          child: Text('Actual End',
                                              textAlign: TextAlign.center,
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'ActualDuration',
                                        width: 100,
                                        allowEditing: true,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text('Actual Duration',
                                              textAlign: TextAlign.center,
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Delay',
                                        allowEditing: true,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text('Delay',
                                              textAlign: TextAlign.center,
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'ReasonDelay',
                                        allowEditing: true,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text('Reason For Delay',
                                              textAlign: TextAlign.center,
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Unit',
                                        allowEditing: true,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text('Unit',
                                              textAlign: TextAlign.center,
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'QtyScope',
                                        allowEditing: true,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text('Oty as per scope',
                                              textAlign: TextAlign.center,
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'QtyExecuted',
                                        allowEditing: true,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text('Qty executed',
                                              textAlign: TextAlign.center,
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'BalancedQty',
                                        allowEditing: false,
                                        label: Container(
                                          width: 150,
                                          alignment: Alignment.center,
                                          child: Text('Balanced Qty',
                                              textAlign: TextAlign.center,
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Progress',
                                        allowEditing: false,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text('% of Progress',
                                              textAlign: TextAlign.center,
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Weightage',
                                        allowEditing: true,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text('Weightage',
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    width: 450,
                                    child: GanttChartView(
                                        scrollController: scrollController,
                                        scrollPhysics:
                                            const BouncingScrollPhysics(),
                                        maxDuration: null,
                                        // const Duration(days: 30 * 2),
                                        // optional, set to null for infinite horizontal scroll
                                        startDate:
                                            DateTime(2023, 8, 1), //required
                                        dayWidth:
                                            40, //column width for each day
                                        dayHeaderHeight: 35,
                                        eventHeight: 45, //row height for events

                                        stickyAreaWidth: 80, //sticky area width
                                        showStickyArea:
                                            true, //show sticky area or not
                                        showDays: true, //show days or not
                                        startOfTheWeek: WeekDay
                                            .monday, //custom start of the week
                                        weekHeaderHeight: 30,
                                        weekEnds: const {
                                          // WeekDay.saturday,
                                          // WeekDay.sunday
                                        }, //custom weekends
                                        isExtraHoliday: (context, day) {
                                          //define custom holiday logic for each day
                                          return DateUtils.isSameDay(
                                              DateTime(2023, 7, 1), day);
                                        },
                                        events: ganttdata))
                              ],
                            ),
                          ),
                          // const SizedBox(
                          //   height: 5,
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(10.0),
                          //   child: ElevatedButton(
                          //       style:
                          //           ElevatedButton.styleFrom(backgroundColor: blue),
                          //       onPressed: () async {
                          //         showCupertinoDialog(
                          //           context: context,
                          //           builder: (context) =>
                          //               const CupertinoAlertDialog(
                          //             content: SizedBox(
                          //               height: 50,
                          //               width: 50,
                          //               child: Center(
                          //                 child: CircularProgressIndicator(
                          //                   color: Colors.white,
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //         );
                          //         StoreData();
                          //       },
                          //       child: const Text(
                          //         'Sync Data',
                          //         textAlign: TextAlign.center,
                          //         style: TextStyle(
                          //           fontSize: 15,
                          //         ),
                          //       )),
                          // ),
                        ],
                      ),
                    );
                  } else {
                    alldata = snapshot.data['data'] as List<dynamic>;
                    _employees.clear();
                    weight.clear();
                    startDate.clear();
                    endDate.clear();
                    actualstart.clear();
                    actualend.clear();
                    yAxis.clear();
                    alldata.forEach((element) {
                      _employees.add(Employee.fromJson(element));
                      _employeeDataSource = EmployeeDataSource(
                          _employees,
                          context,
                          widget.userid!,
                          widget.cityName,
                          widget.depoName);
                      _dataGridController = DataGridController();
                    });
                    for (int i = 0; i < alldata.length; i++) {
                      var weightdata = alldata[i]['Weightage'];
                      var yaxisdata = alldata[i]['srNo'];

                      var start = alldata[i]['StartDate'];
                      var end = alldata[i]['EndDate'];
                      var actualStart = alldata[i]['ActualStart'];
                      var actualEnd = alldata[i]['ActualEnd'];
                      weight.add(weightdata);
                      yAxis.add(yaxisdata);
                      startDate.add(start);
                      endDate.add(end);
                      actualstart.add(actualStart);
                      actualend.add(actualEnd);
                    }
                    for (int i = 0; i <= weight.length - 1; i++) {
                      ganttdata.add(GanttAbsoluteEvent(
                        displayNameBuilder: (context) {
                          return yAxis[i].toString();
                        },
                        startDate: DateFormat('dd-MM-yyyy').parse(startDate[i]),
                        endDate: DateFormat('dd-MM-yyyy').parse(endDate[i]),
                        //displayName: yAxis[i].toString()
                      ));

                      ganttdata.add(GanttAbsoluteEvent(
                        displayNameBuilder: (context) {
                          return '';
                        },
                        startDate:
                            DateFormat('dd-MM-yyyy').parse(actualstart[i]),
                        endDate: DateFormat('dd-MM-yyyy').parse(actualend[i]),
                      ));
                    }

                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: _employees.length * 66,
                            child: Row(
                              children: [
                                Expanded(
                                  child: SfDataGrid(
                                    source: _employeeDataSource,
                                    allowEditing: true,
                                    frozenColumnsCount: 2,
                                    gridLinesVisibility:
                                        GridLinesVisibility.both,
                                    headerGridLinesVisibility:
                                        GridLinesVisibility.both,
                                    selectionMode: SelectionMode.single,
                                    navigationMode: GridNavigationMode.cell,
                                    columnWidthMode: ColumnWidthMode.auto,
                                    editingGestureType: EditingGestureType.tap,
                                    controller: _dataGridController,
                                    // onQueryRowHeight: (details) {
                                    //   return details.rowIndex == 0 ? 60.0 : 49.0;
                                    // },
                                    columns: [
                                      GridColumn(
                                        columnName: 'srNo',
                                        autoFitPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10),
                                        allowEditing: true,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Sr No',
                                            textAlign: TextAlign.center,
                                            overflow: TextOverflow.values.first,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                            //    textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Activity',
                                        width: 220,
                                        allowEditing: true,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Activity',
                                            overflow: TextOverflow.values.first,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      // GridColumn(
                                      //   columnName: 'viewbutton',
                                      //   width: 130,
                                      //   allowEditing: false,
                                      //   label: Container(
                                      //     padding: const EdgeInsets.all(8.0),
                                      //     alignment: Alignment.center,
                                      //     child: const Text('View File ',
                                      //         style: TextStyle(
                                      //             fontWeight: FontWeight.bold,
                                      //             fontSize: 16)),
                                      //   ),
                                      // ),
                                      // GridColumn(
                                      //   columnName: 'uploadbutton',
                                      //   width: 130,
                                      //   allowEditing: false,
                                      //   label: Container(
                                      //     padding: const EdgeInsets.all(8.0),
                                      //     alignment: Alignment.center,
                                      //     child: const Text('View File ',
                                      //         style: TextStyle(
                                      //             fontWeight: FontWeight.bold,
                                      //             fontSize: 16)),
                                      //   ),
                                      // ),
                                      GridColumn(
                                        columnName: 'OriginalDuration',
                                        allowEditing: true,
                                        width: 100,
                                        autoFitPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 10),
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text('Original Duration',
                                              overflow:
                                                  TextOverflow.values.first,
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'StartDate',
                                        allowEditing: false,
                                        //   width: 180,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text('Start Date',
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'EndDate',
                                        allowEditing: false,
                                        //   width: 180,
                                        label: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                          alignment: Alignment.center,
                                          child: Text('End Date',
                                              textAlign: TextAlign.center,
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'ActualStart',
                                        allowEditing: false,
                                        width: 160,
                                        label: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          alignment: Alignment.center,
                                          child: Text('Actual Start',
                                              textAlign: TextAlign.center,
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'ActualEnd',
                                        allowEditing: false,
                                        width: 140,
                                        label: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          alignment: Alignment.center,
                                          child: Text('Actual End',
                                              textAlign: TextAlign.center,
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'ActualDuration',
                                        width: 100,
                                        allowEditing: true,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text('Actual Duration',
                                              textAlign: TextAlign.center,
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Delay',
                                        allowEditing: true,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text('Delay',
                                              textAlign: TextAlign.center,
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'ReasonDelay',
                                        allowEditing: true,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text('Reason For Delay',
                                              textAlign: TextAlign.center,
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Unit',
                                        allowEditing: true,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text('Unit',
                                              textAlign: TextAlign.center,
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'QtyScope',
                                        allowEditing: true,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text('Oty as per scope',
                                              textAlign: TextAlign.center,
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'QtyExecuted',
                                        allowEditing: true,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text('Qty executed',
                                              textAlign: TextAlign.center,
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'BalancedQty',
                                        allowEditing: false,
                                        label: Container(
                                          width: 150,
                                          alignment: Alignment.center,
                                          child: Text('Balanced Qty',
                                              textAlign: TextAlign.center,
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Progress',
                                        allowEditing: false,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text('% of Progress',
                                              textAlign: TextAlign.center,
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                      GridColumn(
                                        columnName: 'Weightage',
                                        allowEditing: true,
                                        label: Container(
                                          alignment: Alignment.center,
                                          child: Text('Weightage',
                                              overflow:
                                                  TextOverflow.values.first,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    width: 450,
                                    child: GanttChartView(
                                        scrollController: scrollController,
                                        scrollPhysics:
                                            const BouncingScrollPhysics(),
                                        maxDuration: null,
                                        // const Duration(days: 30 * 2),
                                        // optional, set to null for infinite horizontal scroll
                                        startDate:
                                            DateTime(2023, 8, 1), //required
                                        dayWidth:
                                            40, //column width for each day
                                        dayHeaderHeight: 35,
                                        eventHeight: 25, //row height for events

                                        stickyAreaWidth: 80, //sticky area width
                                        showStickyArea:
                                            true, //show sticky area or not
                                        showDays: true, //show days or not
                                        startOfTheWeek: WeekDay
                                            .monday, //custom start of the week
                                        weekHeaderHeight: 30,
                                        weekEnds: const {
                                          // WeekDay.saturday,
                                          // WeekDay.sunday
                                        }, //custom weekends
                                        isExtraHoliday: (context, day) {
                                          //define custom holiday logic for each day
                                          return DateUtils.isSameDay(
                                              DateTime(2023, 7, 1), day);
                                        },
                                        events: ganttdata))
                              ],
                            ),
                          ),
                          // const SizedBox(
                          //   height: 5,
                          // ),
                          // Padding(
                          //   padding: const EdgeInsets.all(10.0),
                          //   child: ElevatedButton(
                          //       style:
                          //           ElevatedButton.styleFrom(backgroundColor: blue),
                          //       onPressed: () async {
                          //         showCupertinoDialog(
                          //           context: context,
                          //           builder: (context) =>
                          //               const CupertinoAlertDialog(
                          //             content: SizedBox(
                          //               height: 50,
                          //               width: 50,
                          //               child: Center(
                          //                 child: CircularProgressIndicator(
                          //                   color: Colors.white,
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //         );
                          //         StoreData();
                          //       },
                          //       child: const Text(
                          //         'Sync Data',
                          //         textAlign: TextAlign.center,
                          //         style: TextStyle(
                          //           fontSize: 15,
                          //         ),
                          //       )),
                          // ),
                        ],
                      ),
                    );
                  }
                }),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (() {
              _employees.add(
                Employee(
                  srNo: 1,
                  activity: '',
                  originalDuration: 1,
                  startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                  endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                  actualstartDate:
                      DateFormat('dd-MM-yyyy').format(DateTime.now()),
                  actualendDate:
                      DateFormat('dd-MM-yyyy').format(DateTime.now()),
                  actualDuration: 0,
                  delay: 0,
                  reasonDelay: '',
                  unit: 0,
                  scope: 0,
                  qtyExecuted: 0,
                  balanceQty: 0,
                  percProgress: 0,
                  weightage: 0.5,
                ),
              );
              _employeeDataSource.buildDataGridRows();
              _employeeDataSource.updateDatagridSource();
            })),
      ),
    );
  }

  List<Employee> getEmployeeData() {
    return [
      Employee(
          srNo: 1,
          activity: 'RFC Drawings Of Civil Activities',
          originalDuration: 1,
          startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualstartDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualDuration: 0,
          delay: 0,
          reasonDelay: '',
          unit: 0,
          scope: 0,
          qtyExecuted: 0,
          balanceQty: 0,
          percProgress: 0,
          weightage: 1.5),
      Employee(
          srNo: 2,
          activity: ' EV Layout Drwaings Of Electrical Activities',
          originalDuration: 1,
          startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualstartDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualDuration: 0,
          delay: 0,
          reasonDelay: '',
          unit: 0,
          scope: 0,
          qtyExecuted: 0,
          balanceQty: 0,
          percProgress: 0,
          weightage: 0.7),
      Employee(
          srNo: 3,
          activity: 'Shed Lighting Drawings And Specification',
          originalDuration: 1,
          startDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          endDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualstartDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualendDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
          actualDuration: 0,
          delay: 0,
          reasonDelay: '',
          unit: 0,
          scope: 0,
          qtyExecuted: 0,
          balanceQty: 0,
          percProgress: 0,
          weightage: 0.3),
    ];
  }

  Future<void> getFirestoreData() async {
    FirebaseFirestore instance = FirebaseFirestore.instance;
    CollectionReference tabledata = instance.collection('KeyEventsTable');

    DocumentSnapshot snapshot = await tabledata
        .doc(widget.depoName!)
        .collection('KeyDataTable')
        .doc(widget.userid)
        .collection('KeyAllEvents')
        .doc('${widget.depoName}A3')
        .get();
    var data = snapshot.data() as Map;
    var alldata = data['data'] as List<dynamic>;

    _employees = [];
    alldata.forEach((element) {
      _employees.add(Employee.fromJson(element));
    });
  }

  void StoreData() {
    Map<String, dynamic> table_data = Map();
    for (var i in _employeeDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'viewbutton' &&
            data.columnName != 'uploadbutton') {
          table_data[data.columnName] = data.value;
        }
      }
      tabledata2.add(table_data);
      table_data = {};
    }

    FirebaseFirestore.instance
        .collection('KeyEventsTable')
        .doc(widget.depoName!)
        .collection('KeyDataTable')
        .doc(widget.userid)
        .collection('KeyAllEvents')
        .doc('${widget.depoName}A3')
        .set({'data': tabledata2}).whenComplete(() {
      tabledata2.clear();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      companyId = value;
    });
  }

  identifyUser() async {
    snap = await FirebaseFirestore.instance.collection('Admin').get();

    if (snap!.docs[0]['Employee Id'] == companyId &&
        snap!.docs[0]['CompanyName'] == 'TATA MOTOR') {
      setState(() {
        specificUser = false;
      });
    }
  }
}
