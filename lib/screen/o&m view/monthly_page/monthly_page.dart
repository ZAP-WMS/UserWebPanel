import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import '../../../Authentication/auth_service.dart';
import '../../../components/Loading_page.dart';
import '../../../datasource/o&m_datasource/monthly_chargerdatasource.dart';
import '../../../datasource/o&m_datasource/monthly_filter.dart';
import '../../../model/o&m_model/monthly_charger.dart';
import '../../../model/o&m_model/monthly_filter.dart';
import '../../../utils/daily_managementlist.dart';
import '../../../utils/date_formart.dart';
import '../../../utils/date_inputFormatter.dart';
import '../../../utils/upper_tableHeader.dart';
import '../../../widget/style.dart';

class MonthlyManagementPage extends StatefulWidget {
  String? cityName;
  String? depoName;
  int tabIndex = 0;
  String? tabletitle;
  MonthlyManagementPage(
      {super.key,
      required this.cityName,
      required this.depoName,
      required this.tabIndex,
      required this.tabletitle});

  @override
  State<MonthlyManagementPage> createState() => _MonthlyManagementPageState();
}

class _MonthlyManagementPageState extends State<MonthlyManagementPage> {
  String? selectedDate = DateFormat.yMMMMd().format(DateTime.now());
  List<GridColumn> columns = [];
  bool _isloading = true;
  Stream? _stream;

  dynamic userId;

  final TextEditingController _datecontroller = TextEditingController();
  final TextEditingController _docRefcontroller = TextEditingController();
  final TextEditingController _timecontroller = TextEditingController();
  final TextEditingController _depotController = TextEditingController();

  final TextEditingController _checkedbycontroller = TextEditingController();
  final List<MonthlyChargerModel> _monthlyChargerModel = [];
  final List<MonthlyFilterModel> _monthlyFilterModel = [];

  late MonthlyChargerManagementDataSource _monthlyChargerManagementDataSource;
  late MonthlyFilterManagementDataSource _monthlyFilterManagementDataSource;
  late DataGridController _dataGridController;

  @override
  void initState() {
    // Example date
    DateTime date = DateTime.now();
    _stream = FirebaseFirestore.instance
        .collection('DailyManagementPage')
        .doc('${widget.depoName}')
        .collection(selectedDate.toString())
        .doc(userId)
        .snapshots();

    _dataGridController = DataGridController();
    // Format date to DD/MM/YY format
    _datecontroller.text = ddmmyyyy;
    _timecontroller.text = ttmmss;
    getUserId().whenComplete(() {
      _monthlyChargerManagementDataSource = MonthlyChargerManagementDataSource(
          _monthlyChargerModel,
          context,
          widget.cityName!,
          widget.depoName!,
          selectedDate!,
          userId);
      _monthlyFilterManagementDataSource = MonthlyFilterManagementDataSource(
          _monthlyFilterModel,
          context,
          widget.cityName!,
          widget.depoName!,
          selectedDate!,
          userId);
      _dataGridController = DataGridController();

      _isloading = false;
      setState(() {});
    });

    super.initState();
  }

  List<List<String>> tabColumnNames = [
    monthlyChargerColumnName,
    monthlyFilterColumnName,
  ];

  List<List<String>> tabColumnLabels = [
    monthlyLabelColumnName,
    monthlyFilterColumnName,
  ];
  @override
  Widget build(BuildContext context) {
    _depotController.text = widget.depoName.toString();

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
                                          'doc1234',
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
                                  ? _monthlyChargerManagementDataSource
                                  : _monthlyFilterManagementDataSource,
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
                          // alldata = '';
                          // alldata = snapshot.data['data'] as List<dynamic>;
                          // int listLen = snapshot.data['data'].length;
                          // if (isImagesAvailable == false) {
                          //   isShowPinIcon.clear();
                          //   globalItemLengthList.clear();
                          //   for (int i = 0; i < listLen; i++) {
                          //     isShowPinIcon.add(false);
                          //     globalItemLengthList.add(0);
                          //   }
                          // }

                          // _dailySfu.clear();
                          // _dailySfuDataSource.buildDataGridRows();
                          // _dailySfuDataSource.updateDatagridSource();
                          // alldata.forEach((element) {
                          //   _dailySfu.add(DailySfuModel.fromjson(element));
                          //   _dailySfuDataSource = DailySFUManagementDataSource(
                          //     _dailySfu,
                          //     context,
                          //     widget.cityName!,
                          //     widget.depoName!,
                          //     selectedDate!,
                          //     userId,
                          //   );
                          //   _dataGridController = DataGridController();
                          //   _dailySfuDataSource.buildDataGridRows();
                          //   _dailySfuDataSource.updateDatagridSource();
                          //  });

                          return SfDataGrid(
                              source: widget.tabIndex == 0
                                  ? _monthlyChargerManagementDataSource
                                  : _monthlyChargerManagementDataSource,
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
                Row(
                  children: [
                    Column(
                      children: [
                        customText('Checked by:', '', _checkedbycontroller,
                            TextInputType.name, [], false, false, context),
                      ],
                    ),
                  ],
                )
              ]),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (widget.tabIndex == 0) {
              _monthlyChargerModel.add(MonthlyChargerModel(
                cn: _monthlyChargerManagementDataSource.dataGridRows.length + 1,
                gun1: '',
                gun2: '',
              ));
              _monthlyChargerManagementDataSource.buildDataGridRows();
              _monthlyChargerManagementDataSource.updateDatagridSource();
            } else {
              _monthlyFilterModel
                  .add(MonthlyFilterModel(cn: 1, fcd: '', dgcd: ''));
              _monthlyFilterManagementDataSource.buildDataGridRows();
              _monthlyFilterManagementDataSource.updateDatagridSource();
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
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

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
  }
}
