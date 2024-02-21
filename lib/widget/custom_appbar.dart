import 'package:assingment/overview/key_events2.dart';
import 'package:assingment/overview/material_vendor.dart';
import 'package:assingment/screen/overview_page.dart';
import 'package:assingment/widget/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../Authentication/auth_service.dart';
import '../Authentication/login_register.dart';
import '../Planning_Pages/jmr.dart';
import '../Planning_Pages/quality_checklist.dart';
import '../Planning_Pages/safety_checklist.dart';
import '../overview/closure_report.dart';
import '../overview/daily_project.dart';
import '../overview/depot_overview.dart';
import '../overview/detailed_Eng.dart';
import '../overview/key_events.dart';
import '../overview/monthly_project.dart';
import '../overview/testing_report.dart';
import '../provider/key_provider.dart';

class CustomAppBar extends StatefulWidget {
  String? cityname;
  int? progress;
  String? text;
  bool toOverviewPage;
  bool toOverview;
  bool toPlanning;
  bool toMaterial;
  bool toSubmission;
  bool toMonthly;
  bool toDetailEngineering;
  bool toJmr;
  bool toSafety;
  bool toChecklist;
  bool toTesting;
  bool toClosure;
  bool toEasyMonitoring;
  bool isDownload;
  VoidCallback? donwloadFunction;
  bool isprogress;
  dynamic totalValue;
  String? depotName;
  bool isCitiesPage;

  // final IconData? icon;
  final bool haveSynced;
  final bool haveSummary;
  final void Function()? store;
  VoidCallback? onTap;
  bool havebottom;
  bool havedropdown;
  bool isdetailedTab;
  bool showDepoBar;
  TabBar? tabBar;
  bool isDepoPage;

  CustomAppBar(
      {this.cityname,
      super.key,
      this.text,
      this.haveSynced = false,
      this.haveSummary = false,
      this.store,
      this.onTap,
      this.havedropdown = false,
      this.havebottom = false,
      this.isdetailedTab = false,
      this.tabBar,
      this.showDepoBar = false,
      this.toChecklist = false,
      this.toTesting = false,
      this.toClosure = false,
      this.toEasyMonitoring = false,
      this.toSubmission = false,
      this.toOverviewPage = false,
      this.toOverview = false,
      this.toPlanning = false,
      this.toMaterial = false,
      this.toMonthly = false,
      this.toDetailEngineering = false,
      this.toJmr = false,
      this.toSafety = false,
      this.isprogress = false,
      this.totalValue,
      this.isDownload = false,
      this.donwloadFunction,
      this.progress,
      this.depotName,
      this.isCitiesPage = false,
      this.isDepoPage = false});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  KeyProvider? _keyProvider;
  bool isLoading = true;
  dynamic userId;
  TextEditingController selectedDepoController = TextEditingController();
  String? rangeStartDate = DateFormat.yMMMMd().format(DateTime.now());
  String selectedDepot = '';

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      _keyProvider = Provider.of<KeyProvider>(context, listen: false);
      getUserId().whenComplete(() {
        setState(() {});
      });
    });

    super.initState();
  }

  Future<int> checkPercent() async {
    return widget.progress!.toInt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: widget.isCitiesPage ? true : false,
            backgroundColor: blue,
            title: widget.isCitiesPage
                ? const Text(
                    'Cities',
                    style: TextStyle(fontSize: 18),
                  )
                : widget.isDepoPage
                    ? Text(widget.cityname ?? "")
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.text.toString(),
                            style: appFontSize,
                          ),
                          Text(
                            'City - ${widget.cityname}     Depot - ${widget.depotName}' ??
                                '',
                            style: const TextStyle(
                              fontSize: 11,
                            ),
                          )
                        ],
                      ),
            actions: [
              widget.isprogress
                  ? FutureBuilder<int>(
                      future: checkPercent(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularPercentIndicator(radius: 2);
                        } else if (snapshot.hasData) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: SizedBox(
                              height: 18.0,
                              width: 40.0,
                              child: CircularPercentIndicator(
                                radius: 20.0,
                                lineWidth: 5.0,
                                percent: (Provider.of<KeyProvider>(context)
                                        .totalvalue
                                        .toInt()) /
                                    100,
                                center: Text(
                                  "${(widget.progress!.toInt()) / 100 * 100}% ",
                                  textAlign: TextAlign.center,
                                  style: captionWhite,
                                ),
                                progressColor: green,
                                backgroundColor: red,
                              ),
                            ),
                          );
                        }
                        return Container();
                      })
                  : Container(),
              widget.showDepoBar
                  ? Container(
                      margin: const EdgeInsets.all(8),
                      width: 200,
                      height: 30,
                      child: TypeAheadField(
                          animationStart: BorderSide.strokeAlignCenter,
                          suggestionsCallback: (pattern) async {
                            return await getDepoList(pattern);
                          },
                          itemBuilder: (context, suggestion) {
                            return ListTile(
                              title: Text(
                                suggestion.toString(),
                                style: const TextStyle(fontSize: 14),
                              ),
                            );
                          },
                          onSuggestionSelected: (suggestion) {
                            selectedDepoController.text = suggestion.toString();
                            selectedDepot = suggestion.toString();
                            widget.toOverviewPage
                                ? Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => OverviewPage(
                                        cityName: widget.cityname,
                                        depoName: selectedDepot,
                                      ),
                                    ))
                                : widget.toOverview
                                    ? Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DepotOverview(
                                            cityName: widget.cityname,
                                            depoName: selectedDepot,
                                          ),
                                        ))
                                    : widget.toPlanning
                                        ? Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => KeyEvents2(
                                                depoName: suggestion,
                                                cityName: widget.cityname,
                                              ),
                                            ))
                                        : widget.toMaterial
                                            ? Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MaterialProcurement(
                                                    depoName: suggestion,
                                                    cityName: widget.cityname,
                                                  ),
                                                ))
                                            : widget.toSubmission
                                                ? Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          DailyProject(
                                                        depoName: suggestion,
                                                        cityName:
                                                            widget.cityname,
                                                      ),
                                                    ))
                                                : widget.toMonthly
                                                    ? Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              MonthlyProject(
                                                            depoName:
                                                                suggestion,
                                                            cityName:
                                                                widget.cityname,
                                                          ),
                                                        ))
                                                    : widget.toDetailEngineering
                                                        ? Navigator
                                                            .pushReplacement(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          DetailedEng(
                                                                    cityName: widget
                                                                        .cityname,
                                                                    depoName:
                                                                        suggestion,
                                                                  ),
                                                                ))
                                                        : widget.toJmr
                                                            ? Navigator
                                                                .pushReplacement(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              Jmr(
                                                                        cityName:
                                                                            widget.cityname,
                                                                        depoName:
                                                                            suggestion,
                                                                      ),
                                                                    ))
                                                            : widget.toSafety
                                                                ? Navigator
                                                                    .pushReplacement(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              SafetyChecklist(
                                                                            cityName:
                                                                                widget.cityname,
                                                                            depoName:
                                                                                suggestion,
                                                                          ),
                                                                        ))
                                                                : widget.toChecklist
                                                                    ? Navigator.pushReplacement(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              QualityChecklist(
                                                                            cityName:
                                                                                widget.cityname,
                                                                            depoName:
                                                                                suggestion,
                                                                          ),
                                                                        ))
                                                                    : widget.toTesting
                                                                        ? Navigator.pushReplacement(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder: (context) => TestingReport(
                                                                                cityName: widget.cityname,
                                                                                depoName: suggestion,
                                                                              ),
                                                                            ))
                                                                        : widget.toClosure
                                                                            ? Navigator.pushReplacement(
                                                                                context,
                                                                                MaterialPageRoute(
                                                                                  builder: (context) => ClosureReport(
                                                                                    depoName: suggestion,
                                                                                    cityName: widget.cityname,
                                                                                  ),
                                                                                ))
                                                                            : widget.toEasyMonitoring
                                                                                ? Navigator.pushReplacement(
                                                                                    context,
                                                                                    MaterialPageRoute(
                                                                                      builder: (context) => KeyEvents(
                                                                                        depoName: selectedDepot,
                                                                                        cityName: widget.cityname,
                                                                                      ),
                                                                                    ))
                                                                                : ' ';
                          },
                          textFieldConfiguration: TextFieldConfiguration(
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: EdgeInsets.all(5.0),
                              hintText: 'Go To Depot',
                            ),
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                            controller: selectedDepoController,
                          )),
                    )
                  : Container(),
              const SizedBox(
                width: 10,
              ),
              widget.isprogress
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: 300,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                legends(yellow, 'Base Line', black),
                                legends(green, 'On Time', black),
                                legends(red, 'Delay', white),
                              ],
                            )),
                        Consumer<KeyProvider>(
                          builder: (context, value, child) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 2, right: 10, left: 10),
                              child: Row(
                                children: [
                                  Container(
                                    width: 130,
                                    color: green,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                          'Project Duration \n ${durationParse(value.startdate, value.endDate)} Days',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14, color: black)),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Container(
                                    width: 130,
                                    color: red,
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                          'Project Delay \n ${durationParse(value.actualDate, value.endDate)}  Days ',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 14, color: white)),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  const Text('% Of Progress is '),
                                  SizedBox(
                                    height: 50.0,
                                    width: 40.0,
                                    child: CircularPercentIndicator(
                                      radius: 20.0,
                                      lineWidth: 4.0,
                                      percent:
                                          (value.perProgress.toInt()) / 100,
                                      center: Text(
                                        // value.getName.toString(),
                                        "${(value.perProgress.toInt())}% ",
                                        textAlign: TextAlign.center,
                                        style: captionWhite,
                                      ),
                                      progressColor: green,
                                      backgroundColor: red,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : Container(),
              widget.haveSummary
                  ? Container(
                      margin: const EdgeInsets.all(8.0),
                      height: 15,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: Colors.blue),
                      child: TextButton(
                          onPressed: widget.onTap,
                          child: Text(
                            'View Summary',
                            style: TextStyle(color: white, fontSize: 15),
                          )),
                    )
                  : Container(),
              widget.haveSynced
                  ? Container(
                      margin: const EdgeInsets.all(8.0),
                      height: 15,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: Colors.blue),
                      child: TextButton(
                          onPressed: () {
                            widget.store!();
                          },
                          child: Text(
                            'Sync Data',
                            style: TextStyle(color: white, fontSize: 15),
                          )),
                    )
                  : Container(),
              widget.isDownload
                  ? Container(
                      margin: const EdgeInsets.all(5),
                      child: ElevatedButton(
                        style: const ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.blue)),
                        onPressed: widget.donwloadFunction,
                        child: const Icon(Icons.download, color: Colors.white),
                      ),
                    )
                  : Container(),
              const SizedBox(width: 10),
              Container(
                  margin: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                      onTap: () {
                        onWillPop(context);
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/logout.png',
                            height: 20,
                            width: 20,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            userId ?? '',
                            style: appFontSize,
                          )
                        ],
                      ))),
            ],
            bottom: widget.havebottom
                ? TabBar(
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

                    tabs: const [
                      Tab(text: "PSS"),
                      Tab(text: "RMU"),
                      Tab(text: "PSS"),
                      Tab(text: "RMU"),
                      Tab(text: "PSS"),
                      Tab(text: "RMU"),
                      Tab(text: "PSS"),
                      Tab(text: "RMU"),
                      Tab(text: "PSS"),
                    ],
                  )
                : widget.isdetailedTab
                    ? TabBar(
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

                        tabs: const [
                          Tab(text: "RFC Drawings of Civil Activities"),
                          Tab(
                              text:
                                  "EV Layout Drawings of Electrical Activities"),
                          Tab(text: "Shed Lighting Drawings & Specification"),
                        ],
                      )
                    : widget.tabBar));
  }

  Future<bool> onWillPop(BuildContext context) async {
    bool a = false;
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              content: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Close TATA POWER?",
                      style: subtitle1White,
                    ),
                    const SizedBox(
                      height: 36,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              //color: blue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            //color: blue,
                            child: Center(
                                child: Text(
                              "No",
                              style: button.copyWith(color: blue),
                            )),
                          ),
                        )),
                        Expanded(
                            child: InkWell(
                          onTap: () {
                            a = true;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginRegister(),
                                ));
                            // exit(0);
                          },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: blue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            //color: blue,
                            child: Center(
                                child: Text(
                              "Yes",
                              style: button,
                            )),
                          ),
                        ))
                      ],
                    )
                  ],
                ),
              ),
            ));
    return a;
  }

  Future<List<dynamic>> getDepoList(String pattern) async {
    List<dynamic> depoList = [];
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('DepoName')
        .doc(widget.cityname)
        .collection('AllDepots')
        .get();

    depoList = querySnapshot.docs.map((deponame) => deponame.id).toList();

    if (pattern.isNotEmpty) {
      depoList = depoList
          .where((element) => element
              .toString()
              .toUpperCase()
              .startsWith(pattern.toUpperCase()))
          .toList();
    }

    return depoList;
  }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
    });
  }
}

legends(Color color, String title, Color textColor) {
  return Padding(
    padding: const EdgeInsets.only(top: 5, bottom: 5),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
            width: 75,
            height: 28,
            color: color,
            padding: const EdgeInsets.all(5),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w900, color: textColor),
            )),
      ],
    ),
  );
}

int durationParse(String fromtime, String todate) {
  DateTime startdate = DateFormat('dd-MM-yyyy').parse(fromtime);
  DateTime enddate = DateFormat('dd-MM-yyyy').parse(todate);
  return enddate.add(Duration(days: 1)).difference(startdate).inDays;
}
