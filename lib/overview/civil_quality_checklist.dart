import 'package:assingment/Planning_Pages/quality_checklist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../QualityDatasource/qualityCivilDatasource/quality_Ironite_flooring.dart';
import '../QualityDatasource/qualityCivilDatasource/quality_backfilling.dart';
import '../QualityDatasource/qualityCivilDatasource/quality_ceiling.dart';
import '../QualityDatasource/qualityCivilDatasource/quality_excavation.dart';
import '../QualityDatasource/qualityCivilDatasource/quality_flooring.dart';
import '../QualityDatasource/qualityCivilDatasource/quality_glazzing.dart';
import '../QualityDatasource/qualityCivilDatasource/quality_inspection.dart';
import '../QualityDatasource/qualityCivilDatasource/quality_massonary.dart';
import '../QualityDatasource/qualityCivilDatasource/quality_painting.dart';
import '../QualityDatasource/qualityCivilDatasource/quality_paving.dart';
import '../QualityDatasource/qualityCivilDatasource/quality_proofing.dart';
import '../QualityDatasource/qualityCivilDatasource/quality_roofing.dart';
import '../components/loading_page.dart';
import '../model/quality_checklistModel.dart';
import '../widget/quality_list.dart';
import '../widget/style.dart';

List<dynamic> excavationtabledatalist = [];
List<dynamic> backfillingtabledatalist = [];
List<dynamic> massonarytabledatalist = [];
List<dynamic> doorstabledatalist = [];
List<dynamic> ceillingtabledatalist = [];
List<dynamic> flooringtabledatalist = [];
List<dynamic> inspectiontabledatalist = [];
List<dynamic> inronitetabledatalist = [];
List<dynamic> paintingtabledatalist = [];
List<dynamic> pavingtabledatalist = [];
List<dynamic> roofingtabledatalist = [];
List<dynamic> proofingtabledatalist = [];

late QualityExcavationDataSource _qualityExcavationDataSource;
late QualityBackFillingDataSource _qualityBackFillingDataSource;
late QualityMassonaryDataSource _qualityMassonaryDataSource;
late QualityGlazzingDataSource _qualityGlazzingDataSource;
late QualityCeillingDataSource _qualityCeillingDataSource;
late QualityIroniteflooringDataSource _qualityIroniteflooringDataSource;
late QualityflooringDataSource _qualityflooringDataSource;
late QualityInspectionDataSource _qualityInspectionDataSource;
late QualityPaintingDataSource _qualityPaintingDataSource;
late QualityPavingDataSource _qualityPavingDataSource;
late QualityRoofingDataSource _qualityRoofingDataSource;
late QualityProofingDataSource _qualityProofingDataSource;

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

class CivilQualityChecklist extends StatefulWidget {
  String? cityName;
  String? depoName;
  String? currentDate;
  bool? isHeader;

  CivilQualityChecklist(
      {super.key,
      required this.cityName,
      required this.depoName,
      this.currentDate,
      this.isHeader = true});

  @override
  State<CivilQualityChecklist> createState() => _CivilQualityChecklistState();
}

class _CivilQualityChecklistState extends State<CivilQualityChecklist> {
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
  late DataGridController _dataGridController;
  bool _isloading = true;
  int? _selectedIndex = 0;

  @override
  void initState() {
    print('Hello Worlds');
    super.initState();

    qualitylisttable1 = excavation_getData();
    _qualityExcavationDataSource = QualityExcavationDataSource(
        qualitylisttable1, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();

    qualitylisttable2 = backfilling_getData();
    _qualityBackFillingDataSource = QualityBackFillingDataSource(
        qualitylisttable2, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();

    qualitylisttable3 = massonary_getData();
    _qualityMassonaryDataSource = QualityMassonaryDataSource(
        qualitylisttable3, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();

    qualitylisttable4 = glazzing_getData();
    _qualityGlazzingDataSource = QualityGlazzingDataSource(
        qualitylisttable4, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();

    qualitylisttable5 = ceilling_getData();
    _qualityCeillingDataSource = QualityCeillingDataSource(
        qualitylisttable5, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();

    qualitylisttable6 = florring_getData();
    _qualityflooringDataSource = QualityflooringDataSource(
        qualitylisttable6, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();

    qualitylisttable7 = inspection_getData();
    _qualityInspectionDataSource = QualityInspectionDataSource(
        qualitylisttable7, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();

    qualitylisttable8 = ironite_florring_getData();
    _qualityIroniteflooringDataSource = QualityIroniteflooringDataSource(
        qualitylisttable8, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();

    qualitylisttable9 = painting_getData();
    _qualityPaintingDataSource = QualityPaintingDataSource(
        qualitylisttable9, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();

    qualitylisttable10 = paving_getData();
    _qualityPavingDataSource = QualityPavingDataSource(
        qualitylisttable10, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();

    qualitylisttable11 = roofing_getData();
    _qualityRoofingDataSource = QualityRoofingDataSource(
        qualitylisttable11, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();

    qualitylisttable12 = proofing_getData();
    _qualityProofingDataSource = QualityProofingDataSource(
        qualitylisttable12, widget.depoName!, widget.cityName!);
    _dataGridController = DataGridController();

    _isloading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 12,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 20,
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
              onTap: (value) {
                _selectedIndex = value;
                setState(() {});
              },
              tabs: const [
                Tab(text: "Exc"),
                Tab(text: "B.F"),
                Tab(text: "Mass"),
                Tab(text: "D.W.G"),
                Tab(text: "F.C"),
                Tab(text: "F&T"),
                Tab(text: "G.I"),
                Tab(text: "I.F"),
                Tab(text: "Painting"),
                Tab(text: "Paving"),
                Tab(text: "WC&R"),
                Tab(text: "Proofing"),
              ],
            ),
          ),
          body: TabBarView(children: [
            civilupperScreen(),
            civilupperScreen(),
            civilupperScreen(),
            civilupperScreen(),
            civilupperScreen(),
            civilupperScreen(),
            civilupperScreen(),
            civilupperScreen(),
            civilupperScreen(),
            civilupperScreen(),
            civilupperScreen(),
            civilupperScreen(),
          ]),
        ));
  }

  civilupperScreen() {
    return _isloading
        ? LoadingPage()
        : StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('CivilQualityChecklistCollection')
                .doc('${widget.depoName}')
                .collection('userId')
                .doc(widget.currentDate)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      height: 80,
                      decoration: BoxDecoration(color: lightblue),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset('assets/Tata-Power.jpeg',
                                  height: 50, width: 100),
                              const Text('TATA POWER'),
                            ],
                          ),
                          Text(
                            civil_title[int.parse(_selectedIndex.toString())],
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const Text('TPCL /DIST/EV/CHECKLIST ')
                        ],
                      ),
                    ),
                    Container(
                        decoration: BoxDecoration(color: lightblue),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  color: lightblue,
                                  width: 600,
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: 150,
                                          child: Text(
                                            'Project',
                                          )),
                                      const SizedBox(width: 5),
                                      Expanded(
                                          child: Container(
                                              height: 30,
                                              child: widget.isHeader!
                                                  ? TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 0,
                                                                      bottom: 0,
                                                                      left: 5)),
                                                      initialValue: snapshot
                                                              .data!
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'EmployeeName')
                                                          ? snapshot.data!.get(
                                                              'EmployeeName')
                                                          : '',
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                      onChanged: (value) {
                                                        empName = value;
                                                      },
                                                      onSaved: (newValue) {
                                                        empName =
                                                            newValue.toString();
                                                      },
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
                                                            : '',
                                                      )))),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: lightblue,
                                  width: 600,
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: 150,
                                          child: Text(
                                            'Location',
                                          )),
                                      SizedBox(width: 5),
                                      Expanded(
                                          child: Container(
                                              height: 30,
                                              child: widget.isHeader!
                                                  ? TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 0,
                                                                      bottom: 0,
                                                                      left: 5)),
                                                      initialValue: snapshot
                                                              .data!
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'Dist EV')
                                                          ? snapshot.data!.get(
                                                                  'Dist EV') ??
                                                              ''
                                                          : '',
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                      onChanged: (value) {
                                                        distev = value;
                                                      },
                                                      onSaved: (newValue) {
                                                        distev =
                                                            newValue.toString();
                                                      },
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
                                                          : '')))),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: lightblue,
                                  width: 600,
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: 150,
                                          child: const Text(
                                            'Vendor / Sub Vendor',
                                          )),
                                      const SizedBox(width: 5),
                                      Expanded(
                                          child: Container(
                                              height: 30,
                                              child: widget.isHeader!
                                                  ? TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 0,
                                                                      bottom: 0,
                                                                      left: 5)),
                                                      initialValue: snapshot
                                                              .data!
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'VendorName')
                                                          ? snapshot.data!.get(
                                                                  'VendorName') ??
                                                              ''
                                                          : '',
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                      onChanged: (value) {
                                                        vendorname = value;
                                                      },
                                                      onSaved: (newValue) {
                                                        vendorname =
                                                            newValue.toString();
                                                      },
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
                                                          : '')))),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: lightblue,
                                  width: 600,
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: 150,
                                          child: Text(
                                            'Drawing No:',
                                          )),
                                      SizedBox(width: 5),
                                      Expanded(
                                          child: Container(
                                              height: 30,
                                              child: widget.isHeader!
                                                  ? TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 0,
                                                                      bottom: 0,
                                                                      left: 5)),
                                                      initialValue: snapshot
                                                              .data!
                                                              .data()
                                                              .toString()
                                                              .contains('Date')
                                                          ? snapshot.data!.get(
                                                                  'Date') ??
                                                              ''
                                                          : '',
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                      onChanged: (value) {
                                                        date = value;
                                                      },
                                                      onSaved: (newValue) {
                                                        date =
                                                            newValue.toString();
                                                      },
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
                                                            : '',
                                                      )))),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  color: lightblue,
                                  width: 600,
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: 150,
                                          child: Text(
                                            'Date',
                                          )),
                                      SizedBox(width: 5),
                                      Expanded(
                                          child: Container(
                                              height: 30,
                                              child: widget.isHeader!
                                                  ? TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 0,
                                                                      bottom: 0,
                                                                      left: 5)),
                                                      initialValue: snapshot
                                                              .data!
                                                              .data()
                                                              .toString()
                                                              .contains('OlaNo')
                                                          ? snapshot.data!.get(
                                                                  'OlaNo') ??
                                                              ''
                                                          : '',
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                      onChanged: (value) {
                                                        olano = value;
                                                      },
                                                      onSaved: (newValue) {
                                                        olano =
                                                            newValue.toString();
                                                      },
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
                                                          : '')))),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: lightblue,
                                  width: 600,
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: 150,
                                          child: Text(
                                            'Component of the Structure',
                                          )),
                                      SizedBox(width: 5),
                                      Expanded(
                                          child: Container(
                                              height: 30,
                                              child: widget.isHeader!
                                                  ? TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 0,
                                                                      bottom: 0,
                                                                      left: 5)),
                                                      initialValue: snapshot
                                                              .data!
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'PanelNo')
                                                          ? snapshot.data!.get(
                                                                  'PanelNo') ??
                                                              ''
                                                          : '',
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                      onChanged: (value) {
                                                        panel = value;
                                                      },
                                                      onSaved: (newValue) {
                                                        panel =
                                                            newValue.toString();
                                                      },
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
                                                            : '',
                                                      )))),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: lightblue,
                                  width: 600,
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: 150,
                                          child: Text(
                                            'Grid / Axis & Level',
                                          )),
                                      SizedBox(width: 5),
                                      Expanded(
                                          child: Container(
                                              height: 30,
                                              child: widget.isHeader!
                                                  ? TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 0,
                                                                      bottom: 0,
                                                                      left: 5)),
                                                      initialValue: snapshot
                                                              .data!
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'DepotName')
                                                          ? snapshot.data!.get(
                                                                  'DepotName') ??
                                                              ''
                                                          : '',
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                      onChanged: (value) {
                                                        depotname = value;
                                                      },
                                                      onSaved: (newValue) {
                                                        depotname =
                                                            newValue.toString();
                                                      },
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
                                                            : '',
                                                      )))),
                                    ],
                                  ),
                                ),
                                Container(
                                  color: lightblue,
                                  width: 600,
                                  padding: const EdgeInsets.all(3),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                          width: 150,
                                          child: Text(
                                            'Type of Filling',
                                          )),
                                      SizedBox(width: 5),
                                      Expanded(
                                          child: Container(
                                              height: 30,
                                              child: widget.isHeader!
                                                  ? TextFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              contentPadding:
                                                                  EdgeInsets.only(
                                                                      top: 0,
                                                                      bottom: 0,
                                                                      left: 5)),
                                                      initialValue: snapshot
                                                              .data!
                                                              .data()
                                                              .toString()
                                                              .contains(
                                                                  'CustomerName')
                                                          ? snapshot.data!.get(
                                                                  'CustomerName') ??
                                                              ''
                                                          : '',
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                      onChanged: (value) {
                                                        customername = value;
                                                      },
                                                      onSaved: (newValue) {
                                                        customername =
                                                            newValue.toString();
                                                      },
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
                                                            : '',
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
                                                                : _stream10,
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
                                          ? _qualityExcavationDataSource
                                          : _selectedIndex == 1
                                              ? _qualityBackFillingDataSource
                                              : _selectedIndex == 2
                                                  ? _qualityMassonaryDataSource
                                                  : _selectedIndex == 3
                                                      ? _qualityGlazzingDataSource
                                                      : _selectedIndex == 4
                                                          ? _qualityCeillingDataSource
                                                          : _selectedIndex == 5
                                                              ? _qualityflooringDataSource
                                                              : _selectedIndex ==
                                                                      6
                                                                  ? _qualityInspectionDataSource
                                                                  : _selectedIndex ==
                                                                          7
                                                                      ? _qualityIroniteflooringDataSource
                                                                      : _selectedIndex ==
                                                                              8
                                                                          ? _qualityPaintingDataSource
                                                                          : _selectedIndex == 9
                                                                              ? _qualityPavingDataSource
                                                                              : _qualityInspectionDataSource,
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
                                      columns: [
                                        GridColumn(
                                          columnName: 'srNo',
                                          width: 80,
                                          autoFitPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16),
                                          allowEditing: false,
                                          label: Container(
                                            alignment: Alignment.center,
                                            child: Text('Sr No',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: white)),
                                          ),
                                        ),
                                        GridColumn(
                                          width: 350,
                                          columnName: 'checklist',
                                          allowEditing: false,
                                          label: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                                'Checks(Before Start of Backfill Activity)',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: white)),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'responsibility',
                                          width: 250,
                                          allowEditing: true,
                                          label: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                                "Contractor’s Site Engineer",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color: white,
                                                )),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'reference',
                                          allowEditing: true,
                                          width: 250,
                                          label: Container(
                                            alignment: Alignment.center,
                                            child: Text("Owner’s Site Engineer",
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: white)),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'observation',
                                          allowEditing: true,
                                          width: 200,
                                          label: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                                "Observation Comments by  Owner’s Engineer",
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: white)),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'Upload',
                                          allowEditing: false,
                                          visible: true,
                                          width: 150,
                                          label: Container(
                                            alignment: Alignment.center,
                                            child: Text('Upload',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: white)),
                                          ),
                                        ),
                                        GridColumn(
                                          columnName: 'View',
                                          allowEditing: false,
                                          width: 150,
                                          label: Container(
                                            alignment: Alignment.center,
                                            child: Text('View',
                                                overflow:
                                                    TextOverflow.values.first,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: white)),
                                          ),
                                        ),
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
                            alldata = '';
                            alldata = snapshot.data['data'] as List<dynamic>;
                            qualitylisttable1.clear();
                            alldata.forEach((element) {
                              qualitylisttable1
                                  .add(QualitychecklistModel.fromJson(element));

                              //  else if (_selectedIndex == 10) {
                              //   _qualityRoofingDataSource = QualityWCRDataSource(
                              //       qualitylisttable1,
                              //       widget.depoName!,
                              //       widget.cityName!);
                              //   _dataGridController = DataGridController();
                              // } else if (_selectedIndex == 11) {
                              //   _qualityPROOFINGDataSource =
                              //       QualityPROOFINGDataSource(qualitylisttable1,
                              //           widget.depoName!, widget.cityName!);
                              //   _dataGridController = DataGridController();
                              // }
                            });
                            return SfDataGridTheme(
                              data: SfDataGridThemeData(
                                  headerColor: white, gridLineColor: blue),
                              child: SfDataGrid(
                                source: _selectedIndex == 0
                                    ? _qualityExcavationDataSource
                                    : _selectedIndex == 1
                                        ? _qualityBackFillingDataSource
                                        : _selectedIndex == 2
                                            ? _qualityMassonaryDataSource
                                            : _selectedIndex == 3
                                                ? _qualityGlazzingDataSource
                                                : _selectedIndex == 4
                                                    ? _qualityCeillingDataSource
                                                    : _selectedIndex == 5
                                                        ? _qualityflooringDataSource
                                                        : _selectedIndex == 6
                                                            ? _qualityInspectionDataSource
                                                            : _selectedIndex ==
                                                                    7
                                                                ? _qualityIroniteflooringDataSource
                                                                : _selectedIndex ==
                                                                        8
                                                                    ? _qualityPaintingDataSource
                                                                    :
                                                                    // _selectedIndex ==
                                                                    //         9
                                                                    //     ?
                                                                    _qualityPavingDataSource,
                                // _selectedIndex ==
                                //         10
                                //     ? _qualityRoofingDataSource
                                //     : _qualityPROOFINGDataSource,

                                //key: key,
                                allowEditing: true,
                                frozenColumnsCount: 2,
                                gridLinesVisibility: GridLinesVisibility.both,
                                headerGridLinesVisibility:
                                    GridLinesVisibility.both,
                                selectionMode: SelectionMode.single,
                                navigationMode: GridNavigationMode.cell,
                                columnWidthMode: ColumnWidthMode.auto,
                                editingGestureType: EditingGestureType.tap,
                                rowHeight: 50,
                                headerRowHeight: 50,
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
                                              color: white)),
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
                                              color: white)),
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
                                            color: white,
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
                                              color: white)),
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
                                              color: white)),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Upload',
                                    allowEditing: false,
                                    visible: true,
                                    width: 150,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Upload.',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: white)),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'View',
                                    allowEditing: false,
                                    width: 150,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('View',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: white)),
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
}

CivilstoreData(BuildContext context, String depoName, String currentDate,
    List<bool> listToSelectTab) {
  Map<String, dynamic> excavationTableData = Map();
  Map<String, dynamic> backfillingTableData = Map();
  Map<String, dynamic> massonaryTableData = Map();
  Map<String, dynamic> doorsTableData = Map();
  Map<String, dynamic> ceillingTableData = Map();
  Map<String, dynamic> flooringTableData = Map();
  Map<String, dynamic> inspectionTableData = Map();
  Map<String, dynamic> paintingTableData = Map();
  Map<String, dynamic> pavingTableData = Map();
  Map<String, dynamic> roofingTableData = Map();
  Map<String, dynamic> proofingTableData = Map();

  for (var i in _qualityExcavationDataSource.dataGridRows) {
    for (var data in i.getCells()) {
      if (data.columnName != 'button' ||
          data.columnName == 'View' ||
          data.columnName != 'Delete') {
        excavationTableData[data.columnName] = data.value;
      }
    }

    excavationtabledatalist.add(excavationTableData);
    excavationTableData = {};
  }

  FirebaseFirestore.instance
      .collection('QualityChecklist')
      .doc(depoName)
      .collection('Excavation TABLE DATA')
      .doc('Excavation')
      .collection(userId)
      .doc(currentDate)
      .set({
    'data': excavationtabledatalist,
  }).whenComplete(() {
    excavationTableData.clear();
    for (var i in _qualityBackFillingDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName == 'View' ||
            data.columnName != 'Delete') {
          backfillingTableData[data.columnName] = data.value;
        }
      }
      backfillingtabledatalist.add(backfillingTableData);
      backfillingTableData = {};
    }

    FirebaseFirestore.instance
        .collection('QualityChecklist')
        .doc(depoName)
        .collection('BackFilling TABLE DATA')
        .doc('BackFilling')
        .collection(userId)
        .doc(currentDate)
        .set({
      'data': backfillingtabledatalist,
    }).whenComplete(() {
      backfillingTableData.clear();
      for (var i in _qualityMassonaryDataSource.dataGridRows) {
        for (var data in i.getCells()) {
          if (data.columnName != 'button' ||
              data.columnName == 'View' ||
              data.columnName != 'Delete') {
            massonaryTableData[data.columnName] = data.value;
          }
        }

        massonarytabledatalist.add(massonaryTableData);
        massonaryTableData = {};
      }

      FirebaseFirestore.instance
          .collection('QualityChecklist')
          .doc(depoName)
          .collection('Massonary TABLE DATA')
          .doc('Massonary')
          .collection(userId)
          .doc(currentDate)
          .set({
        'data': backfillingtabledatalist,
      }).whenComplete(() {
        massonaryTableData.clear();
        for (var i in _qualityGlazzingDataSource.dataGridRows) {
          for (var data in i.getCells()) {
            if (data.columnName != 'button' ||
                data.columnName == 'View' ||
                data.columnName != 'Delete') {
              doorsTableData[data.columnName] = data.value;
            }
          }
          doorstabledatalist.add(doorsTableData);
          doorsTableData = {};
        }

        FirebaseFirestore.instance
            .collection('QualityChecklist')
            .doc(depoName)
            .collection('Glazzing TABLE DATA')
            .doc('Glazzing')
            .collection(userId)
            .doc(currentDate)
            .set({
          'data': doorstabledatalist,
        }).whenComplete(() {
          doorsTableData.clear();
          for (var i in _qualityCeillingDataSource.dataGridRows) {
            for (var data in i.getCells()) {
              if (data.columnName != 'button' || data.columnName != 'Delete') {
                ceillingTableData[data.columnName] = data.value;
              }
            }
            ceillingtabledatalist.add(ceillingTableData);
            ceillingTableData = {};
          }

          FirebaseFirestore.instance
              .collection('QualityChecklist')
              .doc(depoName)
              .collection('CEILLING TABLE DATA')
              .doc('CEILLING DATA')
              .collection(userId)
              .doc(currentDate)
              .set({
            'data': ceillingtabledatalist,
          }).whenComplete(() {
            ceillingTableData.clear();
            for (var i in _qualityflooringDataSource.dataGridRows) {
              for (var data in i.getCells()) {
                if (data.columnName != 'button' ||
                    data.columnName == 'View' ||
                    data.columnName != 'Delete') {
                  flooringTableData[data.columnName] = data.value;
                }
              }
              flooringtabledatalist.add(flooringTableData);
              flooringTableData = {};
            }

            FirebaseFirestore.instance
                .collection('QualityChecklist')
                .doc(depoName)
                .collection('FLOORING TABLE DATA')
                .doc('FLOORING DATA')
                .collection(userId)
                .doc(currentDate)
                .set({
              'data': flooringtabledatalist,
            }).whenComplete(() {
              flooringTableData.clear();
              for (var i in _qualityInspectionDataSource.dataGridRows) {
                for (var data in i.getCells()) {
                  if (data.columnName != 'button' ||
                      data.columnName == 'View' ||
                      data.columnName != 'Delete') {
                    inspectionTableData[data.columnName] = data.value;
                  }
                }
                inspectiontabledatalist.add(inspectionTableData);
                inspectionTableData = {};
              }

              FirebaseFirestore.instance
                  .collection('QualityChecklist')
                  .doc(depoName)
                  .collection('INSPECTION TABLE DATA')
                  .doc('INSPECTION DATA')
                  .collection(userId)
                  .doc(currentDate)
                  .set({
                'data': inspectiontabledatalist,
              }).whenComplete(() {
                inspectionTableData.clear();
                for (var i in _qualityflooringDataSource.dataGridRows) {
                  for (var data in i.getCells()) {
                    if (data.columnName != 'button' ||
                        data.columnName == 'View' ||
                        data.columnName != 'Delete') {
                      flooringTableData[data.columnName] = data.value;
                    }
                  }
                  flooringtabledatalist.add(flooringTableData);
                  flooringTableData = {};
                }

                FirebaseFirestore.instance
                    .collection('QualityChecklist')
                    .doc(depoName)
                    .collection('FLOORING TABLE DATA')
                    .doc('FLOORING DATA')
                    .collection(userId)
                    .doc(currentDate)
                    .set({
                  'data': flooringtabledatalist,
                }).whenComplete(() {
                  flooringTableData.clear();
                  for (var i in _qualityPaintingDataSource.dataGridRows) {
                    for (var data in i.getCells()) {
                      if (data.columnName != 'button' ||
                          data.columnName == 'View' ||
                          data.columnName != 'Delete') {
                        flooringTableData[data.columnName] = data.value;
                      }
                    }
                    paintingtabledatalist.add(paintingTableData);
                    paintingTableData = {};
                  }

                  FirebaseFirestore.instance
                      .collection('QualityChecklist')
                      .doc(depoName)
                      .collection('PAINTING TABLE DATA')
                      .doc('PAINTING DATA')
                      .collection(userId)
                      .doc(currentDate)
                      .set({
                    'data': paintingtabledatalist,
                  }).whenComplete(() {
                    paintingTableData.clear();
                    for (var i in _qualityPavingDataSource.dataGridRows) {
                      for (var data in i.getCells()) {
                        if (data.columnName != 'button' ||
                            data.columnName == 'View' ||
                            data.columnName != 'Delete') {
                          pavingTableData[data.columnName] = data.value;
                        }
                      }
                      pavingtabledatalist.add(pavingTableData);
                      pavingTableData = {};
                    }

                    FirebaseFirestore.instance
                        .collection('QualityChecklist')
                        .doc(depoName)
                        .collection('PAVING TABLE DATA')
                        .doc('PAVING DATA')
                        .collection(userId)
                        .doc(currentDate)
                        .set({
                      'data': pavingtabledatalist,
                    }).whenComplete(() {
                      pavingtabledatalist.clear();
                      for (var i in _qualityRoofingDataSource.dataGridRows) {
                        for (var data in i.getCells()) {
                          if (data.columnName != 'button' ||
                              data.columnName == 'View' ||
                              data.columnName != 'Delete') {
                            roofingTableData[data.columnName] = data.value;
                          }
                        }
                        roofingtabledatalist.add(roofingTableData);
                        roofingTableData = {};
                      }

                      FirebaseFirestore.instance
                          .collection('QualityChecklist')
                          .doc(depoName)
                          .collection('ROOFING TABLE DATA')
                          .doc('ROOFING DATA')
                          .collection(userId)
                          .doc(currentDate)
                          .set({
                        'data': roofingtabledatalist,
                      }).whenComplete(() {
                        roofingTableData.clear();
                        for (var i in _qualityProofingDataSource.dataGridRows) {
                          for (var data in i.getCells()) {
                            if (data.columnName != 'button' ||
                                data.columnName == 'View' ||
                                data.columnName != 'Delete') {
                              roofingTableData[data.columnName] = data.value;
                            }
                          }
                          roofingtabledatalist.add(roofingTableData);
                          roofingTableData = {};
                        }

                        FirebaseFirestore.instance
                            .collection('QualityChecklist')
                            .doc(depoName)
                            .collection('PROOFING TABLE DATA')
                            .doc('PROOFING DATA')
                            .collection(userId)
                            .doc(currentDate)
                            .set({
                          'data': proofingtabledatalist,
                        }).whenComplete(() {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text('Data are synced'),
                            backgroundColor: blue,
                          ));
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        });
      });
    });
  });
}
