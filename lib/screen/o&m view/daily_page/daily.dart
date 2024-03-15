import 'package:assingment/datasource/o&m_datasource/daily_chargerManagement.dart';
import 'package:assingment/datasource/o&m_datasource/daily_transformerdatasource.dart';
import 'package:assingment/model/o&m_model/daily_sfu.dart';
import 'package:assingment/utils/upper_tableHeader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../Authentication/auth_service.dart';
import '../../../components/Loading_page.dart';
import '../../../datasource/o&m_datasource/daily_acdbdatasource.dart';
import '../../../datasource/o&m_datasource/daily_pssManagement.dart';
import '../../../datasource/o&m_datasource/daily_rmudatasource.dart';
import '../../../datasource/o&m_datasource/daily_sfudatasource.dart';
import '../../../model/o&m_model/daily_acdb.dart';
import '../../../model/o&m_model/daily_charger.dart';
import '../../../model/o&m_model/daily_pss.dart';
import '../../../model/o&m_model/daily_rmu.dart';
import '../../../model/o&m_model/daily_transformer.dart';
import '../../../utils/daily_managementlist.dart';
import '../../../utils/date_formart.dart';
import '../../../utils/date_inputFormatter.dart';
import '../../../widget/style.dart';

List<bool> isShowPinIcon = [];
List<int> globalItemLengthList = [];

String? selectedDate = DateFormat.yMMMMd().format(DateTime.now());

class DailyManagementPage extends StatefulWidget {
  String? cityName;
  String? depoName;
  int tabIndex = 0;
  String? tabletitle;

  DailyManagementPage(
      {super.key,
      required this.cityName,
      required this.depoName,
      required this.tabIndex,
      required this.tabletitle});

  @override
  State<DailyManagementPage> createState() => _DailyManagementPageState();
}

class _DailyManagementPageState extends State<DailyManagementPage> {
  bool isImagesAvailable = false;
  final List<DailySfuModel> _dailySfu = [];
  final List<DailyChargerModel> _dailycharger = [];
  final List<DailyPssModel> _dailyPss = [];
  final List<DailyTransformerModel> _dailyTransfer = [];
  final List<DailyrmuModel> _dailyrmu = [];
  final List<DailyAcdbModel> _dailyacdb = [];

  late DailySFUManagementDataSource _dailySfuDataSource;
  late DailyChargerManagementDataSource _dailyChargerDataSource;
  late DailyPssManagementDataSource _dailyPssDataSource;
  late DailyTranformerDataSource _dailyTranformerDataSource;
  late DailyRmuDataSource _dailyRmuDataSource;
  late DailyAcdbManagementDataSource _dailyAcdbdatasource;
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

  final TextEditingController _checkedbycontroller = TextEditingController();

  String pagetitle = 'Daily Report';

  @override
  void initState() {
    _depotController.text = widget.depoName.toString();
    _datecontroller.text = ddmmyyyy;
    _timecontroller.text = ttmmss;
    _stream = FirebaseFirestore.instance
        .collection('DailyManagementPage')
        .doc('${widget.depoName}')
        .collection(selectedDate.toString())
        .doc(userId)
        .snapshots();

    getUserId().whenComplete(() async {
      _dailyChargerDataSource = DailyChargerManagementDataSource(_dailycharger,
          context, widget.cityName!, widget.depoName!, selectedDate!, userId);
      // _dailyPssDataSource = DailyPssManagementDataSource(_dailyPss, context,
      //     widget.cityName!, widget.depoName!, selectedDate!, userId);
      _dailySfuDataSource = DailySFUManagementDataSource(_dailySfu, context,
          widget.cityName!, widget.depoName!, selectedDate!, userId);
      _dailyPssDataSource = DailyPssManagementDataSource(_dailyPss, context,
          widget.cityName!, widget.depoName!, selectedDate!, userId);
      _dataGridController = DataGridController();
      _dailyTranformerDataSource = DailyTranformerDataSource(_dailyTransfer,
          context, widget.cityName!, widget.depoName!, selectedDate!, userId);
      _dailyRmuDataSource = DailyRmuDataSource(_dailyrmu, context,
          widget.cityName!, widget.depoName!, selectedDate!, userId);
      _dailyAcdbdatasource = DailyAcdbManagementDataSource(_dailyacdb, context,
          widget.cityName!, widget.depoName!, selectedDate!, userId);
      _dataGridController = DataGridController();

      _isloading = false;
      setState(() {});
    });

    super.initState();
  }

  // Define column names and labels for all tabs
  List<List<String>> tabColumnNames = [
    chargercolumnNames,
    sfucolumnNames,
    psscolumnNames,
    transformercolumnNames,
    rmucolumnNames,
    acdbcolumnNames
  ];

  List<List<String>> tabColumnLabels = [
    chargercolumnLabelNames,
    sfucolumnLabelNames,
    psscolumnLabelNames,
    transformerLabelNames,
    rmuLabelNames,
    acdbLabelNames
    // Labels for tab 1
    // Labels for tab 2
  ];
  @override
  Widget build(BuildContext context) {
    List<String> currentColumnNames = tabColumnNames[widget.tabIndex];
    List<String> currentColumnLabels = tabColumnLabels[widget.tabIndex];

    columns.clear();
    for (String columnName in currentColumnNames) {
      columns.add(
        GridColumn(
          columnName: columnName,
          visible: true,
          allowEditing: columnName == 'Add' ||
                  columnName == 'Delete' ||
                  columnName == columnName[0]
              ? false
              : true,
          width: MediaQuery.of(context).size.width *
              0.082, // You can adjust this width as needed
          label: createColumnLabel(
            currentColumnLabels[currentColumnNames.indexOf(columnName)],
          ),
        ),
      );
    }

    return Scaffold(
      body: _isloading
          ? LoadingPage()
          : SingleChildScrollView(
              child: Column(children: [
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
                                          true,
                                          true,
                                          context),
                                      customText(
                                          'Time:',
                                          '01:01:00',
                                          _timecontroller,
                                          TextInputType.datetime,
                                          [],
                                          true,
                                          true,
                                          context),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      customText(
                                          'Document Reference Number:',
                                          'DCASK12354',
                                          _docRefcontroller,
                                          TextInputType.name,
                                          [],
                                          false,
                                          false,
                                          context),
                                      customText(
                                          'Bus Depot Name:',
                                          'BBM',
                                          _depotController,
                                          TextInputType.name,
                                          [],
                                          false,
                                          false,
                                          context)
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: Text(
                                          'TPEVCSL/E-BUS/${widget.cityName}',
                                          style: tableheader,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
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
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: SfDataGridTheme(
                    data: SfDataGridThemeData(
                        headerColor: white, gridLineColor: blue),
                    child: StreamBuilder(
                      stream: _stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return LoadingPage();
                        } else if (!snapshot.hasData ||
                            snapshot.data.exists == false) {
                          return SfDataGrid(
                              source: widget.tabIndex == 0
                                  ? _dailyChargerDataSource
                                  : widget.tabIndex == 1
                                      ? _dailySfuDataSource
                                      : widget.tabIndex == 2
                                          ? _dailyPssDataSource
                                          : widget.tabIndex == 3
                                              ? _dailyTranformerDataSource
                                              : widget.tabIndex == 4
                                                  ? _dailyRmuDataSource
                                                  : _dailyAcdbdatasource,
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
                          }

                          _dailySfu.clear();
                          _dailySfuDataSource.buildDataGridRows();
                          _dailySfuDataSource.updateDatagridSource();
                          alldata.forEach((element) {
                            _dailySfu.add(DailySfuModel.fromjson(element));
                            _dailySfuDataSource = DailySFUManagementDataSource(
                              _dailySfu,
                              context,
                              widget.cityName!,
                              widget.depoName!,
                              selectedDate!,
                              userId,
                            );
                            _dataGridController = DataGridController();
                            _dailySfuDataSource.buildDataGridRows();
                            _dailySfuDataSource.updateDatagridSource();
                          });

                          return SfDataGrid(
                              source: widget.tabIndex == 0
                                  ? _dailyChargerDataSource
                                  : widget.tabIndex == 1
                                      ? _dailySfuDataSource
                                      : widget.tabIndex == 2
                                          ? _dailySfuDataSource
                                          : widget.tabIndex == 3
                                              ? _dailyPssDataSource
                                              : widget.tabIndex == 4
                                                  ? _dailyTranformerDataSource
                                                  : _dailyRmuDataSource,
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
                                return details
                                    .getIntrinsicRowHeight(details.rowIndex);
                              },
                              columns: columns);
                        }
                      },
                    ),
                  ),
                ),
                tableFooter(dateController),
                Row(children: [
                  Column(
                    children: [
                      customText('Checked by:', '', _checkedbycontroller,
                          TextInputType.name, [], false, true, context),
                    ],
                  ),
                ])
              ]),
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: (() {
            widget.tabIndex == 0
                ? _dailycharger.add(DailyChargerModel(
                    cn: _dailyChargerDataSource.dataGridRows.length + 1,
                    dc: '',
                    cgca: '',
                    cgcb: '',
                    cgcca: '',
                    cgccb: '',
                    dl: '',
                    arm: '',
                    ec: '',
                    cc: ''))
                : widget.tabIndex == 1
                    ? _dailySfu.add(DailySfuModel(
                        sfuNo: _dailySfuDataSource.dataGridRows.length + 1,
                        fuc: '',
                        icc: 'icc',
                        ictc: 'ictc',
                        occ: 'occ',
                        octc: 'octc',
                        ec: 'ec',
                        cg: 'cg',
                        dl: 'dl',
                        vi: 'vi'))
                    : widget.tabIndex == 2
                        ? _dailyPss.add(DailyPssModel(
                            pssNo: _dailyPssDataSource.dataGridRows.length + 1,
                            pbc: '',
                            ec: '',
                            sgp: '',
                            pdl: '',
                            wtiTemp: '',
                            otiTemp: '',
                            vpiPresence: '',
                            viMCCb: '',
                            vr: '',
                            ar: '',
                            mccbHandle: ''))
                        : widget.tabIndex == 3
                            ? _dailyTransfer.add(DailyTransformerModel(
                                trNo: _dailyTranformerDataSource
                                        .dataGridRows.length +
                                    1,
                                pc: '',
                                ec: '',
                                ol: '',
                                oc: '',
                                wtiTemp: '',
                                otiTemp: '',
                                brk: '',
                                cta: ''))
                            : widget.tabIndex == 4
                                ? _dailyrmu.add(DailyrmuModel(
                                    rmuNo: _dailyTranformerDataSource
                                            .dataGridRows.length +
                                        1,
                                    sgp: '',
                                    vpi: '',
                                    crd: '',
                                    rec: '',
                                    arm: '',
                                    cbts: '',
                                    cra: ''))
                                : _dailyacdb.add(DailyAcdbModel(
                                    incomerNo: _dailyAcdbdatasource
                                            .dataGridRows.length +
                                        1,
                                    vi: '',
                                    vr: '',
                                    ar: '',
                                    acdbSwitch: '',
                                    mccbHandle: '',
                                    ccb: '',
                                    arm: ''));
            _dailyChargerDataSource.buildDataGridRows();
            _dailyChargerDataSource.updateDatagridSource();
            _dailySfuDataSource.buildDataGridRows();
            _dailySfuDataSource.updateDatagridSource();
            _dailyPssDataSource.buildDataGridRows();
            _dailyPssDataSource.updateDatagridSource();
            _dailyTranformerDataSource.buildDataGridRows();
            _dailyTranformerDataSource.updateDatagridSource();
            _dailyRmuDataSource.buildDataGridRows();
            _dailyRmuDataSource.updateDatagridSource();
            _dailyAcdbdatasource.buildDataGridRows();
            _dailyAcdbdatasource.updateDatagridSource();
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
        .collection('DailyManagementPage')
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
