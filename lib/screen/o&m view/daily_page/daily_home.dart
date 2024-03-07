import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../../../widget/appbar_back_date.dart';
import '../../../widget/style.dart';
import 'daily.dart';

class DailyManagementHomePage extends StatefulWidget {
  String? cityName;
  String? depoName;
  DailyManagementHomePage({super.key, required this.cityName, this.depoName});

  @override
  State<DailyManagementHomePage> createState() =>
      _DailyManagementHomePageState();
}

class _DailyManagementHomePageState extends State<DailyManagementHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          // ignore: sort_child_properties_last
          child: CustomAppBarBackDate(
              toDaily: true,
              cityName: widget.cityName,
              text: 'Daily Report',
              depoName: widget.depoName,
              //  ${DateFormat.yMMMMd().format(DateTime.now())}',
              haveSynced: true,
              haveSummary: true,
              // onTap: () => Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => ViewSummary(
              //         cityName: widget.cityName.toString(),
              //         depoName: widget.depoName.toString(),
              //         id: 'Daily Report',
              //         userId: userId,
              //       ),
              //     )),
              store: () {
                //    _showDialog(context);
                // FirebaseApi().nestedKeyEventsField(
                //     'DailyManagementPage3', widget.depoName!, 'userId', userId);
                //    storeData();
              },
              choosedate: () {
                //   chooseDate(context);
              }),
          preferredSize: const Size.fromHeight(
            50,
          ),
        ),
        body: DefaultTabController(
            length: 6,
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
                    // _selectedIndex = value;
                    // checkTable = true;
                    // selectedDate = DateFormat.yMMMMd().format(DateTime.now());
                    // currentDate = DateTime.now();
                    // setBoolean();
                    // getControllersData();
                    // await getTableData();

                    // civilTabBool[value] = true;
                    // widget.getBoolList!(civilTabBool, tabForCivil[value]);
                  },

                  tabs: const [
                    Tab(text: "Charger Checklist"),
                    Tab(text: "SFU Checklist"),
                    Tab(text: "PSS Checklist"),
                    Tab(text: "Transformer Checklist"),
                    Tab(text: "RMU Checklist"),
                    Tab(text: "ACDB Checklist"),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  DailyManagementPage(
                    cityName: widget.cityName,
                    depoName: widget.depoName,
                    tabletitle: 'Charger Checklist',
                  ),
                  DailyManagementPage(
                    cityName: widget.cityName,
                    depoName: widget.depoName,
                    tabletitle: 'SFU Checklist',
                  ),
                  DailyManagementPage(
                    cityName: widget.cityName,
                    depoName: widget.depoName,
                    tabletitle: 'PSS Checklist',
                  ),
                  DailyManagementPage(
                    cityName: widget.cityName,
                    depoName: widget.depoName,
                    tabletitle: 'Transformer Checklist',
                  ),
                  DailyManagementPage(
                    cityName: widget.cityName,
                    depoName: widget.depoName,
                    tabletitle: 'RMU Checklist',
                  ),
                  DailyManagementPage(
                    cityName: widget.cityName,
                    depoName: widget.depoName,
                    tabletitle: 'ACDB Checklist',
                  ),

                  // civilupperScreen(),
                  // civilupperScreen(),
                  // civilupperScreen(),
                  // civilupperScreen(),
                  // civilupperScreen(),
                  // civilupperScreen(),
                  // civilupperScreen(),
                  // civilupperScreen(),
                  // civilupperScreen(),
                  // civilupperScreen(),
                  // civilupperScreen(),
                  // civilupperScreen(),
                ],
              ),
            )));
  }
}
