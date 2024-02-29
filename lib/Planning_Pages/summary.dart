import 'dart:convert';
import 'package:assingment/Planning_Pages/quality_checklist.dart';
import 'package:assingment/datasource/energymanagement_datasource.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:assingment/model/energy_management.dart';
import 'package:assingment/overview/daily_project.dart';
import 'package:assingment/provider/checkbox_provider.dart';
import 'package:assingment/widget/custom_appbar.dart';
import 'package:assingment/widget/loading_pdf.dart';
import 'package:assingment/widget/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../Authentication/auth_service.dart';
import '../components/loading_page.dart';
import '../datasource/dailyproject_datasource.dart';
import '../datasource/monthlyproject_datasource.dart';
import '../datasource/safetychecklist_datasource.dart';
import '../model/daily_projectModel.dart';
import '../model/monthly_projectModel.dart';
import '../model/safety_checklistModel.dart';
import '../provider/summary_provider.dart';
import '../widget/date_input_format.dart';
import '../widget/nodata_available.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as path;
import 'dart:html' as html;

class ViewSummary extends StatefulWidget {
  String? depoName;
  String? cityName;
  String? id;
  String? selectedtab;
  bool isHeader;
  String? currentDate;
  dynamic userId;

  ViewSummary(
      {super.key,
      required this.depoName,
      required this.cityName,
      required this.id,
      this.userId,
      this.selectedtab,
      this.currentDate,
      this.isHeader = false});

  @override
  State<ViewSummary> createState() => _ViewSummaryState();
}

class _ViewSummaryState extends State<ViewSummary> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formkeyenddate = GlobalKey<FormState>();
  final GlobalKey<FormState> _formkeymontlydate = GlobalKey<FormState>();
  SummaryProvider? _summaryProvider;
  Future<List<DailyProjectModel>>? _dailydata;
  Future<List<EnergyManagementModel>>? _energydata;
  DateTime? startdate = DateTime.now();
  DateTime? enddate = DateTime.now();
  DateTime? rangestartDate;
  DateTime? rangeEndDate;

  List<MonthlyProjectModel> monthlyProject = <MonthlyProjectModel>[];
  List<SafetyChecklistModel> safetylisttable = <SafetyChecklistModel>[];
  late MonthlyDataSource monthlyDataSource;
  late SafetyChecklistDataSource _safetyChecklistDataSource;
  late DataGridController _dataGridController;
  List<DailyProjectModel> dailyproject = <DailyProjectModel>[];
  List<EnergyManagementModel> energymanagement = <EnergyManagementModel>[];
  late EnergyManagementDatasource _energyManagementDatasource;
  late DailyDataSource _dailyDataSource;
  List<dynamic> tabledata2 = [];
  Stream? _dailystream;
  var alldata;
  bool _isLoading = false;
  dynamic userId;
  ProgressDialog? pr;
  String url = '';
  bool sendReport = true;
  CheckboxProvider? _checkboxProvider;
  List<int> pdfData = [];
  String? pdfPath;

  @override
  void initState() {
    _checkboxProvider = Provider.of<CheckboxProvider>(context, listen: false);
    _checkboxProvider!.fetchCcMaidId();
    _checkboxProvider!.fetchToMaidId();
    pr = ProgressDialog(context,
        customBody:
            Container(height: 200, width: 100, child: const LoadingPdf()));

    super.initState();
    _summaryProvider = Provider.of<SummaryProvider>(context, listen: false);

    getUserId().then((value) {
      Stream _stream = FirebaseFirestore.instance
          .collection('MonthlyProjectReport2')
          .doc('${widget.depoName}')
          // .collection('AllMonthData')
          .collection('userId')
          .doc(userId)
          .collection('Monthly Data')
          // .collection('MonthData')
          .doc(DateFormat.yMMM().format(startdate!))
          .snapshots();
      _isLoading = false;
      // widget.id == 'Daily Report'
      //     ? _summaryProvider!
      //         .fetchdailydata(widget.depoName!, userId, startdate!, enddate!)
      //     : '';
    });
    print('Hello worlds');
  }

  @override
  Widget build(BuildContext context) {
    final List<String> _monthsuggestion = [
      'January 2024',
      'February 2024',
      'March 2024',
      'April 2024',
      'May 2024',
      'June 2024',
      'July 2024',
      'August 2024',
      'September 2024',
      'October 2024',
      'November 2024',
      'December 2024',
    ];
    final List<String> _suggestions = [
      'January 24, 2024',
      'February 24, 2024',
      'March 24, 2024',
      'April 24, 2024',
      'May 24, 2024',
      'June 24, 2024',
      'July 24, 2024',
      'August 24, 2024',
      'September 24, 2024',
      'October 24, 2024',
      'November 24, 2024',
      'December 24, 2024',
    ];
    widget.id == 'Daily Report'
        ? _summaryProvider!.fetchdailydata(
            widget.depoName!,
            widget.userId,
            startdate!,
            enddate!,
          )
        : '';
    widget.id == 'Energy Management'
        ? _summaryProvider!.fetchEnergyData(widget.cityName!, widget.depoName!,
            widget.userId, startdate!, enddate!)
        : '';
    final RegExp _dateRegExp = RegExp(
      r'^(January|February|March|April|May|June|July|August|September|October|November|December) (0[1-9]|[12][0-9]|3[01]), \d{4}$',
    );

    final RegExp _monthlydateRegExp = RegExp(
      r'^(January|February|March|April|May|June|July|August|September|October|November|December) \d{4}$',
    );

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomAppBar(
              sendEmail: () {
                setState(() {
                  sendReport = false;
                });
                _showCheckboxDialog(
                    context, _checkboxProvider!, widget.depoName!);
              },
              haveSend: true,
              depotName: widget.depoName,
              cityname: widget.cityName,
              donwloadFunction: widget.id == 'Daily Report'
                  ? _generateDailyPDF
                  : widget.id == 'Monthly Report'
                      ? _generateMonthlyPdf
                      : widget.id == 'Energy Management'
                          ? _generateEnergyPDF
                          : _generateSafetyPDF,
              isDownload: true,
              text:
                  ' ${widget.cityName} / ${widget.depoName} / ${widget.id} / View Summary'),
        ),
        // AppBar(
        //   title: Text(
        //       ' ${widget.cityName} / ${widget.depoName} / ${widget.id} / View Summary'),
        //   backgroundColor: blue,
        // ),
        body: _isLoading
            ? LoadingPage()
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: widget.id == 'Daily Report' ||
                            widget.id == 'Energy Management'
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 10, bottom: 25),
                                            child: IconButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: const Text(
                                                          'Choose Date'),
                                                      content: SizedBox(
                                                        width: 400,
                                                        height: 500,
                                                        child:
                                                            SfDateRangePicker(
                                                          view:
                                                              DateRangePickerView
                                                                  .year,
                                                          showTodayButton:
                                                              false,
                                                          showActionButtons:
                                                              true,
                                                          selectionMode:
                                                              DateRangePickerSelectionMode
                                                                  .range,
                                                          onSelectionChanged:
                                                              (DateRangePickerSelectionChangedArgs
                                                                  args) {
                                                            if (args.value
                                                                is PickerDateRange) {
                                                              rangestartDate =
                                                                  args.value
                                                                      .startDate;
                                                              rangeEndDate =
                                                                  args.value
                                                                      .endDate;
                                                            }
                                                          },
                                                          onSubmit: (value) {
                                                            dailyproject
                                                                .clear();
                                                            setState(() {
                                                              startdate = DateTime.parse(
                                                                  rangestartDate
                                                                      .toString());
                                                              enddate = DateTime
                                                                  .parse(rangeEndDate
                                                                      .toString());
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          onCancel: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.today,
                                                  color: blue,
                                                  size: 35,
                                                )),
                                          ),
                                          Container(
                                            width: 180,
                                            height: 75,
                                            child: Form(
                                              key: _formkey,
                                              child: Column(
                                                children: [
                                                  TypeAheadFormField<String>(
                                                    textFieldConfiguration:
                                                        TextFieldConfiguration(
                                                      controller:
                                                          TextEditingController(
                                                              text: DateFormat
                                                                      .yMMMMd()
                                                                  .format(
                                                                      startdate!)),
                                                      decoration:
                                                          const InputDecoration(
                                                              // labelText:
                                                              //     'Type a fruit...',
                                                              ),
                                                      onSubmitted: (value) {
                                                        if (_formkey
                                                            .currentState!
                                                            .validate()) {
                                                          DateInputFormatter(
                                                              _dateRegExp);
                                                          print(value);
                                                          DateTime date =
                                                              DateFormat(
                                                                      'MMMM d, yyyy')
                                                                  .parse(value);

                                                          setState(() {
                                                            startdate = date;
                                                          });
                                                        }
                                                      },
                                                      inputFormatters: [
                                                        // Apply your input formatting logic here
                                                        FilteringTextInputFormatter
                                                            .allow(RegExp(
                                                                r'[A-Za-z0-9 ,]')),
                                                      ],
                                                    ),
                                                    suggestionsCallback:
                                                        (pattern) {
                                                      // Apply formatting logic to the pattern here if needed
                                                      final formattedPattern =
                                                          pattern.replaceAll(
                                                              RegExp(
                                                                  r'[^\w\s]+'),
                                                              '');

                                                      // Filter suggestions based on the formatted pattern
                                                      return _suggestions.where(
                                                          (fruit) => fruit
                                                              .toLowerCase()
                                                              .contains(
                                                                  formattedPattern
                                                                      .toLowerCase()));
                                                    },
                                                    itemBuilder:
                                                        (context, suggestion) {
                                                      return ListTile(
                                                        title: Text(suggestion),
                                                      );
                                                    },
                                                    transitionBuilder: (context,
                                                        suggestionsBox,
                                                        controller) {
                                                      return suggestionsBox;
                                                    },
                                                    onSuggestionSelected:
                                                        (suggestion) {
                                                      DateTime date = DateFormat(
                                                              'MMMM d, yyyy')
                                                          .parse(suggestion);

                                                      setState(() {
                                                        startdate = date;
                                                      });
                                                      // Handle the selected suggestion
                                                    },
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter a date';
                                                      }

                                                      if (!RegExp(
                                                              r'^(January|February|March|April|May|June|July|August|September|October|November|December) ([1-9]|[12][0-9]|3[1]), \d{4}$')
                                                          .hasMatch(value)) {
                                                        return 'E.g., February 22, 2024';
                                                      }
                                                      return null;
                                                    },
                                                  ),

                                                  // TextFormField(
                                                  //   textInputAction:
                                                  //       TextInputAction.done,
                                                  //   inputFormatters: [
                                                  //     FilteringTextInputFormatter
                                                  //         .allow(RegExp(
                                                  //             r'[A-Za-z0-9 ,]')),
                                                  //   ],
                                                  //   decoration:
                                                  //       const InputDecoration(
                                                  //     hintText:
                                                  //         'February 20, 2024',
                                                  //     // enabledBorder:
                                                  //     //     ,
                                                  //     // focusedBorder:
                                                  //     //     InputBorder.none,
                                                  //   ),
                                                  //   validator: (value) {
                                                  //     if (value == null ||
                                                  //         value.isEmpty) {
                                                  //       return 'Please enter a date';
                                                  //     }

                                                  //     if (!RegExp(
                                                  //             r'^(January|February|March|April|May|June|July|August|September|October|November|December) ([1-9]|[12][0-9]|3[1]), \d{4}$')
                                                  //         .hasMatch(value)) {
                                                  //       return 'E.g., February 22, 2024';
                                                  //     }
                                                  //     return null;
                                                  //   },
                                                  //   onFieldSubmitted: (value) {
                                                  //     if (_formkey.currentState!
                                                  //         .validate()) {
                                                  //       DateInputFormatter(
                                                  //           _dateRegExp);
                                                  //       print(value);
                                                  //       DateTime date = DateFormat(
                                                  //               'MMMM d, yyyy')
                                                  //           .parse(value);

                                                  //       setState(() {
                                                  //         startdate = date;
                                                  //       });
                                                  //     }
                                                  //   },
                                                  //   controller: TextEditingController(
                                                  //       text: widget.id ==
                                                  //               'Monthly Report'
                                                  //           ? DateFormat.yMMMM()
                                                  //               .format(
                                                  //                   startdate!)
                                                  //           : DateFormat
                                                  //                   .yMMMMd()
                                                  //               .format(
                                                  //                   startdate!)),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ),

                                          // Text(widget.id == 'Monthly Report'
                                          //     ? DateFormat.yMMMM()
                                          //         .format(startdate!)
                                          //     : DateFormat.yMMMMd()
                                          //         .format(startdate!))
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 180,
                                        height: 75,
                                        child: Form(
                                          key: _formkeyenddate,
                                          child: Column(
                                            children: [
                                              TypeAheadFormField<String>(
                                                textFieldConfiguration:
                                                    TextFieldConfiguration(
                                                  controller:
                                                      TextEditingController(
                                                          text: DateFormat
                                                                  .yMMMMd()
                                                              .format(
                                                                  enddate!)),
                                                  decoration:
                                                      const InputDecoration(
                                                          // labelText:
                                                          //     'Type a fruit...',
                                                          ),
                                                  onSubmitted: (value) {
                                                    if (_formkeyenddate
                                                        .currentState!
                                                        .validate()) {
                                                      DateInputFormatter(
                                                          _dateRegExp);
                                                      print(value);
                                                      DateTime date = DateFormat(
                                                              'MMMM d, yyyy')
                                                          .parse(value);

                                                      setState(() {
                                                        enddate = date;
                                                      });
                                                    }
                                                  },
                                                  inputFormatters: [
                                                    // Apply your input formatting logic here
                                                    FilteringTextInputFormatter
                                                        .allow(RegExp(
                                                            r'[A-Za-z0-9 ,]')),
                                                  ],
                                                ),
                                                suggestionsCallback: (pattern) {
                                                  // Apply formatting logic to the pattern here if needed
                                                  final formattedPattern =
                                                      pattern.replaceAll(
                                                          RegExp(r'[^\w\s]+'),
                                                          '');

                                                  // Filter suggestions based on the formatted pattern
                                                  return _suggestions.where(
                                                      (fruit) => fruit
                                                          .toLowerCase()
                                                          .contains(
                                                              formattedPattern
                                                                  .toLowerCase()));
                                                },
                                                itemBuilder:
                                                    (context, suggestion) {
                                                  return ListTile(
                                                    title: Text(suggestion),
                                                  );
                                                },
                                                transitionBuilder: (context,
                                                    suggestionsBox,
                                                    controller) {
                                                  return suggestionsBox;
                                                },
                                                onSuggestionSelected:
                                                    (suggestion) {
                                                  DateTime date =
                                                      DateFormat('MMMM d, yyyy')
                                                          .parse(suggestion);

                                                  setState(() {
                                                    enddate = date;
                                                  });
                                                  // Handle the selected suggestion
                                                },
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please enter a date';
                                                  }

                                                  if (!RegExp(
                                                          r'^(January|February|March|April|May|June|July|August|September|October|November|December) ([1-9]|[12][0-9]|3[1]), \d{4}$')
                                                      .hasMatch(value)) {
                                                    return 'E.g., February 22, 2024';
                                                  }
                                                  return null;
                                                },
                                              ),

                                              // TextFormField(
                                              //   textInputAction:
                                              //       TextInputAction.done,
                                              //   inputFormatters: [
                                              //     FilteringTextInputFormatter
                                              //         .allow(RegExp(
                                              //             r'[A-Za-z0-9 ,]')),
                                              //   ],
                                              //   decoration:
                                              //       const InputDecoration(
                                              //     hintText:
                                              //         'February 20, 2024',
                                              //     // enabledBorder:
                                              //     //     ,
                                              //     // focusedBorder:
                                              //     //     InputBorder.none,
                                              //   ),
                                              //   validator: (value) {
                                              //     if (value == null ||
                                              //         value.isEmpty) {
                                              //       return 'Please enter a date';
                                              //     }

                                              //     if (!RegExp(
                                              //             r'^(January|February|March|April|May|June|July|August|September|October|November|December) ([1-9]|[12][0-9]|3[1]), \d{4}$')
                                              //         .hasMatch(value)) {
                                              //       return 'E.g., February 22, 2024';
                                              //     }
                                              //     return null;
                                              //   },
                                              //   onFieldSubmitted: (value) {
                                              //     if (_formkey.currentState!
                                              //         .validate()) {
                                              //       DateInputFormatter(
                                              //           _dateRegExp);
                                              //       print(value);
                                              //       DateTime date = DateFormat(
                                              //               'MMMM d, yyyy')
                                              //           .parse(value);

                                              //       setState(() {
                                              //         startdate = date;
                                              //       });
                                              //     }
                                              //   },
                                              //   controller: TextEditingController(
                                              //       text: widget.id ==
                                              //               'Monthly Report'
                                              //           ? DateFormat.yMMMM()
                                              //               .format(
                                              //                   startdate!)
                                              //           : DateFormat
                                              //                   .yMMMMd()
                                              //               .format(
                                              //                   startdate!)),
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Row(
                                      //   children: [
                                      //     Text(
                                      //       DateFormat.yMMMMd()
                                      //           .format(enddate!),
                                      //       textAlign: TextAlign.center,
                                      //     )
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, bottom: 25),
                                    child: IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('choose Date'),
                                              content: SizedBox(
                                                width: 400,
                                                height: 500,
                                                child: SfDateRangePicker(
                                                  view:
                                                      DateRangePickerView.month,
                                                  showTodayButton: false,
                                                  showActionButtons: true,
                                                  selectionMode:
                                                      DateRangePickerSelectionMode
                                                          .single,
                                                  onSelectionChanged:
                                                      (DateRangePickerSelectionChangedArgs
                                                          args) {
                                                    if (args.value
                                                        is PickerDateRange) {
                                                      rangestartDate =
                                                          args.value.startDate;
                                                    }
                                                  },
                                                  onSubmit: (value) {
                                                    setState(() {
                                                      startdate =
                                                          DateTime.parse(
                                                              value.toString());
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  onCancel: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        icon: Icon(
                                          Icons.today,
                                          color: blue,
                                          size: 35,
                                        )),
                                  ),

                                  Container(
                                    width: 180,
                                    height: 75,
                                    child: Form(
                                      key: _formkeymontlydate,
                                      child: Column(
                                        children: [
                                          TypeAheadFormField<String>(
                                            textFieldConfiguration:
                                                TextFieldConfiguration(
                                              controller: TextEditingController(
                                                  text: DateFormat.yMMMM()
                                                      .format(startdate!)),
                                              decoration: const InputDecoration(
                                                  // labelText:
                                                  //     'Type a fruit...',
                                                  ),
                                              onSubmitted: (value) {
                                                if (_formkeymontlydate
                                                    .currentState!
                                                    .validate()) {
                                                  DateInputFormatter(
                                                      _monthlydateRegExp);
                                                  print(value);
                                                  DateTime date =
                                                      DateFormat('MMMM d, yyyy')
                                                          .parse(value);

                                                  setState(() {
                                                    startdate = date;
                                                  });
                                                }
                                              },
                                              inputFormatters: [
                                                // Apply your input formatting logic here
                                                FilteringTextInputFormatter
                                                    .allow(RegExp(
                                                        r'[A-Za-z0-9 ,]')),
                                              ],
                                            ),
                                            suggestionsCallback: (pattern) {
                                              // Apply formatting logic to the pattern here if needed
                                              final formattedPattern =
                                                  pattern.replaceAll(
                                                      RegExp(r'[^\w\s]+'), '');

                                              // Filter suggestions based on the formatted pattern
                                              return _monthsuggestion.where(
                                                  (fruit) => fruit
                                                      .toLowerCase()
                                                      .contains(formattedPattern
                                                          .toLowerCase()));
                                            },
                                            itemBuilder: (context, suggestion) {
                                              return ListTile(
                                                title: Text(suggestion),
                                              );
                                            },
                                            transitionBuilder: (context,
                                                suggestionsBox, controller) {
                                              return suggestionsBox;
                                            },
                                            onSuggestionSelected: (suggestion) {
                                              DateTime date =
                                                  DateFormat('MMMM yyyy')
                                                      .parse(suggestion);

                                              setState(() {
                                                startdate = date;
                                              });
                                              // Handle the selected suggestion
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter a date';
                                              }

                                              if (!RegExp(
                                                      r'^(January|February|March|April|May|June|July|August|September|October|November|December) \d{4}$')
                                                  .hasMatch(value)) {
                                                return 'E.g., February 2024';
                                              }
                                              return null;
                                            },
                                          ),

                                          // TextFormField(
                                          //   textInputAction:
                                          //       TextInputAction.done,
                                          //   inputFormatters: [
                                          //     FilteringTextInputFormatter
                                          //         .allow(RegExp(
                                          //             r'[A-Za-z0-9 ,]')),
                                          //   ],
                                          //   decoration:
                                          //       const InputDecoration(
                                          //     hintText:
                                          //         'February 20, 2024',
                                          //     // enabledBorder:
                                          //     //     ,
                                          //     // focusedBorder:
                                          //     //     InputBorder.none,
                                          //   ),
                                          //   validator: (value) {
                                          //     if (value == null ||
                                          //         value.isEmpty) {
                                          //       return 'Please enter a date';
                                          //     }

                                          //     if (!RegExp(
                                          //             r'^(January|February|March|April|May|June|July|August|September|October|November|December) ([1-9]|[12][0-9]|3[1]), \d{4}$')
                                          //         .hasMatch(value)) {
                                          //       return 'E.g., February 22, 2024';
                                          //     }
                                          //     return null;
                                          //   },
                                          //   onFieldSubmitted: (value) {
                                          //     if (_formkey.currentState!
                                          //         .validate()) {
                                          //       DateInputFormatter(
                                          //           _dateRegExp);
                                          //       print(value);
                                          //       DateTime date = DateFormat(
                                          //               'MMMM d, yyyy')
                                          //           .parse(value);

                                          //       setState(() {
                                          //         startdate = date;
                                          //       });
                                          //     }
                                          //   },
                                          //   controller: TextEditingController(
                                          //       text: widget.id ==
                                          //               'Monthly Report'
                                          //           ? DateFormat.yMMMM()
                                          //               .format(
                                          //                   startdate!)
                                          //           : DateFormat
                                          //                   .yMMMMd()
                                          //               .format(
                                          //                   startdate!)),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  // Container(
                                  //   width: 180,
                                  //   height: 75,
                                  //   child: Form(
                                  //     key: _formkeymontlydate,
                                  //     child: TextFormField(
                                  //       textInputAction: TextInputAction.done,
                                  //       inputFormatters: [
                                  //         FilteringTextInputFormatter.allow(
                                  //             RegExp(r'[A-Za-z0-9 ,]')),
                                  //       ],
                                  //       decoration: const InputDecoration(
                                  //         hintText: 'February 2024',
                                  //         // enabledBorder:
                                  //         //     ,
                                  //         // focusedBorder:
                                  //         //     InputBorder.none,
                                  //       ),
                                  //       validator: (value) {
                                  //         if (value == null || value.isEmpty) {
                                  //           return 'Please enter a date';
                                  //         }

                                  //         if (!RegExp(
                                  //                 r'^(January|February|March|April|May|June|July|August|September|October|November|December) \d{4}$')
                                  //             .hasMatch(value)) {
                                  //           return 'E.g., February 2024';
                                  //         }
                                  //         return null;
                                  //       },
                                  //       onFieldSubmitted: (value) {
                                  //         if (_formkeymontlydate.currentState!
                                  //             .validate()) {
                                  //           DateInputFormatter(
                                  //               _monthlydateRegExp);
                                  //           print(value);
                                  //           DateTime date =
                                  //               DateFormat('MMMM yyyy')
                                  //                   .parse(value);

                                  //           setState(() {
                                  //             startdate = date;
                                  //           });
                                  //         }
                                  //       },
                                  //       controller: TextEditingController(
                                  //           text: widget.id == 'Monthly Report'
                                  //               ? DateFormat.yMMMM()
                                  //                   .format(startdate!)
                                  //               : DateFormat.yMMMMd()
                                  //                   .format(startdate!)),
                                  //     ),
                                  //   ),
                                  // )

                                  // Container(
                                  //   width: 200,
                                  //   height: 40,
                                  //   padding:
                                  //       const EdgeInsets.only(bottom: 12),
                                  //   child: TextField(
                                  //     decoration: const InputDecoration(
                                  //       enabledBorder: InputBorder.none,
                                  //       focusedBorder: InputBorder.none,
                                  //     ),
                                  //     onSubmitted: (value) {
                                  //       print(value);
                                  //       DateTime date =
                                  //           DateFormat('MMMM yyyy')
                                  //               .parse(value);

                                  //       setState(() {
                                  //         startdate = date;
                                  //       });
                                  //     },
                                  //     controller: TextEditingController(
                                  //         text: widget.id == 'Monthly Report'
                                  //             ? DateFormat.yMMMM()
                                  //                 .format(startdate!)
                                  //             : DateFormat.yMMMMd()
                                  //                 .format(startdate!)),
                                  //   ),
                                  // )

                                  // Text(widget.id == 'Monthly Report'
                                  //     ? DateFormat.yMMMM().format(startdate!)
                                  //     : DateFormat.yMMMMd()
                                  //         .format(startdate!))
                                ],
                              ),
                            ],
                          ),
                  ),
                  widget.id == 'Monthly Report'
                      ? Expanded(
                          child: StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('MonthlyProjectReport2')
                                  .doc('${widget.depoName}')
                                  .collection('userId')
                                  .doc(widget.userId)
                                  .collection('Monthly Data')
                                  .doc(DateFormat.yMMM().format(startdate!))
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return LoadingPage();
                                }
                                if (!snapshot.hasData ||
                                    snapshot.data!.exists == false) {
                                  return const NodataAvailable();
                                } else {
                                  alldata = '';
                                  alldata =
                                      snapshot.data!['data'] as List<dynamic>;
                                  monthlyProject.clear();
                                  alldata.forEach((element) {
                                    monthlyProject.add(
                                        MonthlyProjectModel.fromjson(element));

                                    monthlyDataSource = MonthlyDataSource(
                                        monthlyProject, context);
                                    _dataGridController = DataGridController();
                                  });
                                  return Column(
                                    children: [
                                      Expanded(
                                          child: SfDataGridTheme(
                                        data: SfDataGridThemeData(
                                          headerColor: white,
                                          gridLineColor: blue,
                                        ),
                                        child: SfDataGrid(
                                            source: monthlyDataSource,
                                            allowEditing: true,
                                            frozenColumnsCount: 2,
                                            gridLinesVisibility:
                                                GridLinesVisibility.both,
                                            headerGridLinesVisibility:
                                                GridLinesVisibility.both,
                                            selectionMode: SelectionMode.single,
                                            navigationMode:
                                                GridNavigationMode.cell,
                                            columnWidthMode:
                                                ColumnWidthMode.auto,
                                            rowHeight: 50,
                                            headerRowHeight: 50,
                                            editingGestureType:
                                                EditingGestureType.tap,
                                            controller: _dataGridController,
                                            onQueryRowHeight: (details) {
                                              return details
                                                  .getIntrinsicRowHeight(
                                                      details.rowIndex);
                                            },
                                            columns: [
                                              GridColumn(
                                                columnName: 'ActivityNo',
                                                allowEditing: true,
                                                width: 160,
                                                label: Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'Si. No (as per Gant Chart)',
                                                    overflow: TextOverflow
                                                        .values.first,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14,
                                                        color: blue),
                                                  ),
                                                ),
                                              ),
                                              GridColumn(
                                                columnName: 'ActivityDetails',
                                                allowEditing: true,
                                                width: 240,
                                                label: Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                      'Activities Details',
                                                      textAlign:
                                                          TextAlign.center,
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
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
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
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
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
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
                                                  child: Text(
                                                      'Next Month Action Plan',
                                                      overflow: TextOverflow
                                                          .values.first,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
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
                        )
                      : widget.id == 'Daily Report'
                          ? Expanded(
                              child: Consumer<SummaryProvider>(
                                builder: (context, value, child) {
                                  return FutureBuilder(
                                    future: _dailydata,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return LoadingPage();
                                      }
                                      if (snapshot.hasData) {
                                        if (snapshot.data == null ||
                                            snapshot.data!.length == 0) {
                                          return const Center(
                                            child: Text(
                                              "No Data Found!!",
                                              style: TextStyle(fontSize: 25.0),
                                            ),
                                          );
                                        } else {
                                          return LoadingPage();
                                        }
                                      } else {
                                        dailyproject = value.dailydata;
                                        _dailyDataSource = DailyDataSource(
                                          dailyproject,
                                          context,
                                          widget.cityName!,
                                          widget.depoName!,
                                          selectedDate!,
                                          widget.userId,
                                        );
                                        _dataGridController =
                                            DataGridController();

                                        return SfDataGridTheme(
                                          data: SfDataGridThemeData(
                                              headerColor: white,
                                              gridLineColor: blue),
                                          child: SfDataGrid(
                                              source: _dailyDataSource,
                                              allowEditing: true,
                                              frozenColumnsCount: 2,
                                              gridLinesVisibility:
                                                  GridLinesVisibility.both,
                                              headerGridLinesVisibility:
                                                  GridLinesVisibility.both,
                                              selectionMode:
                                                  SelectionMode.single,
                                              rowHeight: 50,
                                              headerRowHeight: 50,
                                              navigationMode:
                                                  GridNavigationMode.cell,
                                              columnWidthMode:
                                                  ColumnWidthMode.auto,
                                              editingGestureType:
                                                  EditingGestureType.tap,
                                              controller: _dataGridController,
                                              onQueryRowHeight: (details) {
                                                return details
                                                    .getIntrinsicRowHeight(
                                                        details.rowIndex);
                                              },
                                              columns: [
                                                GridColumn(
                                                  columnName: 'Date',
                                                  visible: true,
                                                  allowEditing: false,
                                                  width: 150,
                                                  label: Container(
                                                    alignment: Alignment.center,
                                                    child: Text('Date',
                                                        overflow: TextOverflow
                                                            .values.first,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                            color: blue)
                                                        //    textAlign: TextAlign.center,
                                                        ),
                                                  ),
                                                ),
                                                GridColumn(
                                                  visible: false,
                                                  columnName: 'SiNo',
                                                  allowEditing: false,
                                                  width: 70,
                                                  label: Container(
                                                    alignment: Alignment.center,
                                                    child: Text('SI No.',
                                                        overflow: TextOverflow
                                                            .values.first,
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                            color: blue)
                                                        //    textAlign: TextAlign.center,
                                                        ),
                                                  ),
                                                ),
                                                GridColumn(
                                                  columnName: 'TypeOfActivity',
                                                  allowEditing: false,
                                                  width: 200,
                                                  label: Container(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                        'Type of Activity',
                                                        overflow: TextOverflow
                                                            .values.first,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                            color: blue)
                                                        //    textAlign: TextAlign.center,
                                                        ),
                                                  ),
                                                ),
                                                GridColumn(
                                                  columnName: 'ActivityDetails',
                                                  allowEditing: false,
                                                  width: 220,
                                                  label: Container(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                        'Activity Details',
                                                        overflow: TextOverflow
                                                            .values.first,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                            color: blue)
                                                        //    textAlign: TextAlign.center,
                                                        ),
                                                  ),
                                                ),
                                                GridColumn(
                                                  columnName: 'Progress',
                                                  allowEditing: false,
                                                  width: 320,
                                                  label: Container(
                                                    alignment: Alignment.center,
                                                    child: Text('Progress',
                                                        overflow: TextOverflow
                                                            .values.first,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                            color: blue)
                                                        //    textAlign: TextAlign.center,
                                                        ),
                                                  ),
                                                ),
                                                GridColumn(
                                                  columnName: 'Status',
                                                  allowEditing: false,
                                                  width: 320,
                                                  label: Container(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                        'Remark / Status',
                                                        overflow: TextOverflow
                                                            .values.first,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                            color: blue)
                                                        //    textAlign: TextAlign.center,
                                                        ),
                                                  ),
                                                ),
                                                GridColumn(
                                                  visible: false,
                                                  columnName: 'upload',
                                                  allowEditing: false,
                                                  width: 150,
                                                  label: Container(
                                                    alignment: Alignment.center,
                                                    child: Text('Upload Image',
                                                        overflow: TextOverflow
                                                            .values.first,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                            color: blue)
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
                                                    child: Text('View Image',
                                                        overflow: TextOverflow
                                                            .values.first,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                            color: blue)
                                                        //    textAlign: TextAlign.center,
                                                        ),
                                                  ),
                                                ),
                                                GridColumn(
                                                  visible: false,
                                                  columnName: 'Add',
                                                  allowEditing: false,
                                                  width: 120,
                                                  label: Container(
                                                    alignment: Alignment.center,
                                                    child: Text('Add Row',
                                                        overflow: TextOverflow
                                                            .values.first,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                            color: blue)
                                                        //    textAlign: TextAlign.center,
                                                        ),
                                                  ),
                                                ),
                                                GridColumn(
                                                  columnName: 'Delete',
                                                  allowEditing: false,
                                                  visible: false,
                                                  width: 120,
                                                  label: Container(
                                                    alignment: Alignment.center,
                                                    child: Text('Delete Row',
                                                        overflow: TextOverflow
                                                            .values.first,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                            color: blue)
                                                        //    textAlign: TextAlign.center,
                                                        ),
                                                  ),
                                                ),
                                              ]),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            )
                          : widget.id == 'Quality Checklist'
                              ? Expanded(
                                  child: QualityChecklist(
                                      currentDate: DateFormat.yMMMMd()
                                          .format(startdate!),
                                      isHeader: widget.isHeader,
                                      cityName: widget.cityName,
                                      depoName: widget.depoName))
                              : widget.id == 'Energy Management'
                                  ? Expanded(
                                      child: Consumer<SummaryProvider>(
                                        builder: (context, value, child) {
                                          return FutureBuilder(
                                            future: _energydata,
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                if (snapshot.data == null ||
                                                    snapshot.data!.length ==
                                                        0) {
                                                  return const Center(
                                                    child: Text(
                                                      "No Data Found!!",
                                                      style: TextStyle(
                                                          fontSize: 25.0),
                                                    ),
                                                  );
                                                } else {
                                                  return LoadingPage();
                                                }
                                              } else {
                                                energymanagement =
                                                    value.energyData;
                                                _energyManagementDatasource =
                                                    EnergyManagementDatasource(
                                                        energymanagement,
                                                        context,
                                                        userId,
                                                        widget.cityName,
                                                        widget.depoName);

                                                _dataGridController =
                                                    DataGridController();

                                                return Column(
                                                  children: [
                                                    SfDataGridTheme(
                                                        data:
                                                            SfDataGridThemeData(
                                                                headerColor:
                                                                    white,
                                                                gridLineColor:
                                                                    blue),
                                                        child: SfDataGrid(
                                                          source:
                                                              _energyManagementDatasource,
                                                          allowEditing: false,
                                                          frozenColumnsCount: 2,
                                                          rowHeight: 50,
                                                          headerRowHeight: 50,
                                                          gridLinesVisibility:
                                                              GridLinesVisibility
                                                                  .both,
                                                          headerGridLinesVisibility:
                                                              GridLinesVisibility
                                                                  .both,
                                                          selectionMode:
                                                              SelectionMode
                                                                  .single,
                                                          navigationMode:
                                                              GridNavigationMode
                                                                  .cell,
                                                          columnWidthMode:
                                                              ColumnWidthMode
                                                                  .auto,
                                                          editingGestureType:
                                                              EditingGestureType
                                                                  .tap,
                                                          controller:
                                                              _dataGridController,
                                                          onQueryRowHeight:
                                                              (details) {
                                                            return details
                                                                .getIntrinsicRowHeight(
                                                                    details
                                                                        .rowIndex);
                                                          },
                                                          columns: [
                                                            GridColumn(
                                                              visible: false,
                                                              columnName:
                                                                  'srNo',
                                                              allowEditing:
                                                                  false,
                                                              label: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    'Sr No',
                                                                    overflow: TextOverflow
                                                                        .values
                                                                        .first,
                                                                    style:
                                                                        tableheaderwhitecolor
                                                                    //    textAlign: TextAlign.center,
                                                                    ),
                                                              ),
                                                            ),
                                                            GridColumn(
                                                              columnName:
                                                                  'DepotName',
                                                              width: 180,
                                                              allowEditing:
                                                                  false,
                                                              label: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    'Depot Name',
                                                                    overflow: TextOverflow
                                                                        .values
                                                                        .first,
                                                                    style:
                                                                        tableheaderwhitecolor),
                                                              ),
                                                            ),
                                                            GridColumn(
                                                              columnName:
                                                                  'VehicleNo',
                                                              width: 180,
                                                              allowEditing:
                                                                  true,
                                                              label: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    'Vehicle No',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        tableheaderwhitecolor),
                                                              ),
                                                            ),
                                                            GridColumn(
                                                              columnName:
                                                                  'pssNo',
                                                              width: 80,
                                                              allowEditing:
                                                                  true,
                                                              label: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    'PSS No',
                                                                    style:
                                                                        tableheaderwhitecolor),
                                                              ),
                                                            ),
                                                            GridColumn(
                                                              columnName:
                                                                  'chargerId',
                                                              width: 80,
                                                              allowEditing:
                                                                  true,
                                                              label: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    'Charger ID',
                                                                    overflow: TextOverflow
                                                                        .values
                                                                        .first,
                                                                    style:
                                                                        tableheaderwhitecolor),
                                                              ),
                                                            ),
                                                            GridColumn(
                                                              columnName:
                                                                  'startSoc',
                                                              allowEditing:
                                                                  true,
                                                              width: 80,
                                                              label: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    'Start SOC',
                                                                    overflow: TextOverflow
                                                                        .values
                                                                        .first,
                                                                    style:
                                                                        tableheaderwhitecolor),
                                                              ),
                                                            ),
                                                            GridColumn(
                                                              columnName:
                                                                  'endSoc',
                                                              allowEditing:
                                                                  true,
                                                              columnWidthMode:
                                                                  ColumnWidthMode
                                                                      .fitByCellValue,
                                                              width: 80,
                                                              label: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    'End SOC',
                                                                    overflow: TextOverflow
                                                                        .values
                                                                        .first,
                                                                    style:
                                                                        tableheaderwhitecolor),
                                                              ),
                                                            ),
                                                            GridColumn(
                                                              columnName:
                                                                  'startDate',
                                                              allowEditing:
                                                                  false,
                                                              width: 230,
                                                              label: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    'Start Date & Time',
                                                                    overflow: TextOverflow
                                                                        .values
                                                                        .first,
                                                                    style:
                                                                        tableheaderwhitecolor),
                                                              ),
                                                            ),
                                                            GridColumn(
                                                              columnName:
                                                                  'endDate',
                                                              allowEditing:
                                                                  false,
                                                              width: 230,
                                                              label: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                      'End Date & Time',
                                                                      overflow: TextOverflow
                                                                          .values
                                                                          .first,
                                                                      style:
                                                                          tableheaderwhitecolor),
                                                                ),
                                                              ),
                                                            ),
                                                            GridColumn(
                                                              columnName:
                                                                  'totalTime',
                                                              allowEditing:
                                                                  false,
                                                              width: 180,
                                                              label: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    'Total time of Charging',
                                                                    overflow: TextOverflow
                                                                        .values
                                                                        .first,
                                                                    style:
                                                                        tableheaderwhitecolor),
                                                              ),
                                                            ),
                                                            GridColumn(
                                                              columnName:
                                                                  'energyConsumed',
                                                              allowEditing:
                                                                  true,
                                                              width: 160,
                                                              label: Container(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        16.0),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    'Engery Consumed (inkW)',
                                                                    overflow: TextOverflow
                                                                        .values
                                                                        .first,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        tableheaderwhitecolor),
                                                              ),
                                                            ),
                                                            GridColumn(
                                                              columnName:
                                                                  'timeInterval',
                                                              allowEditing:
                                                                  false,
                                                              width: 150,
                                                              label: Container(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    'Interval',
                                                                    overflow: TextOverflow
                                                                        .values
                                                                        .first,
                                                                    style:
                                                                        tableheaderwhitecolor),
                                                              ),
                                                            ),
                                                            GridColumn(
                                                              columnName: 'Add',
                                                              autoFitPadding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          16),
                                                              allowEditing:
                                                                  false,
                                                              width: 120,
                                                              label: Container(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    'Add Row',
                                                                    overflow: TextOverflow
                                                                        .values
                                                                        .first,
                                                                    style:
                                                                        tableheaderwhitecolor
                                                                    //    textAlign: TextAlign.center,
                                                                    ),
                                                              ),
                                                            ),
                                                            GridColumn(
                                                              columnName:
                                                                  'Delete',
                                                              autoFitPadding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          16),
                                                              allowEditing:
                                                                  false,
                                                              width: 120,
                                                              label: Container(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                child: Text(
                                                                    'Delete Row',
                                                                    overflow: TextOverflow
                                                                        .values
                                                                        .first,
                                                                    style:
                                                                        tableheaderwhitecolor
                                                                    //    textAlign: TextAlign.center,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        )),
                                                    Consumer<SummaryProvider>(
                                                        builder: (context,
                                                            value, child) {
                                                      // _summaryProvider!
                                                      //     .fetchEnergyData(
                                                      //         widget.cityName!,
                                                      //         widget.depoName!,
                                                      //         widget.userId,
                                                      //         startdate!,
                                                      //         enddate!);
                                                      return Container(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width,
                                                        height: 200,
                                                        child: BarChart(
                                                          swapAnimationCurve:
                                                              Curves.linear,
                                                          swapAnimationDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      1000),
                                                          BarChartData(
                                                            backgroundColor:
                                                                white,
                                                            barTouchData:
                                                                BarTouchData(
                                                              enabled: true,
                                                              allowTouchBarBackDraw:
                                                                  true,
                                                              touchTooltipData:
                                                                  BarTouchTooltipData(
                                                                tooltipRoundedRadius:
                                                                    5,
                                                                tooltipBgColor:
                                                                    Colors
                                                                        .transparent,
                                                                tooltipMargin:
                                                                    5,
                                                              ),
                                                            ),
                                                            minY: 0,
                                                            titlesData:
                                                                FlTitlesData(
                                                              bottomTitles:
                                                                  AxisTitles(
                                                                sideTitles:
                                                                    SideTitles(
                                                                  showTitles:
                                                                      true,
                                                                  getTitlesWidget:
                                                                      (data1,
                                                                          meta) {
                                                                    return Text(
                                                                      value.intervalData[
                                                                          data1
                                                                              .toInt()],
                                                                      style: const TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .bold,
                                                                          fontSize:
                                                                              12),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                              rightTitles:
                                                                  AxisTitles(
                                                                sideTitles:
                                                                    SideTitles(
                                                                        showTitles:
                                                                            false),
                                                              ),
                                                              topTitles:
                                                                  AxisTitles(
                                                                sideTitles:
                                                                    SideTitles(
                                                                  showTitles:
                                                                      false,
                                                                  getTitlesWidget:
                                                                      (data2,
                                                                          meta) {
                                                                    return Text(
                                                                      value.energyConsumedData[
                                                                          data2
                                                                              .toInt()],
                                                                      style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            gridData:
                                                                FlGridData(
                                                              drawHorizontalLine:
                                                                  true,
                                                              drawVerticalLine:
                                                                  true,
                                                            ),
                                                            borderData:
                                                                FlBorderData(
                                                              border:
                                                                  const Border(
                                                                left:
                                                                    BorderSide(),
                                                                bottom:
                                                                    BorderSide(),
                                                              ),
                                                            ),
                                                            maxY: (value.intervalData
                                                                        .isEmpty &&
                                                                    value
                                                                        .energyConsumedData
                                                                        .isEmpty)
                                                                ? 50000
                                                                : value
                                                                    .energyConsumedData
                                                                    .reduce((max,
                                                                            current) =>
                                                                        max > current
                                                                            ? max
                                                                            : current),
                                                            barGroups:
                                                                barChartGroupData(
                                                                    value
                                                                        .energyConsumedData),
                                                          ),
                                                        ),
                                                      );
                                                    })
                                                  ],
                                                );
                                              }
                                            },
                                          );
                                        },
                                      ),
                                    )
                                  : Expanded(
                                      child: StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('SafetyChecklistTable2')
                                            .doc(widget.depoName!)
                                            .collection('userId')
                                            .doc(widget.userId)
                                            .collection('date')
                                            .doc(DateFormat.yMMMMd()
                                                .format(startdate!))
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return LoadingPage();
                                          }
                                          if (!snapshot.hasData ||
                                              snapshot.data!.exists == false) {
                                            return const NodataAvailable();
                                          } else {
                                            alldata = '';
                                            alldata = snapshot.data!['data']
                                                as List<dynamic>;

                                            safetylisttable.clear();
                                            alldata.forEach((element) {
                                              safetylisttable.add(
                                                  SafetyChecklistModel.fromJson(
                                                      element));
                                              _safetyChecklistDataSource =
                                                  SafetyChecklistDataSource(
                                                      safetylisttable,
                                                      widget.cityName!,
                                                      widget.depoName!,
                                                      userId);
                                              _dataGridController =
                                                  DataGridController();
                                            });
                                            return SfDataGridTheme(
                                              data: SfDataGridThemeData(
                                                  headerColor: white,
                                                  gridLineColor: blue),
                                              child: SfDataGrid(
                                                source:
                                                    _safetyChecklistDataSource,
                                                //key: key,

                                                allowEditing: true,
                                                frozenColumnsCount: 2,
                                                gridLinesVisibility:
                                                    GridLinesVisibility.both,
                                                headerGridLinesVisibility:
                                                    GridLinesVisibility.both,
                                                selectionMode:
                                                    SelectionMode.single,
                                                navigationMode:
                                                    GridNavigationMode.cell,
                                                rowHeight: 50,
                                                headerRowHeight: 50,
                                                columnWidthMode:
                                                    ColumnWidthMode.auto,
                                                editingGestureType:
                                                    EditingGestureType.tap,
                                                controller: _dataGridController,
                                                onQueryRowHeight: (details) {
                                                  return details
                                                      .getIntrinsicRowHeight(
                                                          details.rowIndex);
                                                },
                                                columns: [
                                                  GridColumn(
                                                    columnName: 'srNo',
                                                    allowEditing: true,
                                                    width: 80,
                                                    label: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text('Sr No',
                                                          overflow: TextOverflow
                                                              .values.first,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color: blue)),
                                                    ),
                                                  ),
                                                  GridColumn(
                                                    width: 550,
                                                    columnName: 'Details',
                                                    allowEditing: true,
                                                    label: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                          'Details of Enclosure ',
                                                          overflow: TextOverflow
                                                              .values.first,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color: blue)),
                                                    ),
                                                  ),
                                                  GridColumn(
                                                    columnName: 'Status',
                                                    allowEditing: true,
                                                    width: 230,
                                                    label: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                          'Status of Submission of information/ documents ',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14,
                                                            color: blue,
                                                          )),
                                                    ),
                                                  ),
                                                  GridColumn(
                                                    columnName: 'Remark',
                                                    allowEditing: true,
                                                    width: 230,
                                                    label: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text('Remarks',
                                                          overflow: TextOverflow
                                                              .values.first,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color: blue)),
                                                    ),
                                                  ),
                                                  GridColumn(
                                                    columnName: 'Photo',
                                                    allowEditing: false,
                                                    visible: false,
                                                    width: 160,
                                                    label: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                          'Upload Photo',
                                                          overflow: TextOverflow
                                                              .values.first,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color: blue)),
                                                    ),
                                                  ),
                                                  GridColumn(
                                                    columnName: 'ViewPhoto',
                                                    allowEditing: false,
                                                    width: 180,
                                                    label: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text('View Photo',
                                                          overflow: TextOverflow
                                                              .values.first,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color: blue)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    )
                ],
              ));
  }

  Future<void> _generateEnergyPDF() async {
    pr!.show();

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

    List<pw.TableRow> rows = [];

    rows.add(
      pw.TableRow(
        children: [
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text('Depot Name',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
          pw.Container(
              padding: const pw.EdgeInsets.only(
                  top: 4, bottom: 4, left: 2, right: 2),
              child: pw.Center(
                  child: pw.Text('Vehicle No',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text('PSS No.',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text('Charger Id',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(
                'Start SOC',
              ))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(
                'End SOC',
              ))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(
                'Start Date & Time',
              ))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(
                'End Date & Time',
              ))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(
                'Total time of charging',
              ))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(
                'Energy Consumed',
              ))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(
                'Interval',
              ))),
        ],
      ),
    );

    if (energymanagement.isNotEmpty) {
      for (EnergyManagementModel mapData in energymanagement) {
        //Text Rows of PDF Table
        rows.add(pw.TableRow(children: [
          pw.Container(
              padding: const pw.EdgeInsets.all(3.0),
              child: pw.Center(
                  child: pw.Text(mapData.depotName.toString(),
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Center(
                  child: pw.Text(mapData.vehicleNo,
                      style: const pw.TextStyle(
                        fontSize: 13,
                      )))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData.pssNo.toString(),
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData.chargerId.toString(),
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData.startSoc.toString(),
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData.endSoc.toString(),
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData.startDate.toString(),
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData.endDate.toString(),
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData.totalTime.toString(),
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData.energyConsumed.toString(),
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData.timeInterval.toString(),
                      style: const pw.TextStyle(fontSize: 13)))),
        ]));
      }
    }

    final pdf = pw.Document(
      pageMode: PdfPageMode.outlines,
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
                      pw.Text('Demand Energy Report',
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
                        text:
                            '${startdate!.day}-${startdate!.month}-${startdate!.year} to ${enddate!.day}-${enddate!.month}-${enddate!.year}',
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
          pw.Table(
              columnWidths: {
                0: const pw.FixedColumnWidth(100),
                1: const pw.FixedColumnWidth(50),
                2: const pw.FixedColumnWidth(50),
                3: const pw.FixedColumnWidth(50),
                4: const pw.FixedColumnWidth(70),
                5: const pw.FixedColumnWidth(70),
                6: const pw.FixedColumnWidth(70),
                7: const pw.FixedColumnWidth(70),
                8: const pw.FixedColumnWidth(70),
                9: const pw.FixedColumnWidth(70),
                10: const pw.FixedColumnWidth(70),
              },
              defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
              tableWidth: pw.TableWidth.max,
              border: pw.TableBorder.all(),
              children: rows)
        ],
      ),
    );

    pdfData = await pdf.save();
    pdfPath = 'DemandEnergyReport.pdf';

    // Save the PDF file to device storage
    if (sendReport) {
      if (kIsWeb) {
        html.AnchorElement(
            href:
                "data:application/octet-stream;base64,${base64Encode(pdfData)}")
          ..setAttribute("download", pdfPath!)
          ..click();
      } else {
        const Text('Sorry it is not ready for mobile platform');
      }
    }
    uploadPdf(pdfData, pdfPath!);
    pr!.hide();
    // // For mobile platforms
    // final String dir = (await getApplicationDocumentsDirectory()).path;
    // final String path = '$dir/$pdfPath';
    // final File file = File(path);
    // await file.writeAsBytes(pdfData);
    //
    // // Open the PDF file for preview or download
    // OpenFile.open(file.path);
  }

  Future<void> _generateDailyPDF() async {
    pr!.style(
      progressWidgetAlignment: Alignment.center,
      // message: 'Loading Data....',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: const LoadingPdf(),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      maxProgress: 100.0,
      progressTextStyle: const TextStyle(
          color: Colors.black, fontSize: 10.0, fontWeight: FontWeight.w400),
      messageTextStyle: const TextStyle(
          color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.w600),
    );

    await pr!.show();

    final summaryProvider =
        Provider.of<SummaryProvider>(context, listen: false);
    dailyproject = summaryProvider.dailydata;

    final headerStyle =
        pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold);

    final fontData1 = await rootBundle.load('fonts/IBMPlexSans-Medium.ttf');
    final fontData2 = await rootBundle.load('fonts/IBMPlexSans-Bold.ttf');

    final profileImage = pw.MemoryImage(
      (await rootBundle.load('assets/Tata-Power.jpeg')).buffer.asUint8List(),
    );

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
              child: pw.Text('Date',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Type of Activity',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Activity Details',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Progress',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
      pw.Container(
          padding: const pw.EdgeInsets.all(2.0),
          child: pw.Center(
              child: pw.Text('Remark / Status',
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
    ]));

    List<pw.Widget> imageUrls = [];

    for (int i = 0; i < dailyproject.length; i++) {
      String imagesPath =
          '/Daily Report/${widget.cityName}/${widget.depoName}/${widget.userId}/${dailyproject[i].date}/${globalRowIndex[i]}';
      print(imagesPath);

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
                  height: 80,
                  child: pw.Center(
                    child: pw.Image(myImage),
                  )),
            );
          }
        }

        if (imageUrls.length < 2) {
          int imageLoop = 2 - imageUrls.length;
          for (int i = 0; i < imageLoop; i++) {
            imageUrls.add(
              pw.Container(
                  padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                  width: 60,
                  height: 80,
                  child: pw.Text('')),
            );
          }
        } else if (imageUrls.length > 2) {
          int imageLoop = 10 - imageUrls.length;
          for (int i = 0; i < imageLoop; i++) {
            imageUrls.add(
              pw.Container(
                  padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                  width: 80,
                  height: 100,
                  child: pw.Text('')),
            );
          }
        }
      } else {
        for (int i = 0; i < 2; i++) {
          imageUrls.add(
            pw.Container(
                padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                width: 60,
                height: 80,
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
                child: pw.Text((i + 1).toString(),
                    style: const pw.TextStyle(fontSize: 14)))),
        pw.Container(
            padding: const pw.EdgeInsets.all(2.0),
            child: pw.Center(
                child: pw.Text(dailyproject[i].date.toString(),
                    style: const pw.TextStyle(fontSize: 14)))),
        pw.Container(
            padding: const pw.EdgeInsets.all(2.0),
            child: pw.Center(
                child: pw.Text(dailyproject[i].typeOfActivity.toString(),
                    style: const pw.TextStyle(fontSize: 14)))),
        pw.Container(
            padding: const pw.EdgeInsets.all(2.0),
            child: pw.Center(
                child: pw.Text(dailyproject[i].activityDetails.toString(),
                    style: const pw.TextStyle(fontSize: 14)))),
        pw.Container(
            padding: const pw.EdgeInsets.all(2.0),
            child: pw.Center(
                child: pw.Text(dailyproject[i].progress.toString(),
                    style: const pw.TextStyle(fontSize: 14)))),
        pw.Container(
            padding: const pw.EdgeInsets.all(2.0),
            child: pw.Center(
                child: pw.Text(dailyproject[i].status.toString(),
                    style: const pw.TextStyle(fontSize: 14)))),
        imageUrls[0],
        imageUrls[1]
      ]));

      if (imageUrls.length - 2 > 0) {
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
                    imageUrls[2],
                    imageUrls[3],
                  ])),
          imageUrls[4],
          imageUrls[5],
          imageUrls[6],
          imageUrls[7],
          imageUrls[8],
          imageUrls[9]
        ]));
      }
      imageUrls.clear();
    }

    final pdf = pw.Document(
      pageMode: PdfPageMode.outlines,
    );

    //First Half Page

    pdf.addPage(
      pw.MultiPage(
        maxPages: 100,
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
                      pw.Text('Daily Report Table',
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
                        text:
                            '${startdate!.day}-${startdate!.month}-${startdate!.year} to ${enddate!.day}-${enddate!.month}-${enddate!.year}',
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

    pdfData = await pdf.save();
    pdfPath = 'Daily Report.pdf';

    // Save the PDF file to device storage
    if (sendReport) {
      if (kIsWeb) {
        html.AnchorElement(
            href:
                "data:application/octet-stream;base64,${base64Encode(pdfData)}")
          ..setAttribute("download", pdfPath!)
          ..click();
      }
    } else {
      if (kIsWeb) {
        html.AnchorElement(
            href:
                "data:application/octet-stream;base64,${base64Encode(pdfData)}")
          ..setAttribute("download", pdfPath!)
          ..click();
      }
    }
    uploadPdf(pdfData, pdfPath!);
    pr!.hide();

    // setState(() {
    //   _isLoading = false;
    // });
  }

  Future<void> _generateSafetyPDF() async {
    bool isImageEmpty = false;
    pr!.show();

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

    List<pw.TableRow> rows = [];

    rows.add(
      pw.TableRow(
        children: [
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text('Sr No',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
          pw.Container(
              padding: const pw.EdgeInsets.only(
                  top: 4, bottom: 4, left: 2, right: 2),
              child: pw.Center(
                  child: pw.Text('Details',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text('Status',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text('Remark',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(
                'Image5',
              ))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(
                'Image6',
              ))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(
                'Image7',
              ))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(
                'Image8',
              ))),
        ],
      ),
    );

    if (alldata.isNotEmpty) {
      List<pw.Widget> imageUrls = [];

      for (SafetyChecklistModel mapData in safetylisttable) {
        String selectedDate = DateFormat.yMMMMd().format(startdate!);
        print(selectedDate);
        String images_Path =
            '/SafetyChecklist/${widget.cityName}/${widget.depoName}/$userId/$selectedDate/${mapData.srNo}';
        print(images_Path);
        ListResult result =
            await FirebaseStorage.instance.ref().child(images_Path).listAll();

        if (result.items.isNotEmpty) {
          for (var image in result.items) {
            String downloadUrl = await image.getDownloadURL();
            if (image.name.endsWith('.pdf')) {
              imageUrls.add(
                pw.Container(
                  alignment: pw.Alignment.center,
                  padding: const pw.EdgeInsets.only(top: 8.0, bottom: 8.0),
                  width: 60,
                  height: 100,
                  child: pw.UrlLink(
                    child: pw.Text(image.name,
                        style: const pw.TextStyle(color: PdfColors.blue)),
                    destination: downloadUrl,
                  ),
                ),
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
                  ),
                ),
              );
            }
          }
          if (imageUrls.length < 11) {
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
        } else {
          isImageEmpty = true;
        }
        result.items.clear();

        //Text Rows of PDF Table
        rows.add(pw.TableRow(children: [
          pw.Container(
              padding: const pw.EdgeInsets.all(3.0),
              child: pw.Center(
                  child: pw.Text(mapData.srNo.toString(),
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Center(
                  child: pw.Text(mapData.details,
                      style: const pw.TextStyle(
                        fontSize: 13,
                      )))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData.status.toString(),
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData.remark.toString(),
                      style: const pw.TextStyle(fontSize: 13)))),
          isImageEmpty ? pw.Container() : pw.Center(child: imageUrls[0]),
          isImageEmpty ? pw.Container() : pw.Center(child: imageUrls[1]),
          isImageEmpty ? pw.Container() : pw.Center(child: imageUrls[2]),
        ]));

        if (imageUrls.isNotEmpty) {
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
                      pw.Text('Safety Report',
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
                        text:
                            '${startdate!.day}-${startdate!.month}-${startdate!.year} to ${enddate!.day}-${enddate!.month}-${enddate!.year}',
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

    pdfData = await pdf.save();
    pdfPath = 'SafetyReport.pdf';

    // Save the PDF file to device storage
    if (sendReport) {
      if (kIsWeb) {
        html.AnchorElement(
            href:
                "data:application/octet-stream;base64,${base64Encode(pdfData)}")
          ..setAttribute("download", pdfPath!)
          ..click();
      } else {
        const Text('Sorry it is not ready for mobile platform');
      }
    }
    uploadPdf(pdfData, pdfPath!);
    pr!.hide();
    // // For mobile platforms
    // final String dir = (await getApplicationDocumentsDirectory()).path;
    // final String path = '$dir/$pdfPath';
    // final File file = File(path);
    // await file.writeAsBytes(pdfData);
    //
    // // Open the PDF file for preview or download
    // OpenFile.open(file.path);
  }

  Future<void> _generateMonthlyPdf() async {
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

    List<pw.TableRow> rows = [];

    rows.add(
      pw.TableRow(
        children: [
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text('Sr No',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
          pw.Container(
              padding: const pw.EdgeInsets.only(
                  top: 4, bottom: 4, left: 2, right: 2),
              child: pw.Center(
                  child: pw.Text('Activity Details',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text('Progress',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text('Remark/Status',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(
                'Next Month Action Plan',
              ))),
        ],
      ),
    );

    if (monthlyProject.isNotEmpty) {
      for (MonthlyProjectModel mapData in monthlyProject) {
        // String selectedDate = DateFormat.yMMMMd().format(startdate!);

        //Text Rows of PDF Table

        rows.add(pw.TableRow(children: [
          pw.Container(
              padding: const pw.EdgeInsets.all(3.0),
              child: pw.Center(
                  child: pw.Text(mapData.activityNo.toString(),
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(5.0),
              child: pw.Center(
                  child: pw.Text(mapData.activityDetails.toString(),
                      style: const pw.TextStyle(
                        fontSize: 13,
                      )))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData.progress.toString(),
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData.status.toString(),
                      style: const pw.TextStyle(fontSize: 13)))),
          pw.Container(
              padding: const pw.EdgeInsets.all(2.0),
              child: pw.Center(
                  child: pw.Text(mapData.action.toString(),
                      style: const pw.TextStyle(fontSize: 13)))),
        ]));
      }
    }

    final pdf = pw.Document(
      pageMode: PdfPageMode.outlines,
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
                      pw.Text('Monthly Report',
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
                        text:
                            '${startdate!.day}-${startdate!.month}-${startdate!.year} to ${enddate!.day}-${enddate!.month}-${enddate!.year}',
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

    pdfData = await pdf.save();
    pdfPath = 'MonthlyReport.pdf';

    // Save the PDF file to device storage
    if (sendReport) {
      if (kIsWeb) {
        html.AnchorElement(
            href:
                "data:application/octet-stream;base64,${base64Encode(pdfData)}")
          ..setAttribute("download", pdfPath!)
          ..click();
      } else {
        const Text('Sorry it is not ready for mobile platform');
      }
    }
    uploadPdf(pdfData, pdfPath!);
    pr!.hide();
    // // For mobile platforms
    // final String dir = (await getApplicationDocumentsDirectory()).path;
    // final String path = '$dir/$pdfPath';
    // final File file = File(path);
    // await file.writeAsBytes(pdfData);
    //
    // // Open the PDF file for preview or download
    // OpenFile.open(file.path);
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
  }

  List<BarChartGroupData> barChartGroupData(List<dynamic> data) {
    return List.generate(data.length, ((index) {
      print('$index${data[index]}');
      return BarChartGroupData(
        x: index,
        showingTooltipIndicators: [0],
        barRods: [
          BarChartRodData(
              borderSide: BorderSide(color: white),
              backDrawRodData: BackgroundBarChartRodData(
                toY: 0,
                fromY: 0,
                show: true,
              ),
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 16, 81, 231),
                  Color.fromARGB(255, 190, 207, 252)
                ],
              ),
              width: 20,
              borderRadius: BorderRadius.circular(2),
              toY: data[index]),
        ],
      );
    }));
  }

  _showCheckboxDialog(BuildContext context, CheckboxProvider checkboxProvider,
      String depoName) {
    checkboxProvider.myCcBooleanValue.clear();
    checkboxProvider.myToBooleanValue.clear();
    checkboxProvider.myCcBooleanValue.add(false);
    checkboxProvider.myToBooleanValue.add(false);
    checkboxProvider.ccValue.clear();
    checkboxProvider.toValue.clear();

    // List<String>? currentToValue = [];
    // List<String>? currentCcValue = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<CheckboxProvider>(
          builder: (context, value, child) {
            return Container(
              padding: const EdgeInsetsDirectional.all(0),
              margin: const EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width * 0.5,
              child: AlertDialog(
                title: const Text('Choose Required Filled For Email'),
                content: Row(mainAxisSize: MainAxisSize.max, children: [
                  Expanded(
                    child: Column(children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          'Choose To',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: black,
                              fontSize: 18),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      ...List.generate(
                        value.myToMailValue.length,
                        (index) {
                          // print('iji$index');

                          for (int i = 0;
                              i <= value.myToMailValue.length;
                              i++) {
                            checkboxProvider.defaultToBooleanValue.add(false);
                          }

                          return Flexible(
                            child: Row(
                              children: [
                                Checkbox(
                                  // title: Text(value.myCcMailValue[index]),
                                  value: value.myToBooleanValue[index],
                                  onChanged: (bool? newboolean) {
                                    if (newboolean != null) {
                                      checkboxProvider.setMyToBooleanValue(
                                          index, newboolean);
                                    }

                                    if (value.myToBooleanValue[index] != null &&
                                        value.myToBooleanValue[index] == true) {
                                      print('index$index');
                                      checkboxProvider.getCurrentToValue(
                                          index, value.myToMailValue[index]);
                                    } else {
                                      value.toValue
                                          .remove(value.myToMailValue[index]);
                                    }
                                    print(value.ccValue);
                                  },
                                ),
                                Text(
                                  value.myToMailValue[index],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ]),
                  ),
                  Expanded(
                    child: Column(children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          'Choose Cc',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: black,
                              fontSize: 18),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      ...List.generate(
                        value.myCcMailValue.length,
                        (index) {
                          // print('iji$index');
                          for (int i = 0;
                              i <= value.myCcMailValue.length;
                              i++) {
                            checkboxProvider.defaultCcBooleanValue.add(false);
                          }
                          return Flexible(
                            child: Row(
                              children: [
                                Checkbox(
                                  value: value.myCcBooleanValue[index],
                                  onChanged: (bool? newboolean) {
                                    if (newboolean != null) {
                                      checkboxProvider.setMyCcBooleanValue(
                                          index, newboolean);
                                    }
                                    if (value.myCcBooleanValue[index] != null &&
                                        value.myCcBooleanValue[index] == true) {
                                      print('index$index');
                                      checkboxProvider.getCurrentCcValue(
                                          index, value.myCcMailValue[index]);
                                    } else {
                                      value.ccValue
                                          .remove(value.myCcMailValue[index]);
                                    }
                                  },
                                ),
                                Text(value.myCcMailValue[index]),
                              ],
                            ),
                          );
                        },
                      ),
                    ]),
                  ),
                ]),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Do something with the checked items
                      print(checkboxProvider.ccValue);
                      widget.id == 'Daily Report'
                          ? _generateDailyPDF().whenComplete(() {
                              savePdfAndSendEmail(
                                  pdfData,
                                  pdfPath!,
                                  'Daily Project Details of $depoName',
                                  'Todays+Daily+Report',
                                  checkboxProvider.toValue,
                                  checkboxProvider.ccValue);
                            })
                          : widget.id == 'Monthly Report'
                              ? _generateMonthlyPdf().whenComplete(() {
                                  savePdfAndSendEmail(
                                      pdfData,
                                      pdfPath!,
                                      'Daily Project Details of $depoName',
                                      'Todays+Daily+Report',
                                      checkboxProvider.toValue,
                                      checkboxProvider.ccValue);
                                })
                              : _generateEnergyPDF().whenComplete(() {
                                  savePdfAndSendEmail(
                                      pdfData,
                                      pdfPath!,
                                      'Daily Project Details of $depoName',
                                      'Todays+Daily+Report',
                                      checkboxProvider.toValue,
                                      checkboxProvider.ccValue);
                                });

                      Navigator.of(context).pop();
                    },
                    child: const Text('Send'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<String> uploadPdf(List<int> pdfData, String pdfPath) async {
    // Upload the PDF data to Firebase Storage
    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref('Downloaded File')
        // .child(path)
        .child(pdfPath);
    await ref.putData(Uint8List.fromList(pdfData));

    // Get the download URL for the uploaded PDF file
    return await ref.getDownloadURL();
  }

  Future<void> savePdfAndSendEmail(
      List<int> pdfData,
      String pdfPath,
      String subject,
      String body,
      List<String> toRecipients,
      List<String> ccRecipients) async {
    // Upload the PDF data to Firebase Storage
    String pdfUrl = await uploadPdf(pdfData, pdfPath);

    // Send email with the PDF URL as an attachment

    sendEmail('subject', body, pdfUrl, toRecipients, ccRecipients);
  }

  sendEmail(String subject, String body, String attachmentUrl,
      List<String> toRecipients, List<String> ccRecipients) {
    // Construct the mailto URL
    // String filePath = path.url.basename(attachmentUrl);
    String encodedSubject = Uri.decodeComponent(subject);
    String encodedBody = Uri.decodeComponent(body);
    // String encodedAttachmentUrl = attachmentUrl;
    String toParameter = toRecipients.map((cc) => cc).join(',');
    String ccParameter = ccRecipients.map((cc) => cc).join(',');

    final Uri params = Uri(
      scheme: 'mailto',
      path: '', // email address goes here
      queryParameters: {
        'subject': encodedSubject,
        'body': 'Attachment: $attachmentUrl',
        // 'attachment': attachmentUrl,
        //encodedAttachmentUrl, // attachment url if needed
        'to': toParameter,
        'cc': ccParameter,
      },
    );
    print('gfgfh&$ccParameter');

    // Encode and launch the mailto URL
    html.window.open(params.toString(), 'email');
  }
}
