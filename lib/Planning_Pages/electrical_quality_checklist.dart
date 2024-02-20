import 'dart:convert';

import 'package:assingment/Planning_Pages/civil_quality_checklist.dart';
import 'package:assingment/Planning_Pages/quality_checklist.dart';
import 'package:assingment/widget/loading_pdf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../Authentication/auth_service.dart';
import '../FirebaseApi/firebase_api.dart';
import '../QualityDatasource/qualityElectricalDatasource/quality_EP.dart';
import '../QualityDatasource/qualityElectricalDatasource/quality_acdb.dart';
import '../QualityDatasource/qualityElectricalDatasource/quality_cdi.dart';
import '../QualityDatasource/qualityElectricalDatasource/quality_charger.dart';
import '../QualityDatasource/qualityElectricalDatasource/quality_ci.dart';
import '../QualityDatasource/qualityElectricalDatasource/quality_cmu.dart';
import '../QualityDatasource/qualityElectricalDatasource/quality_ct.dart';
import '../QualityDatasource/qualityElectricalDatasource/quality_msp.dart';
import '../QualityDatasource/qualityElectricalDatasource/quality_pss.dart';
import '../QualityDatasource/qualityElectricalDatasource/quality_rmu.dart';
import '../components/loading_page.dart';
import '../model/quality_checklistModel.dart';
import '../widget/quality_list.dart';
import '../widget/style.dart';
import 'package:pdf/pdf.dart';
import 'dart:html' as html;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

late QualityPSSDataSource _qualityPSSDataSource;
late QualityrmuDataSource _qualityrmuDataSource;
late QualityctDataSource _qualityctDataSource;
late QualitycmuDataSource _qualitycmuDataSource;
late QualityacdDataSource _qualityacdDataSource;
late QualityCIDataSource _qualityCIDataSource;
late QualityCDIDataSource _qualityCDIDataSource;
late QualityMSPDataSource _qualityMSPDataSource;
late QualityChargerDataSource _qualityChargerDataSource;
late QualityEPDataSource _qualityEPDataSource;

List<dynamic> psstabledatalist = [];
List<dynamic> rmutabledatalist = [];
List<dynamic> cttabledatalist = [];
List<dynamic> cmutabledatalist = [];
List<dynamic> acdbtabledatalist = [];
List<dynamic> citabledatalist = [];
List<dynamic> cditabledatalist = [];
List<dynamic> msptabledatalist = [];
List<dynamic> chargertabledatalist = [];
List<dynamic> eptabledatalist = [];

String selectedDate = DateFormat.yMMMMd().format(DateTime.now());
DateTime currentDate = DateTime.now();

List tabForElec = [
  'PSS',
  'RMU',
  'CT',
  'CMU',
  'ACDB',
  'CI',
  'CDI',
  'MSP',
  'CHARGER',
  'EARTH PIT'
];

int? _selectedIndex = 0;

TextEditingController employeeNameController = TextEditingController();
TextEditingController olaNumberController = TextEditingController();
TextEditingController docNoController = TextEditingController();
TextEditingController panelSrController = TextEditingController();
TextEditingController vendorNoController = TextEditingController();
TextEditingController depotNameController = TextEditingController();
TextEditingController dateController = TextEditingController();
TextEditingController customerNameController = TextEditingController();

class ElectricalQualityChecklist extends StatefulWidget {
  String? cityName;
  String? depoName;
  String? currentDate;
  String? userId;
  bool? isHeader;
  Function? getBoolList;

  ElectricalQualityChecklist(
      {super.key,
      required this.cityName,
      required this.depoName,
      this.currentDate,
      required this.userId,
      this.isHeader = true,
      this.getBoolList});

  @override
  State<ElectricalQualityChecklist> createState() =>
      _ElectricalQualityChecklistState();
}

class _ElectricalQualityChecklistState
    extends State<ElectricalQualityChecklist> {
  Color rowTextColor = blue;
  ProgressDialog? pr;

  List<QualitychecklistModel> qualitylisttable1 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable2 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable3 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable4 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable5 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable6 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable7 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable8 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable9 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable10 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable11 = <QualitychecklistModel>[];
  List<QualitychecklistModel> qualitylisttable12 = <QualitychecklistModel>[];

// late QualityChecklistDataSource _checklistDataSource;

  Stream? _stream;
  Stream? _stream1;
  Stream? _stream2;
  Stream? _stream3;
  Stream? _stream4;
  Stream? _stream5;
  Stream? _stream6;
  Stream? _stream7;
  Stream? _stream8;
  Stream? _stream9;
  Stream? _stream10;
  Stream? _stream11;
  late DataGridController _dataGridController;
  bool _isloading = true;
  List<QualitychecklistModel> data = [];
  bool checkTable = true;

  List<bool> electricalBoolList = [];

  @override
  void initState() {
    pr = ProgressDialog(context,
        customBody:
            Container(height: 200, width: 100, child: const LoadingPdf()));
    setBoolean();
    if (_selectedIndex == 0) {
      electricalBoolList[0] = true;
      print(electricalBoolList);
      widget.getBoolList!(electricalBoolList, tabForElec[_selectedIndex!]);
    }
    super.initState();

    getUserId().whenComplete(() => {
          getControllersData(),
          getTableData().whenComplete(() {
            qualitylisttable1 = checkTable ? getData() : data;
            _qualityPSSDataSource = QualityPSSDataSource(
                qualitylisttable1, widget.cityName!, widget.depoName!);
            _dataGridController = DataGridController();

            qualitylisttable2 = checkTable ? rmu_getData() : data;
            _qualityrmuDataSource = QualityrmuDataSource(
                qualitylisttable2, widget.cityName!, widget.depoName!);
            _dataGridController = DataGridController();

            qualitylisttable3 = checkTable ? ct_getData() : data;
            _qualityctDataSource = QualityctDataSource(
                qualitylisttable3, widget.cityName!, widget.depoName!);
            _dataGridController = DataGridController();

            qualitylisttable4 = checkTable ? cmu_getData() : data;
            _qualitycmuDataSource = QualitycmuDataSource(
                qualitylisttable4, widget.cityName!, widget.depoName!);
            _dataGridController = DataGridController();

            qualitylisttable5 = checkTable ? acdb_getData() : data;
            _qualityacdDataSource = QualityacdDataSource(
                qualitylisttable5, widget.cityName!, widget.depoName!);
            _dataGridController = DataGridController();

            qualitylisttable6 = checkTable ? ci_getData() : data;
            _qualityCIDataSource = QualityCIDataSource(
                qualitylisttable6, widget.cityName!, widget.depoName!);
            _dataGridController = DataGridController();

            qualitylisttable7 = checkTable ? cdi_getData() : data;
            _qualityCDIDataSource = QualityCDIDataSource(
                qualitylisttable7, widget.cityName!, widget.depoName!);
            _dataGridController = DataGridController();

            qualitylisttable8 = checkTable ? msp_getData() : data;
            _qualityMSPDataSource = QualityMSPDataSource(
                qualitylisttable8, widget.cityName!, widget.depoName!);
            _dataGridController = DataGridController();

            qualitylisttable9 = checkTable ? charger_getData() : data;
            _qualityChargerDataSource = QualityChargerDataSource(
                qualitylisttable9, widget.cityName!, widget.depoName!);
            _dataGridController = DataGridController();

            qualitylisttable10 = checkTable ? earth_pit_getData() : data;
            _qualityEPDataSource = QualityEPDataSource(
                qualitylisttable10, widget.cityName!, widget.depoName!);
            _dataGridController = DataGridController();
          }),
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 10,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 8,
            bottom: TabBar(
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
              onTap: (value) async {
                _selectedIndex = value;
                checkTable = true;
                selectedDate = DateFormat.yMMMMd().format(DateTime.now());
                currentDate = DateTime.now();
                setBoolean();
                getControllersData();
                await getTableData();

                electricalBoolList[value] = true;
                widget.getBoolList!(electricalBoolList, tabForElec[value]);
              },
              tabs: const [
                Tab(text: "PSS"),
                Tab(text: "RMU"),
                Tab(text: "CT"),
                Tab(text: "CMU"),
                Tab(text: "ACDB"),
                Tab(text: "CI"),
                Tab(text: "CDI"),
                Tab(text: "MSP"),
                Tab(text: "CHARGER"),
                Tab(text: "EARTH PIT"),
              ],
            ),
          ),
          body: TabBarView(children: [
            upperScreen(),
            upperScreen(),
            upperScreen(),
            upperScreen(),
            upperScreen(),
            upperScreen(),
            upperScreen(),
            upperScreen(),
            upperScreen(),
            upperScreen(),
          ]),
        ));
  }

  upperScreen() {
    return _isloading
        ? LoadingPage()
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('ElectricalQualityChecklistCollection')
                .doc('${widget.depoName}')
                .collection('widget.userId!')
                .doc(widget.currentDate)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(top: 8),
                      height: 50,
                      // decoration: BoxDecoration(color: lightblue),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          // Row(
                          //   children: [
                          //     Image.asset('assets/Tata-Power.jpeg',
                          //         height: 50, width: 100),
                          //     const Text('TATA POWER'),
                          //   ],
                          // ),
                          Text(
                            title[int.parse(_selectedIndex.toString())],
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: blue),
                          ),
                          Container(
                            margin: const EdgeInsets.all(5),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(blue)),
                              onPressed: () {
                                _generateElectricalPdf();
                              },
                              child: RichText(
                                  text: TextSpan(children: [
                                TextSpan(
                                    text: 'Download',
                                    style:
                                        TextStyle(fontSize: 17, color: white)),
                                const WidgetSpan(
                                  child: SizedBox(
                                    width: 5,
                                  ),
                                ),
                                const WidgetSpan(
                                  child: Icon(
                                    Icons.download,
                                  ),
                                ),
                              ])),
                            ),
                          ),

                          Row(
                            children: [
                              Text(
                                'Choose Date : ',
                                style: TextStyle(
                                  color: blue,
                                  fontSize: 17,
                                ),
                              ),
                              ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStatePropertyAll(blue)),
                                  onPressed: () => _selectDate(context),
                                  child: Text(
                                    DateFormat('MMMM dd, yyyy')
                                        .format(currentDate),
                                    style: GoogleFonts.aBeeZee(
                                        fontSize: 15, color: white),
                                  )),
                            ],
                          ),
                          Text(
                            'TPCL /DIST/EV/CHECKLIST',
                            style: TextStyle(color: blue),
                          )
                        ],
                      ),
                    ),
                    Container(
                        padding: const EdgeInsets.only(
                            bottom: 10, left: 50, right: 50),
                        // decoration: BoxDecoration(color: lightblue),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  // color: lightblue,
                                  width: 550,
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                          width: 150,
                                          child: Text(
                                            'Employee Name : ',
                                            style: TextStyle(color: blue),
                                          )),
                                      const SizedBox(width: 5),
                                      Expanded(
                                          child: Container(
                                              height: 30,
                                              child: widget.isHeader!
                                                  ? TextFormField(
                                                      controller:
                                                          employeeNameController,
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 0,
                                                                      bottom: 0,
                                                                      left: 5)),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: blue),
                                                    )
                                                  : Container(
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color: blue)),
                                                      child: Text(
                                                        snapshot.data!
                                                                .data()
                                                                .toString()
                                                                .contains(
                                                                    'EmployeeName')
                                                            ? snapshot.data!.get(
                                                                    'EmployeeName') ??
                                                                ''
                                                            : 'Employee Name',
                                                      )))),
                                    ],
                                  ),
                                ),
                                Container(
                                  // color: lightblue,
                                  width: 550,
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SizedBox(
                                          width: 150,
                                          child: Text(
                                            'Doc No. TPCL / DIST-EV:',
                                            style: TextStyle(color: blue),
                                          )),
                                      const SizedBox(width: 5),
                                      Expanded(
                                          child: Container(
                                              height: 30,
                                              child: widget.isHeader!
                                                  ? TextFormField(
                                                      controller:
                                                          docNoController,
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 0,
                                                                      bottom: 0,
                                                                      left: 5)),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: blue),
                                                    )
                                                  : Container(
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color: blue)),
                                                      child: Text(snapshot.data!
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'Dist EV')
                                                          ? snapshot.data!.get(
                                                                  'Dist EV') ??
                                                              ''
                                                          : 'Dist EV')))),
                                    ],
                                  ),
                                ),
                                Container(
                                  // color: lightblue,
                                  width: 550,
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: 150,
                                          child: Text(
                                            'Vendor Name : ',
                                            style: TextStyle(color: blue),
                                          )),
                                      const SizedBox(width: 5),
                                      Expanded(
                                          child: Container(
                                              height: 30,
                                              child: widget.isHeader!
                                                  ? TextFormField(
                                                      controller:
                                                          vendorNoController,
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 0,
                                                                      bottom: 0,
                                                                      left: 5)),
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: blue),
                                                    )
                                                  : Container(
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color: blue)),
                                                      child: Text(snapshot.data!
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'VendorName')
                                                          ? snapshot.data!.get(
                                                                  'VendorName') ??
                                                              ''
                                                          : 'VendorName')))),
                                    ],
                                  ),
                                ),
                                Container(
                                  // color: lightblue,
                                  width: 550,
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: 150,
                                          child: Text(
                                            'Date : ',
                                            style: TextStyle(color: blue),
                                          )),
                                      const SizedBox(width: 5),
                                      Expanded(
                                          child: Container(
                                              height: 30,
                                              child: widget.isHeader!
                                                  ? TextFormField(
                                                      controller:
                                                          dateController,
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 0,
                                                                      bottom: 0,
                                                                      left: 5)),
                                                    )
                                                  : Container(
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color: blue)),
                                                      child: Text(
                                                        snapshot.data!
                                                                .data()
                                                                .toString()
                                                                .contains(
                                                                    'Date')
                                                            ? snapshot.data!.get(
                                                                    'Date') ??
                                                                ''
                                                            : 'Date',
                                                      )))),
                                    ],
                                  ),
                                )
                              ],
                              //   children: [
                              //     HeaderValue('Employee Name', '', empName ?? ''),
                              //     HeaderValue('Doc No.:TPCL/ DIST-EV', '', distev ?? ''),
                              //     HeaderValue('VENDOR NAME', '', vendorname ?? ''),
                              //     HeaderValue('DATE', '', date ?? ''),
                              //   ],
                              // ),
                              // Column(
                              //   children: [
                              //     HeaderValue('OLA NUMBER', '', olano ?? ''),
                              //     HeaderValue('PANEL SR NO.', '', panel ?? ''),
                              //     HeaderValue('DepotName', '', depotname ?? ''),
                              //     HeaderValue('CUSTOMER NAME', '', customername ?? ''),
                              //   ],
                            ),
                            Column(
                              children: [
                                Container(
                                  // color: lightblue,
                                  width: 550,
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: 150,
                                          child: Text(
                                            'OLA Number : ',
                                            style: TextStyle(color: blue),
                                          )),
                                      const SizedBox(width: 5),
                                      Expanded(
                                          child: Container(
                                              height: 30,
                                              child: widget.isHeader!
                                                  ? TextFormField(
                                                      controller:
                                                          olaNumberController,
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 0,
                                                                      bottom: 0,
                                                                      left: 5)),
                                                    )
                                                  : Container(
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color: blue)),
                                                      child: Text(snapshot.data!
                                                              .data()
                                                              .toString()
                                                              .contains('OlaNo')
                                                          ? snapshot.data!.get(
                                                                  'OlaNo') ??
                                                              ''
                                                          : 'OlaNo')))),
                                    ],
                                  ),
                                ),
                                Container(
                                  // color: lightblue,
                                  width: 550,
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: 150,
                                          child: Text(
                                            'Panel Sr No. : ',
                                            style: TextStyle(color: blue),
                                          )),
                                      const SizedBox(width: 5),
                                      Expanded(
                                          child: Container(
                                              height: 30,
                                              child: widget.isHeader!
                                                  ? TextFormField(
                                                      controller:
                                                          panelSrController,
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 0,
                                                                      bottom: 0,
                                                                      left: 5)),
                                                    )
                                                  : Container(
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color: blue)),
                                                      child: Text(
                                                        snapshot.data!
                                                                .data()
                                                                .toString()
                                                                .contains(
                                                                    'PanelNo')
                                                            ? snapshot.data!.get(
                                                                    'PanelNo') ??
                                                                ''
                                                            : 'PanelNo',
                                                      )))),
                                    ],
                                  ),
                                ),
                                Container(
                                  // color: lightblue,
                                  width: 550,
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: 150,
                                          child: Text(
                                            'Depot Name',
                                            style: TextStyle(color: blue),
                                          )),
                                      const SizedBox(width: 5),
                                      Expanded(
                                          child: Container(
                                              height: 30,
                                              child: widget.isHeader!
                                                  ? TextFormField(
                                                      controller:
                                                          depotNameController,
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 0,
                                                                      bottom: 0,
                                                                      left: 5)),
                                                    )
                                                  : Container(
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color: blue)),
                                                      child: Text(
                                                        snapshot.data!
                                                                .data()
                                                                .toString()
                                                                .contains(
                                                                    'DepotName')
                                                            ? snapshot.data!.get(
                                                                    'DepotName') ??
                                                                ''
                                                            : 'DepotName',
                                                      )))),
                                    ],
                                  ),
                                ),
                                Container(
                                  // color: lightblue,
                                  width: 550,
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: 150,
                                          child: Text(
                                            'Customer Name : ',
                                            style: TextStyle(color: blue),
                                          )),
                                      const SizedBox(width: 5),
                                      Expanded(
                                          child: Container(
                                              height: 30,
                                              child: widget.isHeader!
                                                  ? TextFormField(
                                                      controller:
                                                          customerNameController,
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 0,
                                                                      bottom: 0,
                                                                      left: 5)),
                                                    )
                                                  : Container(
                                                      width: 120,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          border: Border.all(
                                                              color: blue)),
                                                      child: Text(
                                                        snapshot.data!
                                                                .data()
                                                                .toString()
                                                                .contains(
                                                                    'CustomerName')
                                                            ? snapshot.data!.get(
                                                                    'CustomerName') ??
                                                                ''
                                                            : 'CustomerName',
                                                      )))),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        )),
                    Expanded(
                      child: StreamBuilder(
                        stream: _selectedIndex == 0
                            ? _stream
                            : _selectedIndex == 1
                                ? _stream1
                                : _selectedIndex == 2
                                    ? _stream2
                                    : _selectedIndex == 3
                                        ? _stream3
                                        : _selectedIndex == 4
                                            ? _stream4
                                            : _selectedIndex == 5
                                                ? _stream5
                                                : _selectedIndex == 6
                                                    ? _stream6
                                                    : _selectedIndex == 7
                                                        ? _stream7
                                                        : _selectedIndex == 8
                                                            ? _stream8
                                                            : _selectedIndex ==
                                                                    9
                                                                ? _stream9
                                                                : _selectedIndex ==
                                                                        10
                                                                    ? _stream10
                                                                    : _stream11,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return LoadingPage();
                          }
                          if (!snapshot.hasData ||
                              snapshot.data.exists == false) {
                            return widget.isHeader!
                                ? SfDataGridTheme(
                                    data: SfDataGridThemeData(
                                        headerColor: white,
                                        gridLineColor: blue),
                                    child: SfDataGrid(
                                      source: _selectedIndex == 0
                                          ? _qualityPSSDataSource
                                          : _selectedIndex == 1
                                              ? _qualityrmuDataSource
                                              : _selectedIndex == 2
                                                  ? _qualityctDataSource
                                                  : _selectedIndex == 3
                                                      ? _qualitycmuDataSource
                                                      : _selectedIndex == 4
                                                          ? _qualityacdDataSource
                                                          : _selectedIndex == 5
                                                              ? _qualityCIDataSource
                                                              : _selectedIndex ==
                                                                      6
                                                                  ? _qualityCDIDataSource
                                                                  : _selectedIndex ==
                                                                          7
                                                                      ? _qualityMSPDataSource
                                                                      : _selectedIndex ==
                                                                              8
                                                                          ? _qualityChargerDataSource
                                                                          : _qualityEPDataSource,
                                      // _selectedIndex == 10
                                      //     ? _qualityRoofingDataSource
                                      //     : _qualityPROOFINGDataSource,

                                      //key: key,
                                      allowEditing: true,
                                      frozenColumnsCount: 2,
                                      gridLinesVisibility:
                                          GridLinesVisibility.both,
                                      headerGridLinesVisibility:
                                          GridLinesVisibility.both,
                                      selectionMode: SelectionMode.single,
                                      navigationMode: GridNavigationMode.cell,
                                      columnWidthMode: ColumnWidthMode.auto,
                                      rowHeight: 50,
                                      headerRowHeight: 50,
                                      editingGestureType:
                                          EditingGestureType.tap,
                                      controller: _dataGridController,

                                      // onQueryRowHeight: (details) {
                                      //   return details.rowIndex == 0 ? 60.0 : 49.0;
                                      // },
                                      columns: [
                                        GridColumn(
                                          columnName: 'srNo',
                                          width: 80,
                                          allowEditing: false,
                                          label: Container(
                                            alignment: Alignment.center,
                                            child: Text('Sr No',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: rowTextColor)),
                                          ),
                                        ),
                                        GridColumn(
                                          width: 350,
                                          columnName: 'checklist',
                                          allowEditing: false,
                                          label: Container(
                                            alignment: Alignment.center,
                                            child: Text('ACTIVITY',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: rowTextColor)),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'responsibility',
                                          width: 250,
                                          allowEditing: true,
                                          label: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            alignment: Alignment.center,
                                            child: Text('RESPONSIBILITY',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: rowTextColor,
                                                )),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'reference',
                                          allowEditing: true,
                                          width: 250,
                                          label: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            alignment: Alignment.center,
                                            child: Text('DOCUMENT REFERENCE',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: rowTextColor)),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'observation',
                                          allowEditing: true,
                                          width: 200,
                                          label: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            alignment: Alignment.center,
                                            child: Text('OBSERVATION',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: rowTextColor)),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'Upload',
                                          allowEditing: false,
                                          visible: true,
                                          width: 150,
                                          label: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            alignment: Alignment.center,
                                            child: Text('Upload',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: rowTextColor)),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'View',
                                          allowEditing: true,
                                          width: 150,
                                          label: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            alignment: Alignment.center,
                                            child: Text('View',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: rowTextColor)),
                                          ),
                                        ),
                                        // GridColumn(
                                        //   columnName: 'Delete',
                                        //   autoFitPadding:
                                        //       const EdgeInsets.symmetric(
                                        //           horizontal: 16),
                                        //   allowEditing: false,
                                        //   visible: true,
                                        //   width: 120,
                                        //   label: Container(
                                        //     padding: const EdgeInsets.symmetric(
                                        //         horizontal: 8.0),
                                        //     alignment: Alignment.center,
                                        //     child: Text('Delete Row',
                                        //         overflow:
                                        //             TextOverflow.values.first,
                                        //         style: TextStyle(
                                        //             fontWeight: FontWeight.bold,
                                        //             fontSize: 16,
                                        //             color: white)
                                        //         //    textAlign: TextAlign.center,
                                        //         ),
                                        //   ),
                                        // ),
                                      ],

                                      // stackedHeaderRows: [
                                      //   StackedHeaderRow(cells: [
                                      //     StackedHeaderCell(
                                      //         columnNames: ['SrNo'],
                                      //         child: Container(child: Text('Project')))
                                      //   ])
                                      // ],
                                    ),
                                  )
                                : Center(
                                    child: Container(
                                      padding: EdgeInsets.all(25),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(color: blue)),
                                      child: const Text(
                                        '     No data available yet \n Please wait for admin process',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  );
                          } else if (snapshot.hasData) {
                            return SfDataGridTheme(
                              data: SfDataGridThemeData(
                                  headerColor: white, gridLineColor: blue),
                              child: SfDataGrid(
                                source: _selectedIndex == 0
                                    ? _qualityPSSDataSource
                                    : _selectedIndex == 1
                                        ? _qualityrmuDataSource
                                        : _selectedIndex == 2
                                            ? _qualityctDataSource
                                            : _selectedIndex == 3
                                                ? _qualitycmuDataSource
                                                : _selectedIndex == 4
                                                    ? _qualityacdDataSource
                                                    : _selectedIndex == 5
                                                        ? _qualityCIDataSource
                                                        : _selectedIndex == 6
                                                            ? _qualityCDIDataSource
                                                            : _selectedIndex ==
                                                                    7
                                                                ? _qualityMSPDataSource
                                                                : _selectedIndex ==
                                                                        8
                                                                    ? _qualityChargerDataSource
                                                                    : _qualityEPDataSource,

                                allowEditing: true,
                                frozenColumnsCount: 2,
                                gridLinesVisibility: GridLinesVisibility.both,
                                headerGridLinesVisibility:
                                    GridLinesVisibility.both,
                                selectionMode: SelectionMode.single,
                                navigationMode: GridNavigationMode.cell,
                                rowHeight: 50,
                                headerRowHeight: 50,
                                columnWidthMode: ColumnWidthMode.auto,
                                editingGestureType: EditingGestureType.tap,
                                controller: _dataGridController,

                                // onQueryRowHeight: (details) {
                                //   return details.rowIndex == 0 ? 60.0 : 49.0;
                                // },
                                columns: [
                                  GridColumn(
                                    columnName: 'srNo',
                                    width: 80,
                                    allowEditing: false,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Sr No',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: rowTextColor)),
                                    ),
                                  ),
                                  GridColumn(
                                    width: 350,
                                    columnName: 'checklist',
                                    allowEditing: false,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('ACTIVITY',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: rowTextColor)),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'responsibility',
                                    width: 250,
                                    allowEditing: true,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('RESPONSIBILITY',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: rowTextColor,
                                          )),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'reference',
                                    allowEditing: true,
                                    width: 250,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('DOCUMENT REFERENCE',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: rowTextColor)),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'observation',
                                    allowEditing: true,
                                    width: 200,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('OBSERVATION',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: rowTextColor)),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Upload',
                                    allowEditing: false,
                                    visible: true,
                                    width: 150,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Upload.',
                                        overflow: TextOverflow.values.first,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: rowTextColor),
                                      ),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'View',
                                    allowEditing: true,
                                    width: 150,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        'View',
                                        overflow: TextOverflow.values.first,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: rowTextColor),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            // here w3e have to put Nodata page
                            return LoadingPage();
                          }
                        },
                      ),
                    ),
                  ],
                );
              } else {
                return LoadingPage();
              }
            },
          );
  }

  Future<void> setBoolean() async {
    List<bool> tempList = [];
    for (int i = 0; i < tabForElec.length; i++) {
      tempList.add(false);
    }
    electricalBoolList = tempList;
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != currentDate) {
      checkTable = true;
      currentDate = picked;
      selectedDate = DateFormat.yMMMMd().format(currentDate);
      getControllersData();
      getTableData();
    }
  }

  Future<void> getControllersData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('ElectricalChecklistField')
        .doc(widget.depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForElec[_selectedIndex!])
        .doc(selectedDate)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> controllerData =
          documentSnapshot.data() as Map<String, dynamic>;

      employeeNameController.text = controllerData['employeeName'] ?? '';
      olaNumberController.text = controllerData['olaNumber'] ?? '';
      docNoController.text = controllerData['docNo'] ?? '';
      dateController.text = controllerData['date'] ?? '';
      panelSrController.text = controllerData['panelNumber'] ?? '';
      vendorNoController.text = controllerData['vendor'] ?? '';
      customerNameController.text = controllerData['customerName'] ?? '';
      depotNameController.text = controllerData['depotName'] ?? '';

      print('Data - $controllerData');
    } else {
      employeeNameController.clear();
      olaNumberController.clear();
      docNoController.clear();
      dateController.clear();
      panelSrController.clear();
      vendorNoController.clear();
      customerNameController.clear();
      depotNameController.clear();
    }
  }

  Future<void> getTableData() async {
    data.clear();
    if (_isloading == false) {
      setState(() {
        _isloading = true;
      });
    }

    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('ElectricalQualityChecklist')
        .doc(widget.depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForElec[_selectedIndex!])
        .doc(selectedDate)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> tempData =
          documentSnapshot.data() as Map<String, dynamic>;

      List<dynamic> mapData = tempData['data'];

      data = mapData.map((map) => QualitychecklistModel.fromJson(map)).toList();
      checkTable = false;
    }

    if (_selectedIndex == 0) {
      qualitylisttable1 = checkTable ? getData() : data;
      _qualityPSSDataSource = QualityPSSDataSource(
          qualitylisttable1, widget.cityName!, widget.depoName!);
      _dataGridController = DataGridController();
      checkTable = true;
    } else if (_selectedIndex == 1) {
      qualitylisttable2 = checkTable ? rmu_getData() : data;
      _qualityrmuDataSource = QualityrmuDataSource(
          qualitylisttable2, widget.cityName!, widget.depoName!);
      _dataGridController = DataGridController();
      checkTable = true;
    } else if (_selectedIndex == 2) {
      qualitylisttable3 = checkTable ? ct_getData() : data;
      _qualityctDataSource = QualityctDataSource(
          qualitylisttable3, widget.cityName!, widget.depoName!);
      _dataGridController = DataGridController();
      checkTable = true;
    } else if (_selectedIndex == 3) {
      qualitylisttable4 = checkTable ? cmu_getData() : data;
      _qualitycmuDataSource = QualitycmuDataSource(
          qualitylisttable4, widget.cityName!, widget.depoName!);
      _dataGridController = DataGridController();
      checkTable = true;
    } else if (_selectedIndex == 4) {
      qualitylisttable5 = checkTable ? acdb_getData() : data;
      _qualityacdDataSource = QualityacdDataSource(
          qualitylisttable5, widget.cityName!, widget.depoName!);
      _dataGridController = DataGridController();
      checkTable = true;
    } else if (_selectedIndex == 5) {
      qualitylisttable6 = checkTable ? ci_getData() : data;
      _qualityCIDataSource = QualityCIDataSource(
          qualitylisttable6, widget.cityName!, widget.depoName!);
      _dataGridController = DataGridController();
      checkTable = true;
    } else if (_selectedIndex == 6) {
      qualitylisttable7 = checkTable ? cdi_getData() : data;
      _qualityCDIDataSource = QualityCDIDataSource(
          qualitylisttable7, widget.cityName!, widget.depoName!);
      _dataGridController = DataGridController();
      checkTable = true;
    } else if (_selectedIndex == 7) {
      qualitylisttable8 = checkTable ? msp_getData() : data;
      _qualityMSPDataSource = QualityMSPDataSource(
          qualitylisttable8, widget.cityName!, widget.depoName!);
      _dataGridController = DataGridController();
      checkTable = true;
    } else if (_selectedIndex == 8) {
      qualitylisttable9 = checkTable ? charger_getData() : data;
      _qualityChargerDataSource = QualityChargerDataSource(
          qualitylisttable9, widget.cityName!, widget.depoName!);
      _dataGridController = DataGridController();
      checkTable = true;
    } else if (_selectedIndex == 9) {
      qualitylisttable10 = checkTable ? earth_pit_getData() : data;
      _qualityEPDataSource = QualityEPDataSource(
          qualitylisttable10, widget.cityName!, widget.depoName!);
      _dataGridController = DataGridController();
      checkTable = true;
    }

    _isloading = false;
    setState(() {});
  }

  Future<List<int>> _generateElectricalPdf() async {
    await pr!.show();
    final headerStyle =
        pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold);

    final fontData1 = await rootBundle.load('fonts/IBMPlexSans-Medium.ttf');
    final fontData2 = await rootBundle.load('fonts/IBMPlexSans-Bold.ttf');

    const cellStyle = pw.TextStyle(
      color: PdfColors.black,
      fontSize: 14,
    );

    final profileImage = pw.MemoryImage(
      (await rootBundle.load('assets/Tata-Power.jpeg')).buffer.asUint8List(),
    );

    List<List<dynamic>> fieldData = [
      ['Employee Name :', employeeNameController.text],
      ['OLA Number :', olaNumberController.text],
      ['Doc No. :', docNoController.text],
      ['Panel Sr.No. : ', panelSrController.text],
      ['Vendor Name :', vendorNoController.text],
      ['Depot Name :', depotNameController.text],
      ['Date :', dateController.text],
      ['Customer Name :', customerNameController.text],
    ];

    List<pw.TableRow> rows = [];

    rows.add(pw.TableRow(children: [
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Sr No',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding:
              const pw.EdgeInsets.only(top: 4, bottom: 4, left: 2, right: 2),
          child: pw.Center(
              child: pw.Text('Activity',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Responsibility',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Document Reference',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Observation',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Image1',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Image2',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Image3',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
    ]));

    if (data.isNotEmpty) {
      List<pw.Widget> imageUrls = [];

      for (QualitychecklistModel mapData in data) {
        String imagesPath =
            'QualityChecklist/Electrical_Engineer/${widget.cityName}/${widget.depoName}/$userId/${tabForElec[_selectedIndex!]} Table/$date/${mapData.srNo}';

        ListResult result =
            await FirebaseStorage.instance.ref().child(imagesPath).listAll();

        if (result.items.isNotEmpty) {
          for (var image in result.items) {
            String downloadUrl = await image.getDownloadURL();
            if (image.name.endsWith('.pdf')) {
              imageUrls.add(
                pw.Container(
                    width: 60,
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: pw.UrlLink(
                        child: pw.Text(image.name,
                            style: const pw.TextStyle(color: PdfColors.blue)),
                        destination: downloadUrl)),
              );
            } else {
              final myImage = await networkImage(downloadUrl);
              imageUrls.add(
                pw.Container(
                    padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                    width: 60,
                    height: 100,
                    child: pw.Center(
                      child: pw.Image(myImage),
                    )),
              );
            }
          }
          if (imageUrls.length < 3) {
            int imageLoop = 3 - imageUrls.length;
            for (int i = 0; i < imageLoop; i++) {
              imageUrls.add(
                pw.Container(
                    padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                    width: 60,
                    height: 100,
                    child: pw.Text('')),
              );
            }
          } else {
            if (imageUrls.length > 3) {
              int imageLoop = 11 - imageUrls.length;
              for (int i = 0; i < imageLoop; i++) {
                imageUrls.add(
                  pw.Container(
                      padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                      width: 60,
                      height: 100,
                      child: pw.Text('')),
                );
              }
            }
          }
        } else {
          int imageLoop = 3;
          for (int i = 0; i < imageLoop; i++) {
            imageUrls.add(
              pw.Container(
                  padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                  width: 60,
                  height: 100,
                  child: pw.Text('')),
            );
          }
        }

        result.items.clear();

        //Text Rows of PDF Table
        rows.add(pw.TableRow(children: [
          pw.Container(
              padding: const pw.EdgeInsets.all(3.0),
              child: pw.Center(
                  child: pw.Text(mapData.srNo.toString(),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 14)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData.checklist,
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 14)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData.responsibility,
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 14)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData.reference.toString(),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 14)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData.observation.toString(),
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 14)))),
          imageUrls[0],
          imageUrls[1],
          imageUrls[2]
        ]));

        if (imageUrls.length - 3 > 0) {
          //Image Rows of PDF Table
          rows.add(pw.TableRow(children: [
            pw.Container(
                padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                child: pw.Text('')),
            pw.Container(
                padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                width: 60,
                height: 100,
                child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                    children: [
                      imageUrls[3],
                      imageUrls[4],
                    ])),
            imageUrls[5],
            imageUrls[6],
            imageUrls[7],
            imageUrls[8],
            imageUrls[9],
            imageUrls[10],
          ]));
        }
        imageUrls.clear();
      }
    }

    final pdf = pw.Document(
      pageMode: PdfPageMode.outlines,
    );

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(
            base: pw.Font.ttf(fontData1), bold: pw.Font.ttf(fontData2)),
        pageFormat: const PdfPageFormat(1300, 900,
            marginLeft: 70, marginRight: 70, marginBottom: 80, marginTop: 40),
        orientation: pw.PageOrientation.natural,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(
                  border: pw.Border(
                      bottom:
                          pw.BorderSide(width: 0.5, color: PdfColors.grey))),
              child: pw.Column(children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                          'Electrical Quality Report / ${tabForElec[_selectedIndex!]} Table',
                          textScaleFactor: 2,
                          style: const pw.TextStyle(color: PdfColors.blue700)),
                      pw.SizedBox(width: 20),
                      pw.Container(
                        width: 120,
                        height: 120,
                        child: pw.Image(profileImage),
                      ),
                    ]),
              ]));
        },
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text('User ID - $userId',
                  // 'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.black)));
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Column(children: [
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    const pw.TextSpan(
                        text: 'Place : ',
                        style:
                            pw.TextStyle(color: PdfColors.black, fontSize: 17)),
                    pw.TextSpan(
                        text: '${widget.cityName} / ${widget.depoName}',
                        style: const pw.TextStyle(
                            color: PdfColors.blue700, fontSize: 15))
                  ])),
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    const pw.TextSpan(
                        text: 'Date : ',
                        style:
                            pw.TextStyle(color: PdfColors.black, fontSize: 17)),
                    pw.TextSpan(
                        text: date,
                        style: const pw.TextStyle(
                            color: PdfColors.blue700, fontSize: 15))
                  ])),
                  pw.RichText(
                      text: pw.TextSpan(children: [
                    pw.TextSpan(
                        text: 'UserID : $userId',
                        style: const pw.TextStyle(
                            color: PdfColors.blue700, fontSize: 15)),
                  ])),
                ]),
            pw.SizedBox(height: 20)
          ]),
          pw.SizedBox(height: 10),
          pw.Table.fromTextArray(
            columnWidths: {
              0: const pw.FixedColumnWidth(100),
              1: const pw.FixedColumnWidth(100),
            },
            headers: ['Details', 'Values'],
            headerStyle: headerStyle,
            headerPadding: const pw.EdgeInsets.all(10.0),
            data: fieldData,
            cellHeight: 35,
            cellStyle: cellStyle,
          )
        ],
      ),
    );

    //First Half Page

    pdf.addPage(
      pw.MultiPage(
        theme: pw.ThemeData.withFont(
            base: pw.Font.ttf(fontData1), bold: pw.Font.ttf(fontData2)),
        pageFormat: const PdfPageFormat(1300, 900,
            marginLeft: 70, marginRight: 70, marginBottom: 80, marginTop: 40),
        orientation: pw.PageOrientation.natural,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(
                  border: pw.Border(
                      bottom:
                          pw.BorderSide(width: 0.5, color: PdfColors.grey))),
              child: pw.Column(children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                          'Electrical Quality Report / ${tabForElec[_selectedIndex!]} Table',
                          textScaleFactor: 2,
                          style: const pw.TextStyle(color: PdfColors.blue700)),
                      pw.Container(
                        width: 120,
                        height: 120,
                        child: pw.Image(profileImage),
                      ),
                    ]),
              ]));
        },
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text('User ID - $userId',
                  // 'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.black)));
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Column(children: [
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Place:  ${widget.cityName}/${widget.depoName}',
                    textScaleFactor: 1.6,
                  ),
                  pw.Text(
                    'Date:  $date ',
                    textScaleFactor: 1.6,
                  )
                ]),
            pw.SizedBox(height: 20)
          ]),
          pw.SizedBox(height: 10),
          pw.Table(
              columnWidths: {
                0: const pw.FixedColumnWidth(30),
                1: const pw.FixedColumnWidth(160),
                2: const pw.FixedColumnWidth(70),
                3: const pw.FixedColumnWidth(70),
                4: const pw.FixedColumnWidth(70),
                5: const pw.FixedColumnWidth(70),
                6: const pw.FixedColumnWidth(70),
                7: const pw.FixedColumnWidth(70),
              },
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              tableWidth: pw.TableWidth.max,
              border: pw.TableBorder.all(),
              children: rows)
        ],
      ),
    );

    final List<int> pdfData = await pdf.save();
    final String pdfPath =
        'ElectricalQualityReport_${tabForElec[_selectedIndex!]}($userId/$date).pdf';

    // Save the PDF file to device storage
    if (kIsWeb) {
      html.AnchorElement(
          href: "data:application/octet-stream;base64,${base64Encode(pdfData)}")
        ..setAttribute("download", pdfPath)
        ..click();
    } else {
      const Text('Sorry it is not ready for mobile platform');
    }
    pr!.hide();

    return pdfData;
  }
}

storeData(BuildContext context, String depoName, String currentDate,
    List<bool> isTabSelected) {
  Map<String, dynamic> pssTableData = Map();
  Map<String, dynamic> rmuTableData = Map();
  Map<String, dynamic> ctTableData = Map();
  Map<String, dynamic> cmuTableData = Map();
  Map<String, dynamic> acdbTableData = Map();
  Map<String, dynamic> ciTableData = Map();
  Map<String, dynamic> cdiTableData = Map();
  Map<String, dynamic> mspTableData = Map();
  Map<String, dynamic> chargerTableData = Map();
  Map<String, dynamic> epTableData = Map();

  if (isTabSelected[0]) {
    for (var i in _qualityPSSDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName == 'View' ||
            data.columnName != 'Delete') {
          pssTableData[data.columnName] = data.value;
        }
      }

      psstabledatalist.add(pssTableData);
      pssTableData = {};
    }

    FirebaseFirestore.instance
        .collection('ElectricalQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForElec[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': psstabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'ElectricalQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'ElectricalChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    psstabledatalist.clear();

    FirebaseFirestore.instance
        .collection('ElectricalChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});

    FirebaseFirestore.instance
        .collection('ElectricalQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'userId': userId});

    FirebaseFirestore.instance
        .collection('ElectricalChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForElec[_selectedIndex!])
        .doc(currentDate)
        .set({
      'employeeName': employeeNameController.text,
      'olaNumber': olaNumberController.text,
      'docNo': docNoController.text,
      'panelNumber': panelSrController.text,
      'vendor': vendorNoController.text,
      'depotName': depotNameController.text,
      'date': dateController.text,
      'customerName': customerNameController.text
    });
  }

  if (isTabSelected[1]) {
    psstabledatalist.clear();
    for (var i in _qualityrmuDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName == 'View' ||
            data.columnName != 'Delete') {
          rmuTableData[data.columnName] = data.value;
        }
      }
      rmutabledatalist.add(rmuTableData);
      rmuTableData = {};
    }

    FirebaseFirestore.instance
        .collection('ElectricalQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForElec[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': rmutabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'ElectricalQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'ElectricalChecklistField', depoName, 'userId', userId);
      eptabledatalist.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    rmutabledatalist.clear();

    FirebaseFirestore.instance
        .collection('ElectricalChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});

    FirebaseFirestore.instance
        .collection('ElectricalQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'userId': userId});

    FirebaseFirestore.instance
        .collection('ElectricalChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForElec[_selectedIndex!])
        .doc(currentDate)
        .set({
      'employeeName': employeeNameController.text,
      'olaNumber': olaNumberController.text,
      'docNo': docNoController.text,
      'panelNumber': panelSrController.text,
      'vendor': vendorNoController.text,
      'depotName': depotNameController.text,
      'date': dateController.text,
      'customerName': customerNameController.text
    });
  } else if (isTabSelected[2]) {
    rmutabledatalist.clear();
    for (var i in _qualityctDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName == 'View' ||
            data.columnName != 'Delete') {
          ctTableData[data.columnName] = data.value;
        }
      }

      cttabledatalist.add(ctTableData);
      ctTableData = {};
    }

    FirebaseFirestore.instance
        .collection('ElectricalQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForElec[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': cttabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'ElectricalQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'ElectricalChecklistField', depoName, 'userId', userId);
      eptabledatalist.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    cttabledatalist.clear();

    FirebaseFirestore.instance
        .collection('ElectricalChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});

    FirebaseFirestore.instance
        .collection('ElectricalQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'userId': userId});

    FirebaseFirestore.instance
        .collection('ElectricalChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForElec[_selectedIndex!])
        .doc(currentDate)
        .set({
      'employeeName': employeeNameController.text,
      'olaNumber': olaNumberController.text,
      'docNo': docNoController.text,
      'panelNumber': panelSrController.text,
      'vendor': vendorNoController.text,
      'depotName': depotNameController.text,
      'date': dateController.text,
      'customerName': customerNameController.text
    });
  } else if (isTabSelected[3]) {
    cttabledatalist.clear();
    for (var i in _qualitycmuDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName == 'View' ||
            data.columnName != 'Delete') {
          cmuTableData[data.columnName] = data.value;
        }
      }
      cmutabledatalist.add(cmuTableData);
      cmuTableData = {};
    }

    FirebaseFirestore.instance
        .collection('ElectricalQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForElec[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': cmutabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'ElectricalQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'ElectricalChecklistField', depoName, 'userId', userId);
      eptabledatalist.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    cmutabledatalist.clear();

    FirebaseFirestore.instance
        .collection('ElectricalChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});

    FirebaseFirestore.instance
        .collection('ElectricalQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'userId': userId});

    FirebaseFirestore.instance
        .collection('ElectricalChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForElec[_selectedIndex!])
        .doc(currentDate)
        .set({
      'employeeName': employeeNameController.text,
      'olaNumber': olaNumberController.text,
      'docNo': docNoController.text,
      'panelNumber': panelSrController.text,
      'vendor': vendorNoController.text,
      'depotName': depotNameController.text,
      'date': dateController.text,
      'customerName': customerNameController.text
    });
  } else if (isTabSelected[4]) {
    for (var i in _qualityacdDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' || data.columnName != 'Delete') {
          acdbTableData[data.columnName] = data.value;
        }
      }
      acdbtabledatalist.add(acdbTableData);
      acdbTableData = {};
    }
    FirebaseFirestore.instance
        .collection('ElectricalQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForElec[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': acdbtabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'ElectricalQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'ElectricalChecklistField', depoName, 'userId', userId);
      eptabledatalist.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    acdbtabledatalist.clear();

    FirebaseFirestore.instance
        .collection('ElectricalChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});

    FirebaseFirestore.instance
        .collection('ElectricalQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'userId': userId});

    FirebaseFirestore.instance
        .collection('ElectricalChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForElec[_selectedIndex!])
        .doc(currentDate)
        .set({
      'employeeName': employeeNameController.text,
      'olaNumber': olaNumberController.text,
      'docNo': docNoController.text,
      'panelNumber': panelSrController.text,
      'vendor': vendorNoController.text,
      'depotName': depotNameController.text,
      'date': dateController.text,
      'customerName': customerNameController.text
    });
  } else if (isTabSelected[5]) {
    for (var i in _qualityCIDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName == 'View' ||
            data.columnName != 'Delete') {
          ciTableData[data.columnName] = data.value;
        }
      }
      citabledatalist.add(ciTableData);
      ciTableData = {};
    }
    FirebaseFirestore.instance
        .collection('ElectricalQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForElec[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': citabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'ElectricalQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'ElectricalChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    citabledatalist.clear();

    FirebaseFirestore.instance
        .collection('ElectricalChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});

    FirebaseFirestore.instance
        .collection('ElectricalQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'userId': userId});

    FirebaseFirestore.instance
        .collection('ElectricalChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForElec[_selectedIndex!])
        .doc(currentDate)
        .set({
      'employeeName': employeeNameController.text,
      'olaNumber': olaNumberController.text,
      'docNo': docNoController.text,
      'panelNumber': panelSrController.text,
      'vendor': vendorNoController.text,
      'depotName': depotNameController.text,
      'date': dateController.text,
      'customerName': customerNameController.text
    });
  } else if (isTabSelected[6]) {
    citabledatalist.clear();
    for (var i in _qualityCDIDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName == 'View' ||
            data.columnName != 'Delete') {
          cdiTableData[data.columnName] = data.value;
        }
      }
      cditabledatalist.add(cdiTableData);
      cdiTableData = {};
    }
    FirebaseFirestore.instance
        .collection('ElectricalQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForElec[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': cditabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'ElectricalQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'ElectricalChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    cditabledatalist.clear();
  } else if (isTabSelected[7]) {
    cditabledatalist.clear();
    for (var i in _qualityMSPDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName == 'View' ||
            data.columnName != 'Delete') {
          mspTableData[data.columnName] = data.value;
        }
      }
      msptabledatalist.add(mspTableData);
      mspTableData = {};
    }

    FirebaseFirestore.instance
        .collection('ElectricalQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForElec[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': msptabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'ElectricalQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'ElectricalChecklistField', depoName, 'userId', userId);
      eptabledatalist.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    msptabledatalist.clear();

    FirebaseFirestore.instance
        .collection('ElectricalChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});

    FirebaseFirestore.instance
        .collection('ElectricalQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'userId': userId});

    FirebaseFirestore.instance
        .collection('ElectricalChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForElec[_selectedIndex!])
        .doc(currentDate)
        .set({
      'employeeName': employeeNameController.text,
      'olaNumber': olaNumberController.text,
      'docNo': docNoController.text,
      'panelNumber': panelSrController.text,
      'vendor': vendorNoController.text,
      'depotName': depotNameController.text,
      'date': dateController.text,
      'customerName': customerNameController.text
    });
  } else if (isTabSelected[8]) {
    msptabledatalist.clear();
    for (var i in _qualityChargerDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName == 'View' ||
            data.columnName != 'Delete') {
          chargerTableData[data.columnName] = data.value;
        }
      }
      chargertabledatalist.add(chargerTableData);
      chargerTableData = {};
    }
    FirebaseFirestore.instance
        .collection('ElectricalQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForElec[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': chargertabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'ElectricalQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'ElectricalChecklistField', depoName, 'userId', userId);
      eptabledatalist.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    chargertabledatalist.clear();

    FirebaseFirestore.instance
        .collection('ElectricalChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});

    FirebaseFirestore.instance
        .collection('ElectricalQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'userId': userId});

    FirebaseFirestore.instance
        .collection('ElectricalChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForElec[_selectedIndex!])
        .doc(currentDate)
        .set({
      'employeeName': employeeNameController.text,
      'olaNumber': olaNumberController.text,
      'docNo': docNoController.text,
      'panelNumber': panelSrController.text,
      'vendor': vendorNoController.text,
      'depotName': depotNameController.text,
      'date': dateController.text,
      'customerName': customerNameController.text
    });
  } else if (isTabSelected[9]) {
    chargertabledatalist.clear();
    for (var i in _qualityEPDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName == 'View' ||
            data.columnName != 'Delete') {
          epTableData[data.columnName] = data.value;
        }
      }
      eptabledatalist.add(epTableData);
      epTableData = {};
    }
    FirebaseFirestore.instance
        .collection('ElectricalQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForElec[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': eptabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'ElectricalQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'ElectricalChecklistField', depoName, 'userId', userId);
      eptabledatalist.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    eptabledatalist.clear();

    FirebaseFirestore.instance
        .collection('ElectricalChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});

    FirebaseFirestore.instance
        .collection('ElectricalQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'userId': userId});

    FirebaseFirestore.instance
        .collection('ElectricalChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForElec[_selectedIndex!])
        .doc(currentDate)
        .set({
      'employeeName': employeeNameController.text,
      'olaNumber': olaNumberController.text,
      'docNo': docNoController.text,
      'panelNumber': panelSrController.text,
      'vendor': vendorNoController.text,
      'depotName': depotNameController.text,
      'date': dateController.text,
      'customerName': customerNameController.text
    });
  }
}
