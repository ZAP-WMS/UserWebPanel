import 'package:assingment/KeysEvents/upload.dart';
import 'package:assingment/Planning_Pages/quality_checklist.dart';
import 'package:assingment/Planning_Pages/safety_checklist.dart';
import 'package:assingment/components/page_routeBuilder.dart';
import 'package:assingment/overview/Jmr/jmr.dart';
import 'package:assingment/overview/closure_report.dart';
import 'package:assingment/overview/daily_project.dart';
import 'package:assingment/overview/detailed_Eng.dart';
import 'package:assingment/overview/material_vendor.dart';
import 'package:assingment/widget/style.dart';
import 'package:flutter/material.dart';
import '../Authentication/auth_service.dart';
import '../components/Loading_page.dart';
import '../overview/depot_overview.dart';
import '../overview/energy_management.dart';
import '../overview/key_events2.dart';
import '../overview/monthly_project.dart';
import '../widget/custom_appbar.dart';
import '../widget/custom_container.dart';

class OverviewPage extends StatefulWidget {
  String? cityName;
  String depoName;
  OverviewPage({super.key, required this.depoName, this.cityName});

  @override
  State<OverviewPage> createState() => _OverviewPageState();
}

class _OverviewPageState extends State<OverviewPage> {
  bool _isLoading = true;
  dynamic userId;
  List<Widget> pages = [];
  // List<IconData> icondata = [
  //   Icons.search_off_outlined,
  //   Icons.play_lesson_rounded,
  //   Icons.chat_bubble_outline_outlined,
  //   Icons.book_online_rounded,
  //   Icons.notes,
  //   Icons.track_changes_outlined,
  //   Icons.domain_verification,
  //   Icons.list_alt_outlined,
  //   Icons.electric_bike_rounded,
  //   Icons.text_snippet_outlined,
  //   Icons.monitor_outlined,
  // ];
  List imagedata = [
    'assets/overview_image/overview.png',
    'assets/overview_image/project_planning.png',
    'assets/overview_image/resource.png',
    'assets/overview_image/daily_progress.png',
    'assets/overview_image/monthly.png',
    'assets/overview_image/detailed_engineering.png',
    'assets/overview_image/jmr.png',
    // 'assets/overview_image/safety.png',
    'assets/overview_image/safety.png',
    'assets/overview_image/quality.png',
    // 'assets/overview_image/testing_commissioning.png',
    'assets/overview_image/testing_commissioning.png',
    'assets/overview_image/closure_report.png',
    'assets/overview_image/easy_monitoring.jpg',
  ];

  @override
  void initState() {
    getUserId().whenComplete(() {
      _isLoading = false;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> desription = [
      'Overview of Project Progress Status of ${widget.depoName} EV Bus Charging Infra',
      'Project Planning & Scheduling Bus Depot Wise [Gant Chart] ',
      'Material Procurement & Vendor Finalization Status',
      'Submission of Daily Progress Report for Individual Project',
      'Monthly Project Monitoring & Review',

      'Detailed Engineering Of Project Documents like GTP, GA Drawing',
      // 'Tracking of Individual Project Progress (SI No 2 & 6 S1 No.link)',
      'Online JMR verification for projects',
      'Safety check list & observation',
      'FQP Checklist for Civil,Electrical work & Quality Checklist',
      // 'Quality check list & observation',
      // 'FQP Checklist for Civil & Electrical work',
      'Depot Insightes',
      // 'Testing & Commissioning Reports of Equipment',
      'Closure Report',
      'Depot Demand Energy Management',
    ];
    pages = [
      DepotOverview(
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      KeyEvents2(
        depoName: widget.depoName,
        cityName: widget.cityName,
      ),
      MaterialProcurement(
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      // ResourceAllocation(
      //   depoName: widget.depoName,
      //   cityName: widget.cityName,
      // ),
      DailyProject(
        depoName: widget.depoName,
        cityName: widget.cityName,
      ),
      MonthlyProject(
        depoName: widget.depoName,
        cityName: widget.cityName,
      ),
      DetailedEng(
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      // PlanningPage(
      //   cityName: widget.cityName,
      //   depoName: widget.depoName,
      // ),

      Jmr(
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      SafetyChecklist(
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      QualityChecklist(
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      // KeyEvents(
      //   depoName: widget.depoName,
      //   cityName: widget.depoName,
      // ),
      UploadDocument(
          cityName: widget.cityName,
          depoName: widget.depoName,
          userId: userId,
          pagetitle: 'Overview Page',
          fldrName: userId),
      // TestingReport(
      //   cityName: widget.cityName,
      //   depoName: widget.depoName,
      // ),
      ClosureReport(
        cityName: widget.cityName,
        depoName: widget.depoName,
      ),
      EnergyManagement(
        cityName: widget.cityName,
        depoName: widget.depoName,
        userId: userId,
      )
      // KeyEvents2(
      //   depoName: widget.depoName,
      //   cityName: widget.cityName,
      // ),
    ];
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: CustomAppBar(
            depotName: widget.depoName,
            havedropdown: true,
            text: 'Overview Page ',
            haveSynced: false,
            showDepoBar: true,
            cityname: widget.cityName,
            toOverviewPage: true,
          )),
      body: _isLoading
          ? LoadingPage()
          : GridView.count(
              crossAxisCount: 4,
              childAspectRatio: 1.8,
              children: List.generate(desription.length, (index) {
                return cards(desription[index], imagedata[index], index);
              }),
            ),
    );
  }

  Widget cards(String desc, String img, int index) {
    return GestureDetector(
      onTap: (() {
        Navigator.push(context, CustomPageRoute(page: pages[index]));
      }),
      child: Center(
        child: Container(
          margin: EdgeInsets.only(top: 10.0),
          width: MediaQuery.of(context).size.width / 5,
          height: MediaQuery.of(context).size.height / 4,
          child: Card(
            elevation: 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  height: 60,
                  width: 60,
                  child: Image.asset(img, fit: BoxFit.cover),
                ),
                const SizedBox(height: 10),
                Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget cards(String desc, String img, int index) {
  //   return GestureDetector(
  //     onTap: (() {
  //       Navigator.push(
  //           context,
  //           // MaterialPageRoute(
  //           //   builder: (context) => pages[index],
  //           // )
  //           CustomPageRoute(page: pages[index]));
  //     }),
  //     child: Container(
  //       padding: const EdgeInsets.all(2),
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(12),
  //           border: Border.all(
  //             color: blue,
  //           ),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.grey.withOpacity(0.5),
  //               spreadRadius: 5,
  //               blurRadius: 5,
  //               offset: const Offset(0, 2), // changes position of shadow
  //             ),
  //           ]),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           const SizedBox(height: 10),
  //           SizedBox(
  //             height: 80,
  //             width: 80,
  //             child: Image.asset(img, fit: BoxFit.cover),
  //           ),
  //           const SizedBox(height: 10),
  //           Expanded(
  //             child: Text(
  //               desc,
  //               textAlign: TextAlign.center,
  //               style: const TextStyle(fontWeight: FontWeight.w600),
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future<void> getUserId() async {
    await AuthService().getCurrentUserId().then((value) {
      userId = value;
      setState(() {});
    });
  }
}
