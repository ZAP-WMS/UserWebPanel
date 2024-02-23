import 'dart:convert';
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
import 'package:pdf/pdf.dart';
import 'dart:html' as html;
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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

String? selectedDate = DateFormat.yMMMMd().format(DateTime.now());
DateTime currentDate = DateTime.now();

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

List<String> tabForCivil = [
  'Exc',
  'BackFilling',
  'Massonary',
  'Glazzing',
  'Ceilling',
  'Flooring',
  'Inspection',
  'Ironite',
  'Painting',
  'Paving',
  'Roofing',
  'Proofing'
];

List<String> completeTabForCivil = [
  'Excavation',
  'BackFilling',
  'Brick / Block Massonary',
  'Doors, Windows, Hardware & Glazing',
  'False Ceiling',
  'Flooring & Tiling',
  'Grouting Inspection',
  'Ironite / Ips Flooring',
  'Painting',
  'Interlock Paving Work',
  'Wall Cladding & Roofing',
  'Water Proofing'
];

TextEditingController projectNameController = TextEditingController();
TextEditingController locationNameController = TextEditingController();
TextEditingController dateController = TextEditingController();
TextEditingController componentController = TextEditingController();
TextEditingController gridController = TextEditingController();
TextEditingController vendorController = TextEditingController();
TextEditingController drawingController = TextEditingController();
TextEditingController fillingController = TextEditingController();

int? _selectedIndex = 0;

class CivilQualityChecklist extends StatefulWidget {
  String? cityName;
  String? depoName;
  String? currentDate;
  bool? isHeader;
  Function? getBoolList;

  CivilQualityChecklist({
    super.key,
    required this.cityName,
    required this.depoName,
    this.currentDate,
    this.isHeader = true,
    this.getBoolList,
  });

  @override
  State<CivilQualityChecklist> createState() => _CivilQualityChecklistState();
}

class _CivilQualityChecklistState extends State<CivilQualityChecklist> {
  ProgressDialog? pr;

  List<bool> civilTabBool = [];
  List<QualitychecklistModel> data = [];
  bool checkTable = true;

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
  bool _isloading = false;

  @override
  void initState() {
    pr = ProgressDialog(context,
        customBody:
            Container(height: 200, width: 100, child: const LoadingPdf()));
    setBoolean();
    if (_selectedIndex == 0) {
      civilTabBool[0] = true;
      print(civilTabBool);
      widget.getBoolList!(civilTabBool, tabForCivil[_selectedIndex!]);
    }

    getUserId().whenComplete(() => {
          getControllersData(),
          getTableData().whenComplete(() {
            qualitylisttable1 = checkTable ? excavation_getData() : data;
            _qualityExcavationDataSource = QualityExcavationDataSource(
                qualitylisttable1, widget.cityName!, widget.depoName!);
            _dataGridController = DataGridController();

            qualitylisttable2 = checkTable ? backfilling_getData() : data;
            _qualityBackFillingDataSource = QualityBackFillingDataSource(
              qualitylisttable2,
              widget.cityName!,
              widget.depoName!,
            );
            _dataGridController = DataGridController();
            qualitylisttable3 = checkTable ? massonary_getData() : data;
            _qualityMassonaryDataSource = QualityMassonaryDataSource(
              qualitylisttable3,
              widget.cityName!,
              widget.depoName!,
            );
            _dataGridController = DataGridController();
            qualitylisttable4 = checkTable ? glazzing_getData() : data;
            _qualityGlazzingDataSource = QualityGlazzingDataSource(
              qualitylisttable4,
              widget.cityName!,
              widget.depoName!,
            );
            _dataGridController = DataGridController();
            qualitylisttable5 = checkTable ? ceilling_getData() : data;
            _qualityCeillingDataSource = QualityCeillingDataSource(
                qualitylisttable5, widget.cityName!, widget.depoName!);
            qualitylisttable6 = checkTable ? florring_getData() : data;
            _qualityflooringDataSource = QualityflooringDataSource(
              qualitylisttable6,
              widget.cityName!,
              widget.depoName!,
            );
            _dataGridController = DataGridController();
            qualitylisttable7 = checkTable ? inspection_getData() : data;
            _qualityInspectionDataSource = QualityInspectionDataSource(
                qualitylisttable7, widget.cityName!, widget.depoName!);
            _dataGridController = DataGridController();
            qualitylisttable8 = checkTable ? ironite_florring_getData() : data;
            _qualityIroniteflooringDataSource =
                QualityIroniteflooringDataSource(
                    qualitylisttable8, widget.cityName!, widget.depoName!);
            _dataGridController = DataGridController();
            qualitylisttable9 = checkTable ? painting_getData() : data;
            _qualityPaintingDataSource = QualityPaintingDataSource(
                qualitylisttable9, widget.cityName!, widget.depoName!);
            _dataGridController = DataGridController();
            qualitylisttable10 = checkTable ? paving_getData() : data;
            _qualityPavingDataSource = QualityPavingDataSource(
                qualitylisttable10, widget.cityName!, widget.depoName!);
            _dataGridController = DataGridController();
            qualitylisttable11 = checkTable ? roofing_getData() : data;
            _qualityRoofingDataSource = QualityRoofingDataSource(
                qualitylisttable11, widget.cityName!, widget.depoName!);
            _dataGridController = DataGridController();
            qualitylisttable12 = checkTable ? proofing_getData() : data;
            _qualityProofingDataSource = QualityProofingDataSource(
                qualitylisttable12, widget.cityName!, widget.depoName!);
            _dataGridController = DataGridController();
          }),
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 12,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 5,
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

                civilTabBool[value] = true;
                widget.getBoolList!(civilTabBool, tabForCivil[value]);
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
          body: _isloading
              ? LoadingPage()
              : TabBarView(
                  children: [
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
                  ],
                ),
        ));
  }

  civilupperScreen() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('CivilChecklistField')
          .doc('${widget.depoName}')
          .collection('userId')
          .doc(userId)
          .collection(tabForCivil[_selectedIndex!])
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
                      civil_title[int.parse(_selectedIndex.toString())],
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: blue),
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(blue)),
                        onPressed: () {
                          _generateCivilPdf();
                        },
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: 'Download PDF',
                              style: TextStyle(fontSize: 17, color: white)),
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
                              DateFormat('MMMM dd, yyyy').format(currentDate),
                              style: GoogleFonts.aBeeZee(
                                  fontSize: 15, color: white),
                            )),
                      ],
                    ),

                    Text(
                      'TPCL/DIST/EV/CHECKLIST',
                      style: TextStyle(color: blue, fontSize: 17),
                    )
                  ],
                ),
              ),
              Container(
                  padding:
                      const EdgeInsets.only(left: 50, right: 50, bottom: 10),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                    width: 150,
                                    child: Text(
                                      'Project : ',
                                      style: TextStyle(color: blue),
                                    )),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: SizedBox(
                                        height: 30,
                                        child: widget.isHeader!
                                            ? TextFormField(
                                                controller:
                                                    projectNameController,
                                                decoration: InputDecoration(
                                                  labelStyle:
                                                      TextStyle(color: black),
                                                  contentPadding:
                                                      const EdgeInsets.all(3),
                                                ),
                                                style: TextStyle(
                                                    fontSize: 15, color: blue),
                                              )
                                            : Container(
                                                width: 120,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: blue)),
                                              ))),
                              ],
                            ),
                          ),
                          Container(
                            // color: lightblue,
                            width: 550,
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                    width: 150,
                                    child: Text(
                                      'Location : ',
                                      style: TextStyle(color: blue),
                                    )),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: SizedBox(
                                        height: 30,
                                        child: widget.isHeader!
                                            ? TextFormField(
                                                controller:
                                                    locationNameController,
                                                decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                top: 0,
                                                                bottom: 0,
                                                                left: 5)),
                                                style: TextStyle(
                                                    fontSize: 15, color: blue),
                                              )
                                            : Container(
                                                width: 120,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: blue)),
                                              ))),
                              ],
                            ),
                          ),
                          Container(
                            // color: lightblue,
                            width: 550,
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    width: 150,
                                    child: Text(
                                      'Vendor / Sub Vendor : ',
                                      style: TextStyle(color: blue),
                                    )),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: Container(
                                        height: 30,
                                        child: widget.isHeader!
                                            ? TextFormField(
                                                controller: vendorController,
                                                decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                top: 0,
                                                                bottom: 0,
                                                                left: 5)),
                                                style: TextStyle(
                                                    fontSize: 15, color: blue),
                                              )
                                            : Container(
                                                width: 120,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: blue)),
                                              ))),
                              ],
                            ),
                          ),
                          Container(
                            // color: lightblue,
                            width: 550,
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    width: 150,
                                    child: Text(
                                      'Drawing No :',
                                      style: TextStyle(color: blue),
                                    )),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: Container(
                                        height: 30,
                                        child: widget.isHeader!
                                            ? TextFormField(
                                                controller: drawingController,
                                                decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                top: 0,
                                                                bottom: 0,
                                                                left: 5)),
                                                style: TextStyle(
                                                    fontSize: 15, color: blue),
                                              )
                                            : Container(
                                                width: 120,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: blue)),
                                              ))),
                              ],
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                            // color: lightblue,
                            width: 550,
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                                controller: dateController,
                                                decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                top: 0,
                                                                bottom: 0,
                                                                left: 5)),
                                                style: TextStyle(
                                                    fontSize: 15, color: blue),
                                              )
                                            : Container(
                                                width: 120,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: blue)),
                                              ))),
                              ],
                            ),
                          ),
                          Container(
                            // color: lightblue,
                            width: 550,
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    width: 150,
                                    child: Text(
                                      'Component of the Structure : ',
                                      style: TextStyle(color: blue),
                                    )),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: Container(
                                        height: 30,
                                        child: widget.isHeader!
                                            ? TextFormField(
                                                controller: componentController,
                                                decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                top: 0,
                                                                bottom: 0,
                                                                left: 5)),
                                                style: TextStyle(
                                                    fontSize: 15, color: blue),
                                              )
                                            : Container(
                                                width: 120,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: blue)),
                                              ))),
                              ],
                            ),
                          ),
                          Container(
                            // color: lightblue,
                            width: 550,
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    width: 150,
                                    child: Text(
                                      'Grid / Axis & Level : ',
                                      style: TextStyle(color: blue),
                                    )),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: Container(
                                        height: 30,
                                        child: widget.isHeader!
                                            ? TextFormField(
                                                controller: gridController,
                                                decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                top: 0,
                                                                bottom: 0,
                                                                left: 5)),
                                                style: TextStyle(
                                                    fontSize: 15, color: blue),
                                              )
                                            : Container(
                                                width: 120,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: blue)),
                                              ))),
                              ],
                            ),
                          ),
                          Container(
                            // color: lightblue,
                            width: 550,
                            padding: const EdgeInsets.all(3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                    width: 150,
                                    child: Text(
                                      'Type of Filling : ',
                                      style: TextStyle(color: blue),
                                    )),
                                const SizedBox(width: 5),
                                Expanded(
                                    child: Container(
                                        height: 30,
                                        child: widget.isHeader!
                                            ? TextFormField(
                                                controller: fillingController,
                                                decoration:
                                                    const InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                top: 0,
                                                                bottom: 0,
                                                                left: 5)),
                                                style: TextStyle(
                                                    fontSize: 15, color: blue),
                                              )
                                            : Container(
                                                width: 120,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        color: blue)),
                                              ))),
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
                                                      : _selectedIndex == 9
                                                          ? _stream9
                                                          : _stream10,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LoadingPage();
                    }
                    if (!snapshot.hasData || snapshot.data.exists == false) {
                      return widget.isHeader!
                          ? SfDataGridTheme(
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
                                                                    : _selectedIndex ==
                                                                            9
                                                                        ? _qualityPavingDataSource
                                                                        : _selectedIndex ==
                                                                                10
                                                                            ? _qualityRoofingDataSource
                                                                            : _qualityProofingDataSource,

                                allowEditing: true,
                                frozenColumnsCount: 2,
                                gridLinesVisibility: GridLinesVisibility.both,
                                headerGridLinesVisibility:
                                    GridLinesVisibility.both,
                                rowHeight: 50,
                                headerRowHeight: 50,
                                selectionMode: SelectionMode.single,
                                navigationMode: GridNavigationMode.cell,
                                columnWidthMode: ColumnWidthMode.auto,
                                editingGestureType: EditingGestureType.tap,
                                controller: _dataGridController,

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
                                              fontSize: 14,
                                              color: blue)),
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
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: blue)),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'responsibility',
                                    width: 250,
                                    allowEditing: true,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text("Contractor’s Site Engineer",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: blue,
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
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: blue)),
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
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: blue)),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'Upload',
                                    allowEditing: false,
                                    visible: true,
                                    width: 110,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('Upload',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: blue)),
                                    ),
                                  ),
                                  GridColumn(
                                    columnName: 'View',
                                    allowEditing: true,
                                    width: 130,
                                    label: Container(
                                      alignment: Alignment.center,
                                      child: Text('View',
                                          overflow: TextOverflow.values.first,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: blue)),
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
                                    borderRadius: BorderRadius.circular(20),
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
                      // alldata = '';
                      // alldata = snapshot.data['data'] as List<dynamic>;
                      qualitylisttable1.clear();
                      alldata.forEach((element) {
                        qualitylisttable1
                            .add(QualitychecklistModel.fromJson(element));
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
                                                      : _selectedIndex == 7
                                                          ? _qualityIroniteflooringDataSource
                                                          : _selectedIndex == 8
                                                              ? _qualityPaintingDataSource
                                                              : _selectedIndex ==
                                                                      9
                                                                  ? _qualityPavingDataSource
                                                                  : _selectedIndex ==
                                                                          10
                                                                      ? _qualityRoofingDataSource
                                                                      : _qualityProofingDataSource,

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
                                        fontSize: 14,
                                        color: blue)),
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
                                        fontSize: 14,
                                        color: blue)),
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
                                      fontSize: 14,
                                      color: blue,
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
                                        fontSize: 14,
                                        color: blue)),
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
                                        fontSize: 14,
                                        color: blue)),
                              ),
                            ),
                            GridColumn(
                              columnName: 'Upload',
                              allowEditing: false,
                              visible: true,
                              width: 110,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('Upload.',
                                    overflow: TextOverflow.values.first,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: blue)),
                              ),
                            ),
                            GridColumn(
                              columnName: 'View',
                              allowEditing: true,
                              width: 130,
                              label: Container(
                                alignment: Alignment.center,
                                child: Text('View',
                                    overflow: TextOverflow.values.first,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: blue)),
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
    for (int i = 0; i < tabForCivil.length; i++) {
      tempList.add(false);
    }
    civilTabBool = tempList;
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
      currentDate = picked;
      selectedDate = DateFormat.yMMMMd().format(currentDate);
      getControllersData();
      getTableData();
    }
  }

  Future<void> getControllersData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(widget.depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(selectedDate)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> controllerData =
          documentSnapshot.data() as Map<String, dynamic>;

      projectNameController.text = controllerData['projectName'] ?? '';
      locationNameController.text = controllerData['location'] ?? '';
      componentController.text = controllerData['componentName'] ?? '';
      dateController.text = controllerData['date'] ?? '';
      drawingController.text = controllerData['drawing'] ?? '';
      gridController.text = controllerData['grid'] ?? '';
      vendorController.text = controllerData['vendor'] ?? '';
      fillingController.text = controllerData['filling'] ?? '';

      print('Data - $controllerData');
    } else {
      projectNameController.clear();
      locationNameController.clear();
      componentController.clear();
      dateController.clear();
      drawingController.clear();
      gridController.clear();
      vendorController.clear();
      fillingController.clear();
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
        .collection('CivilQualityChecklist')
        .doc(widget.depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(selectedDate)
        .get();

    if (documentSnapshot.exists) {
      Map<String, dynamic> tempData =
          documentSnapshot.data() as Map<String, dynamic>;

      List<dynamic> mapData = tempData['data'];

      data = mapData.map((map) => QualitychecklistModel.fromJson(map)).toList();
      checkTable = false;
    }

    if (_selectedIndex == 1) {
      qualitylisttable2 = checkTable ? backfilling_getData() : data;
      _qualityBackFillingDataSource = QualityBackFillingDataSource(
          qualitylisttable2, widget.cityName!, widget.depoName!);
      _dataGridController = DataGridController();
      checkTable = true;
    } else if (_selectedIndex == 2) {
      qualitylisttable3 = checkTable ? massonary_getData() : data;
      _qualityMassonaryDataSource = QualityMassonaryDataSource(
          qualitylisttable3, widget.cityName!, widget.depoName!);
      _dataGridController = DataGridController();
      checkTable = true;
    } else if (_selectedIndex == 3) {
      qualitylisttable4 = checkTable ? glazzing_getData() : data;
      _qualityGlazzingDataSource = QualityGlazzingDataSource(
          qualitylisttable4, widget.cityName!, widget.depoName!);
      _dataGridController = DataGridController();
      checkTable = true;
    } else if (_selectedIndex == 4) {
      qualitylisttable5 = checkTable ? ceilling_getData() : data;
      _qualityCeillingDataSource = QualityCeillingDataSource(
          qualitylisttable5, widget.cityName!, widget.depoName!);
      _dataGridController = DataGridController();
      checkTable = true;
    } else if (_selectedIndex == 5) {
      qualitylisttable6 = checkTable ? florring_getData() : data;
      _qualityflooringDataSource = QualityflooringDataSource(
          qualitylisttable6, widget.cityName!, widget.depoName!);
      _dataGridController = DataGridController();
      checkTable = true;
    } else if (_selectedIndex == 6) {
      qualitylisttable7 = checkTable ? inspection_getData() : data;
      _qualityInspectionDataSource = QualityInspectionDataSource(
          qualitylisttable7, widget.cityName!, widget.depoName!);
      _dataGridController = DataGridController();
      checkTable = true;
    } else if (_selectedIndex == 7) {
      qualitylisttable8 = checkTable ? ironite_florring_getData() : data;
      _qualityIroniteflooringDataSource = QualityIroniteflooringDataSource(
          qualitylisttable8, widget.cityName!, widget.depoName!);
      _dataGridController = DataGridController();
      checkTable = true;
    } else if (_selectedIndex == 8) {
      qualitylisttable9 = checkTable ? painting_getData() : data;
      _qualityPaintingDataSource = QualityPaintingDataSource(
          qualitylisttable9, widget.cityName!, widget.depoName!);
      _dataGridController = DataGridController();
      checkTable = true;
    } else if (_selectedIndex == 9) {
      qualitylisttable10 = checkTable ? paving_getData() : data;
      _qualityPavingDataSource = QualityPavingDataSource(
          qualitylisttable10, widget.cityName!, widget.depoName!);
      _dataGridController = DataGridController();
      checkTable = true;
    } else if (_selectedIndex == 10) {
      print('roofing');
      qualitylisttable11 = checkTable ? roofing_getData() : data;
      _qualityRoofingDataSource = QualityRoofingDataSource(
          qualitylisttable11, widget.cityName!, widget.depoName!);
      _dataGridController = DataGridController();
      checkTable = true;
    } else if (_selectedIndex == 11) {
      print('Proofing');
      qualitylisttable12 = checkTable ? proofing_getData() : data;
      _qualityProofingDataSource = QualityProofingDataSource(
          qualitylisttable12, widget.cityName!, widget.depoName!);
      _dataGridController = DataGridController();
      checkTable = true;
    }

    _isloading = false;
    setState(() {});
  }

  Future<List<int>> _generateCivilPdf() async {
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
      ['PROJECT :', projectNameController.text],
      ['Date :', dateController.text],
      ['Location :', locationNameController.text],
      ['Component of structure : ', componentController.text],
      ['Vendor / Sub Vendor :', vendorController.text],
      ['Grid / Axis & Level :', gridController.text],
      ['Drawing Number :', drawingController.text],
      ['Type of Filling :', fillingController.text],
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
              child: pw.Text('Reference',
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

    List<dynamic> userData = [];

    if (data.isNotEmpty) {
      List<pw.Widget> imageUrls = [];

      for (QualitychecklistModel mapData in data) {
        String imagesPath =
            'QualityChecklist/civil_Engineer/${widget.cityName}/${widget.depoName}/$userId/${tabForCivil[_selectedIndex!]} Table/$date/${mapData.srNo}';

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
        pageFormat: const PdfPageFormat(
          1300,
          900,
          marginLeft: 70,
          marginRight: 70,
          marginBottom: 80,
          marginTop: 40,
        ),
        orientation: pw.PageOrientation.natural,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(
                border: pw.Border(
                    bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey)),
              ),
              child: pw.Column(children: [
                pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                          'Civil Quality Report / ${completeTabForCivil[_selectedIndex!]} Table',
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
                          'Civil Quality Report / ${completeTabForCivil[_selectedIndex!]} Table',
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
        'CivilQualityReport_${completeTabForCivil[_selectedIndex!]}($userId/$date).pdf';

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

CivilstoreData(BuildContext context, String depoName, String currentDate,
    List<bool> isTabSelected, String selectedTabName) {
  print(currentDate);
  Map<String, dynamic> excavationTableData = {};
  Map<String, dynamic> backfillingTableData = {};
  Map<String, dynamic> massonaryTableData = {};
  Map<String, dynamic> doorsTableData = {};
  Map<String, dynamic> ceillingTableData = {};
  Map<String, dynamic> flooringTableData = {};
  Map<String, dynamic> inspectionTableData = {};
  Map<String, dynamic> paintingTableData = {};
  Map<String, dynamic> pavingTableData = {};
  Map<String, dynamic> roofingTableData = {};
  Map<String, dynamic> proofingTableData = {};

  if (isTabSelected[0]) {
    for (var i in _qualityExcavationDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName != 'View' ||
            data.columnName != 'Delete') {
          excavationTableData[data.columnName] = data.value;
        }
      }

      excavationtabledatalist.add(excavationTableData);
      excavationTableData = {};
    }

    FirebaseFirestore.instance
        .collection('CivilQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': excavationtabledatalist,
    }).whenComplete(() async {
      FirebaseApi().nestedKeyEventsField(
          'CivilQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'CivilChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    excavationtabledatalist.clear();

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'projectName': projectNameController.text,
      'date': dateController.text,
      'location': locationNameController.text,
      'componentName': componentController.text,
      'vendor': vendorController.text,
      'grid': gridController.text,
      'drawing': drawingController.text,
      'filling': fillingController.text
    });

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});
  } else if (isTabSelected[1]) {
    excavationTableData.clear();
    for (var i in _qualityBackFillingDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName == 'View' ||
            data.columnName != 'Delete') {
          backfillingTableData[data.columnName] = data.value ?? '';
        }
      }
      backfillingtabledatalist.add(backfillingTableData);
      backfillingTableData = {};
    }
    FirebaseFirestore.instance
        .collection('CivilQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': backfillingtabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'CivilQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'CivilChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    backfillingtabledatalist.clear();

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'projectName': projectNameController.text,
      'date': dateController.text,
      'location': locationNameController.text,
      'componentName': componentController.text,
      'vendor': vendorController.text,
      'grid': gridController.text,
      'drawing': drawingController.text,
      'filling': fillingController.text
    });

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});
  } else if (isTabSelected[2]) {
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
        .collection('CivilQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': massonarytabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'CivilQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'CivilChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    massonarytabledatalist.clear();

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'projectName': projectNameController.text,
      'date': dateController.text,
      'location': locationNameController.text,
      'componentName': componentController.text,
      'vendor': vendorController.text,
      'grid': gridController.text,
      'drawing': drawingController.text,
      'filling': fillingController.text
    });

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});
  } else if (isTabSelected[3]) {
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
        .collection('CivilQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': doorstabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'CivilQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'CivilChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    doorstabledatalist.clear();

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'projectName': projectNameController.text,
      'date': dateController.text,
      'location': locationNameController.text,
      'componentName': componentController.text,
      'vendor': vendorController.text,
      'grid': gridController.text,
      'drawing': drawingController.text,
      'filling': fillingController.text
    });

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});
  } else if (isTabSelected[4]) {
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
        .collection('CivilQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': ceillingtabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'CivilQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'CivilChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    ceillingTableData.clear();

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'projectName': projectNameController.text,
      'date': dateController.text,
      'location': locationNameController.text,
      'componentName': componentController.text,
      'vendor': vendorController.text,
      'grid': gridController.text,
      'drawing': drawingController.text,
      'filling': fillingController.text
    });

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});
  } else if (isTabSelected[5]) {
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
        .collection('CivilQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': flooringtabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'CivilQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'CivilChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    flooringtabledatalist.clear();

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'projectName': projectNameController.text,
      'date': dateController.text,
      'location': locationNameController.text,
      'componentName': componentController.text,
      'vendor': vendorController.text,
      'grid': gridController.text,
      'drawing': drawingController.text,
      'filling': fillingController.text
    });

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});
  } else if (isTabSelected[6]) {
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
        .collection('CivilQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': inspectiontabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'CivilQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'CivilChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    inspectiontabledatalist.clear();

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'projectName': projectNameController.text,
      'date': dateController.text,
      'location': locationNameController.text,
      'componentName': componentController.text,
      'vendor': vendorController.text,
      'grid': gridController.text,
      'drawing': drawingController.text,
      'filling': fillingController.text
    });

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});
  } else if (isTabSelected[7]) {
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
        .collection('CivilQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': flooringtabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'CivilQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'CivilChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    flooringtabledatalist.clear();

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'projectName': projectNameController.text,
      'date': dateController.text,
      'location': locationNameController.text,
      'componentName': componentController.text,
      'vendor': vendorController.text,
      'grid': gridController.text,
      'drawing': drawingController.text,
      'filling': fillingController.text
    });

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});
  } else if (isTabSelected[8]) {
    flooringTableData.clear();
    for (var i in _qualityPaintingDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName == 'View' ||
            data.columnName != 'Delete') {
          paintingTableData[data.columnName] = data.value;
        }
      }
      paintingtabledatalist.add(paintingTableData);
      paintingTableData = {};
    }
    FirebaseFirestore.instance
        .collection('CivilQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': paintingtabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'CivilQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'CivilChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    paintingtabledatalist.clear();

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'projectName': projectNameController.text,
      'date': dateController.text,
      'location': locationNameController.text,
      'componentName': componentController.text,
      'vendor': vendorController.text,
      'grid': gridController.text,
      'drawing': drawingController.text,
      'filling': fillingController.text
    });

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});
  } else if (isTabSelected[9]) {
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
        .collection('CivilQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': pavingtabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'CivilQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'CivilChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    pavingtabledatalist.clear();

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'projectName': projectNameController.text,
      'date': dateController.text,
      'location': locationNameController.text,
      'componentName': componentController.text,
      'vendor': vendorController.text,
      'grid': gridController.text,
      'drawing': drawingController.text,
      'filling': fillingController.text
    });

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});
  } else if (isTabSelected[10]) {
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
        .collection('CivilQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': roofingtabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'CivilQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'CivilChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    roofingtabledatalist.clear();

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'projectName': projectNameController.text,
      'date': dateController.text,
      'location': locationNameController.text,
      'componentName': componentController.text,
      'vendor': vendorController.text,
      'grid': gridController.text,
      'drawing': drawingController.text,
      'filling': fillingController.text
    });

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});
  } else if (isTabSelected[11]) {
    roofingTableData.clear();
    for (var i in _qualityProofingDataSource.dataGridRows) {
      for (var data in i.getCells()) {
        if (data.columnName != 'button' ||
            data.columnName == 'View' ||
            data.columnName != 'Delete') {
          proofingTableData[data.columnName] = data.value;
        }
      }
      proofingtabledatalist.add(proofingTableData);
      proofingTableData = {};
    }
    FirebaseFirestore.instance
        .collection('CivilQualityChecklist')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'data': proofingtabledatalist,
    }).whenComplete(() {
      FirebaseApi().nestedKeyEventsField(
          'CivilQualityChecklist', depoName, 'userId', userId);
      FirebaseApi().nestedKeyEventsField(
          'CivilChecklistField', depoName, 'userId', userId);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Data are synced'),
        backgroundColor: blue,
      ));
    });

    proofingtabledatalist.clear();

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .collection(tabForCivil[_selectedIndex!])
        .doc(currentDate)
        .set({
      'projectName': projectNameController.text,
      'date': dateController.text,
      'location': locationNameController.text,
      'componentName': componentController.text,
      'vendor': vendorController.text,
      'grid': gridController.text,
      'drawing': drawingController.text,
      'filling': fillingController.text
    });

    FirebaseFirestore.instance
        .collection('CivilChecklistField')
        .doc(depoName)
        .collection('userId')
        .doc(userId)
        .set({'deponame': depoName});
  }
}
