import 'package:assingment/datasource/o&m_datasource/daily_chargerManagement.dart';
import 'package:assingment/model/o&m_model/daily_sfu.dart';
import 'package:assingment/utils/upper_tableHeader.dart';
import 'package:assingment/widget/appbar_back_date.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../Authentication/auth_service.dart';
import '../../../Planning_Pages/summary.dart';
import '../../../components/Loading_page.dart';
import '../../../datasource/o&m_datasource/daily_sfudatasource.dart';
import '../../../model/o&m_model/daily_charger.dart';
import '../../../utils/daily_managementlist.dart';
import '../../../utils/date_inputFormatter.dart';
import '../../../widget/style.dart';

List<bool> isShowPinIcon = [];
List<int> globalItemLengthList = [];

String? selectedDate = DateFormat.yMMMMd().format(DateTime.now());

class DailyManagementPage extends StatefulWidget {
  String? cityName;
  String? depoName;
  String? tabletitle;

  DailyManagementPage(
      {super.key,
      required this.cityName,
      required this.depoName,
      required this.tabletitle});

  @override
  State<DailyManagementPage> createState() => _DailyManagementPageState();
}

class _DailyManagementPageState extends State<DailyManagementPage> {
  bool isImagesAvailable = false;
  List<DailySfuModel> DailyManagementPage = [];
  List<DailyChargerModel> _dailycharger = [];
  late DailySFUManagementDataSource _dailySfuDataSource;
  late DailyChargerManagementDataSource _dailyChargerDataSource;
  late DataGridController _dataGridController;
  List<dynamic> tabledata2 = [];
  Stream? _stream;
  var alldata;
  dynamic userId;
  bool _isloading = true;
  List<GridColumn> columns = [];
  final TextEditingController _datecontroller = TextEditingController();
  final TextEditingController _docRefcontroller = TextEditingController();
  final TextEditingController _timecontroller = TextEditingController();
  final TextEditingController _depotController = TextEditingController();

  String pagetitle = 'Daily Report';

  @override
  void initState() {
    selectedDate = DateFormat.yMMMMd().format(DateTime.now());

    getUserId().whenComplete(() async {
      // DailyManagementPage = getmonthlyReport();
      // ignore: use_build_context_synchronously
      _dailyChargerDataSource = DailyChargerManagementDataSource(_dailycharger,
          context, widget.cityName!, widget.depoName!, selectedDate!, userId);
      _dailySfuDataSource = DailySFUManagementDataSource(DailyManagementPage,
          context, widget.cityName!, widget.depoName!, selectedDate!, userId);
      _dataGridController = DataGridController();

      _isloading = false;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _depotController.text = widget.depoName.toString();
    for (String columnName in widget.tabletitle == 'Charger Checklist'
        ? chargercolumnNames
        : sfucolumnNames) {
      columns.add(
        GridColumn(
          columnName: columnName,
          visible: true,
          allowEditing: columnName == 'Add' ||
                  columnName == 'Delete' ||
                  columnName == 'sfuNo'
              ? false
              : true,
          width: MediaQuery.of(context).size.width *
              0.082, // You can adjust this width as needed
          label: createColumnLabel(
            widget.tabletitle == 'Charger Checklist'
                ? chargercolumnLabelNames[
                    chargercolumnLabelNames.indexOf(columnName)]
                : sfucolumnLabelNames[sfucolumnNames.indexOf(columnName)],
          ),
        ),
      );
    }
    sfucolumnNames.clear();
    chargercolumnNames.clear();
    DailyManagementPage.clear();
    _stream = FirebaseFirestore.instance
        .collection('DailyManagementPage3')
        .doc('${widget.depoName}')
        .collection(selectedDate.toString())
        .doc(userId)
        .snapshots();

    return Scaffold(
      body: _isloading
          ? LoadingPage()
          : Column(children: [
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: blue),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/applogo/logo.png',
                              height: 50,
                              fit: BoxFit.fitWidth,
                            ),
                            Divider(
                              color: blue,
                              thickness: 2,
                            ),
                            Text(
                              widget.tabletitle!,
                              style: tableTitleStyle,
                            ),
                            Divider(
                              color: blue,
                              thickness: 2,
                            ),
                            Row(
                              children: [
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    customText(
                                        'Date:',
                                        'DD/MM/YYYY',
                                        _datecontroller,
                                        TextInputType.number,
                                        [DateInputFormatter()],
                                        context),
                                    customText(
                                        'Time:',
                                        '01:01:00',
                                        _timecontroller,
                                        TextInputType.datetime,
                                        [],
                                        context),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    customText(
                                        'Document Reference Number:',
                                        'doc1234',
                                        _docRefcontroller,
                                        TextInputType.name,
                                        [],
                                        context),
                                    customText(
                                        'Bus Depot Name:',
                                        'BBM',
                                        _depotController,
                                        TextInputType.name,
                                        [],
                                        context)
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      child: Text(
                                        'TPEVCSL/E-BUS/${widget.cityName}',
                                        style: tableheader,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    // customText('TPEVCSL/E-BUS/Delhi:', '',
                                    //     controller, context),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.03,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ]))),
              //  upperHeader('SFU Checklist', context),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: SfDataGridTheme(
                    data: SfDataGridThemeData(
                        headerColor: white,
                        gridLineColor: blue,
                        gridLineStrokeWidth: 2),
                    child: StreamBuilder(
                      stream: _stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return LoadingPage();
                        } else if (!snapshot.hasData ||
                            snapshot.data.exists == false) {
                          widget.tabletitle == "Charger checklist"
                              ? _dailyChargerDataSource =
                                  DailyChargerManagementDataSource(
                                      _dailycharger,
                                      context,
                                      widget.cityName!,
                                      widget.depoName!,
                                      selectedDate!,
                                      userId)
                              : _dailySfuDataSource =
                                  DailySFUManagementDataSource(
                                  DailyManagementPage,
                                  context,
                                  widget.cityName!,
                                  widget.depoName!,
                                  selectedDate!,
                                  userId,
                                );

                          _dataGridController = DataGridController();

                          return SfDataGrid(
                              source: widget.tabletitle == 'Charger Checklist'
                                  ? _dailyChargerDataSource
                                  : _dailySfuDataSource,
                              allowEditing: true,
                              frozenColumnsCount: 1,
                              gridLinesVisibility: GridLinesVisibility.both,
                              headerGridLinesVisibility:
                                  GridLinesVisibility.both,
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
                              columns: columns);
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

                          DailyManagementPage.clear();
                          _dailySfuDataSource.buildDataGridRows();
                          _dailySfuDataSource.updateDatagridSource();
                          alldata.forEach((element) {
                            // DailyManagementPage.add(DailyManagementProjectModel.fromjson(element));
                            // _dailySfuDataSource = DailyDataSource(
                            //   DailyManagementPage,
                            //   context,
                            //   widget.cityName!,
                            //   widget.depoName!,
                            //   selectedDate!,
                            //   userId,
                            // );
                            _dataGridController = DataGridController();
                            _dailySfuDataSource.buildDataGridRows();
                            _dailySfuDataSource.updateDatagridSource();
                          });

                          return SfDataGridTheme(
                              data: SfDataGridThemeData(
                                  headerColor: white, gridLineColor: blue),
                              child: SfDataGrid(
                                  source:
                                      widget.tabletitle == 'Charger Checklist'
                                          ? _dailyChargerDataSource
                                          : _dailySfuDataSource,
                                  allowEditing: true,
                                  frozenColumnsCount: 2,
                                  gridLinesVisibility: GridLinesVisibility.both,
                                  headerGridLinesVisibility:
                                      GridLinesVisibility.both,
                                  selectionMode: SelectionMode.single,
                                  navigationMode: GridNavigationMode.cell,
                                  editingGestureType: EditingGestureType.tap,
                                  rowHeight: 50,
                                  controller: _dataGridController,
                                  onQueryRowHeight: (details) {
                                    return details.getIntrinsicRowHeight(
                                        details.rowIndex);
                                  },
                                  columns: columns));
                        }
                      },
                    ),
                  ),
                ),
              )
            ]),
      floatingActionButton: FloatingActionButton(
          onPressed: (() {
            globalItemLengthList.add(0);
            isShowPinIcon.add(false);
            DailyManagementPage.add(DailySfuModel(
                sfuNo: _dailySfuDataSource.dataGridRows.length + 1,
                fuc: '',
                icc: 'icc',
                ictc: 'ictc',
                occ: 'occ',
                octc: 'octc',
                ec: 'ec',
                cg: 'cg',
                dl: 'dl',
                vi: 'vi'));
            // DailyManagementPage.add(DailyManagementDataSource(
            //     siNo: 1,
            //     // date: DateFormat().add_yMd(storeData()).format(DateTime.now()),
            //     // state: "Maharashtra",
            //     // depotName: 'depotName',
            //     typeOfActivity: '',
            //     activityDetails: "",
            //     progress: '',
            //     status: ''));
            _dailySfuDataSource.buildDataGridRows();
            _dailySfuDataSource.updateDatagridSource();
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
    for (var i in _dailySfuDataSource.dataGridRows) {
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
        .collection('DailyManagementPage3')
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

  // List<DailyManagementDataSource> getmonthlyReport() {
  //   return [
  //     DailyManagementDataSource(
  //         siNo: 1,
  //         // date: DateFormat().add_yMd().format(DateTime.now()),
  //         // state: "Maharashtra",
  //         // depotName: 'depotName',
  //         typeOfActivity: '',
  //         activityDetails: '',
  //         progress: '',
  //         status: '')
  //   ];
  // }

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
        .collection('DailyManagementPage3')
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

  Widget createColumnLabel(String labelText) {
    return Container(
      alignment: Alignment.center,
      child: Text(labelText,
          overflow: TextOverflow.values.first,
          textAlign: TextAlign.center,
          style: tableheader),
    );
  }
}
