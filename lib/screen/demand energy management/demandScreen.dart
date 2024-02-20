import 'package:assingment/KeysEvents/Grid_DataTable.dart';
import 'package:assingment/provider/All_Depo_Select_Provider.dart';
import 'package:assingment/provider/demandEnergyProvider.dart';
import 'package:assingment/screen/cities_page.dart';
import 'package:assingment/screen/demand%20energy%20management/bar_graph.dart';
import 'package:assingment/screen/demand%20energy%20management/demand_table.dart';
import 'package:assingment/widget/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DemandEnergyScreen extends StatefulWidget {
  bool showStartEndDatePanel;
  String userId;
  DemandEnergyScreen({
    super.key,
    this.showStartEndDatePanel = false,
    required this.userId,
  });

  @override
  State<DemandEnergyScreen> createState() => _DemandEnergyScreenState();
}

class _DemandEnergyScreenState extends State<DemandEnergyScreen> {
  List<double> energyConsumedList = [];
  List<dynamic> timeIntervalList = [];
  List<dynamic> monthList = [];
  List<dynamic> dateList = [];
  List<double> quaterlyEnergyConsumedList = [];
  List<double> yearlyEnergyConsumedList = [];
  List<double> allDepoDailyEnergyConsumedList = [];
  List<List<double>> allDepotsYearlyConsumedList = [];
  List<double> allDepotsMonthlyConsumedList = [];
  List<List<double>> allDepoQuaterlyConsumedList = [];
  double totalEnergyConsumedQuaterly = 0;

  //Data table columns & rows
  List<String> columns = [
    'Sr.No.',
    'CityName',
    'Depot',
    'Energy Consumed\n(in kW)'
  ];

  List<List<dynamic>> rows = [];

  List<String> quaterlyMonths = ['Mar', 'Jun', 'Sep', 'Dec'];

  final currentDate = DateTime.now();
  final currentDay = DateFormat.yMMMMd().format(
    DateTime.now(),
  );
  final currentYear = DateTime.now().year;

  dynamic currentMonth;

  @override
  void initState() {
    super.initState();
    //Load Daily Data for Tables and Graphs
  }

  @override
  Widget build(BuildContext context) {
    currentMonth = DateFormat('MMMM').format(currentDate);

    final provider = Provider.of<DemandEnergyProvider>(context, listen: false);
    final checkboxProvider =
        Provider.of<AllDepoSelectProvider>(context, listen: false);

    //Set Callback Function in provider
    provider.setCurrentDayFunction(getCurrentDayData);
    provider.setCurrentMonthFunction(getCurrentMonthData);
    provider.setQuaterlyFunction(getQuaterlyData);
    provider.setYearlyFunction(getYearlyData);
    provider.setAllDepoDailyData(getAllDepoDailyData);
    provider.setAllDepoMonthlyData(getAllDepoMonthlyData);
    provider.setAllDepoQuaterlyData(getAllDepoQuarterData);
    provider.setAllDepoYearlyData(gettAllDepoYearlyData);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          backgroundColor: blue,
          title: const Text(
            'EV Bus Depot Management System',
            style: TextStyle(fontSize: 15),
          ),
          actions: [
            Consumer<DemandEnergyProvider>(
              builder: (context, providerValue, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 20,
                      width: 220,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Start Date - ',
                                style: TextStyle(
                                    color: white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                            TextSpan(
                              text: providerValue.startDate.toString(),
                              style: TextStyle(
                                  fontSize: 15,
                                  color: white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(right: 5),
                      height: 20,
                      width: 220,
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'End Date - ',
                              style: TextStyle(
                                  color: white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                            TextSpan(
                              text: providerValue.endDate.toString(),
                              style: TextStyle(
                                  fontSize: 15,
                                  color: white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
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
                          widget.userId ?? '',
                          style: appFontSize,
                        )
                      ],
                    ))),
          ],
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: DemandTable(
              getQuaterlyData: getQuaterlyData,
              getYearlyData: getYearlyData,
              getMonthlyData: getCurrentMonthData,
              getDailyData: getCurrentDayData,
              getAllDepoDayData: getAllDepoDailyData,
              getAllDepoMonthlyData: getAllDepoMonthlyData,
              getAllDepoQuarterlyData: getAllDepoQuarterData,
              getAllDepoYearlyData: gettAllDepoYearlyData,
              columns: columns,
              rows: rows,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            flex: 2,
            child: BarGraphScreen(
              monthList: monthList,
              timeIntervalList: timeIntervalList,
              allDepotsYearlyConsumedList: allDepotsYearlyConsumedList,
              allDepotsMonthlyConsumedList: allDepotsMonthlyConsumedList,
              allDepotsQuaterlyConsumedList: allDepoQuaterlyConsumedList,
            ),
          )
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 40,
            child: ElevatedButton(
              style:
                  ButtonStyle(backgroundColor: MaterialStatePropertyAll(blue)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back to Dashboard'),
            ),
          ),
          const SizedBox(width: 10),
          Container(
            height: 40,
            child: ElevatedButton(
              style:
                  ButtonStyle(backgroundColor: MaterialStatePropertyAll(blue)),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CitiesPage(),
                    ));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Proceed',
                    style: TextStyle(
                        fontSize: 16,
                        color: almostWhite,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Icon(
                    Icons.forward,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getAllDepoDailyData() async {
    try {
      int srNo = 0;
      rows.clear();

      timeIntervalList.clear();

      energyConsumedList.clear();

      dateList.clear();

      double greaterValue = 0.0;

      final provider = Provider.of<DemandEnergyProvider>(
        context,
        listen: false,
      );

      // final selectedDepoName = provider.selectedDepo;

      final selectedCityName = Provider.of<DemandEnergyProvider>(
        context,
        listen: false,
      ).selectedCity;

      for (int k = 0; k < provider.depoList!.length; k++) {
        double totalEnergyConsumedInEachDepo = 0.0;
        CollectionReference collectionReference = FirebaseFirestore.instance
            .collection('EnergyManagementTable')
            .doc(selectedCityName)
            .collection('Depots')
            .doc(provider.depoList![k])
            .collection('Year')
            .doc(currentYear.toString())
            .collection('Months')
            .doc(currentMonth)
            .collection('Date')
            .doc(currentDay)
            .collection('UserId');

        dateList.add(currentDay);

        QuerySnapshot querySnapshot = await collectionReference.get();

        List<dynamic> allUsers = querySnapshot.docs
            .map(
              (userid) => userid.id,
            )
            .toList();

        print('All Users - $allUsers');

        if (allUsers.isNotEmpty) {
          DocumentSnapshot daySnap =
              await collectionReference.doc(allUsers[0]).get();
          Map<String, dynamic> mapData = daySnap.data() as Map<String, dynamic>;
          List<dynamic> userData = mapData['data'];

          for (int j = 0; j < userData.length; j++) {
            srNo = srNo + 1;
            List<dynamic> row = [];
            totalEnergyConsumedInEachDepo = totalEnergyConsumedInEachDepo +
                double.parse(userData[j]['energyConsumed'].toString());
            timeIntervalList
                .add(userData[j]['timeInterval']); // Adding Time interval
            allDepoDailyEnergyConsumedList
                .add(userData[j]['energyConsumed']); // Adding Energy Consumed
            row.add(srNo); // Adding Serial Numbers for table
            row.add(selectedCityName);
            row.add(provider.depoList![k]);
            row.add(userData[j]['energyConsumed']); //Adding energy consumed
            rows.add(row);
          }
        }

        if (totalEnergyConsumedInEachDepo > greaterValue) {
          greaterValue = totalEnergyConsumedInEachDepo;
          print('greaterValue - $greaterValue');
        }

        // maximumEnergyConsumed =
        //     maximumEnergyConsumed + totalEnergyConsumedInEachDepo;

        energyConsumedList.add(totalEnergyConsumedInEachDepo);
        // print('aaa ${totalEnergyConsumedInEachDepo}');
      }

      provider.setAllDepoDailyConsumedList(energyConsumedList);
      provider.setMaxEnergyConsumed(greaterValue);

      // provider.setMaxEnergyConsumed(maxEnergyConsumed);

      // print('Rows - $rows');
      //Sets Start and End Date for provider
      getStartEndDate();
    } catch (e) {
      print('Error Occured in Fetching All Depo Daily Data - $e');
    }
  }

  Future<void> getAllDepoMonthlyData() async {
    try {
      allDepotsMonthlyConsumedList.clear();
      rows.clear();
      timeIntervalList.clear();
      energyConsumedList.clear();
      dateList.clear();

      double greaterValue = 0.0;

      double totalEnergyConsumedInEachDepo = 0.0;

      final provider = Provider.of<DemandEnergyProvider>(
        context,
        listen: false,
      );

      // final selectedDepoName = provider.selectedDepo;

      final selectedCityName = Provider.of<DemandEnergyProvider>(
        context,
        listen: false,
      ).selectedCity;

      for (int k = 0; k < provider.depoList!.length; k++) {
        totalEnergyConsumedInEachDepo = 0.0;

        CollectionReference collectionReference = FirebaseFirestore.instance
            .collection('EnergyManagementTable')
            .doc(selectedCityName)
            .collection('Depots')
            .doc(provider.depoList![k])
            .collection('Year')
            .doc(currentYear.toString())
            .collection('Months')
            .doc(currentMonth)
            .collection('Date');

        // dateList.add(currentDay);
        monthList.add(currentMonth);

        QuerySnapshot monthlyQuerySnap = await collectionReference.get();

        List<dynamic> monthlyDateList =
            monthlyQuerySnap.docs.map((data) => data.id).toList();

        dateList = dateList + monthlyDateList;

        // print('All Depo Monthly Data List - $monthlyDateList');

        for (int i = 0; i < monthlyDateList.length; i++) {
          QuerySnapshot querySnapshot = await collectionReference
              .doc(monthlyDateList[i])
              .collection('UserId')
              .get();

          List<dynamic> allUsers =
              querySnapshot.docs.map((userid) => userid.id).toList();

          if (allUsers.isNotEmpty) {
            int srNo = 0;
            DocumentSnapshot daySnap = await collectionReference
                .doc(monthlyDateList[i])
                .collection('UserId')
                .doc(allUsers[0])
                .get();

            Map<String, dynamic> mapData =
                daySnap.data() as Map<String, dynamic>;
            List<dynamic> userData = mapData['data'];
            // print('mapData - $userData');

            for (int j = 0; j < userData.length; j++) {
              srNo = srNo + 1;
              List<dynamic> row = [];
              timeIntervalList
                  .add(userData[j]['timeInterval']); // Adding Time interval
              // energyConsumedList
              //     .add(userData[j]['energyConsumed']); // Adding Energy Consumed
              row.add(srNo); // Adding Serial Numbers for table
              row.add(selectedCityName);
              row.add(provider.depoList![k]);
              row.add(userData[j]['energyConsumed']); //Adding energy consumed
              totalEnergyConsumedInEachDepo = totalEnergyConsumedInEachDepo +
                  double.parse(userData[j]['energyConsumed'].toString());
              rows.add(row);
            }
          }

          if (totalEnergyConsumedInEachDepo > greaterValue) {
            greaterValue = totalEnergyConsumedInEachDepo;
            print('greaterValue - $greaterValue');
          }

          // energyConsumedInEachDepo =
          //     energyConsumedInEachDepo + totalEnergyConsumedInEachDepo;
          energyConsumedList.add(totalEnergyConsumedInEachDepo);
        }

        allDepotsMonthlyConsumedList.add(totalEnergyConsumedInEachDepo);
        print('AllDepoMonthlyData -  $allDepotsMonthlyConsumedList');
      }
      // print('MaxEnergyConsumed - $energyConsumedInEachDepo');

      provider.setAllDepoMonthlyConsumedList(energyConsumedList);
      provider.setMaxEnergyConsumed(greaterValue);

      // provider.setMaxEnergyConsumed(maxEnergyConsumed);

      // print('Rows - $rows');
      //Sets Start and End Date for provider
      getStartEndDate();
    } catch (e) {
      print('Error Occured in Fetching All Depo Momthly Data - $e');
    }
  }

  Future<void> getAllDepoQuarterData() async {
    try {
      List<String> firstQuarterName = ['Jan', 'Feb', 'Mar'];
      List<String> secondQuarterName = ['Apr', 'May', 'Jun'];
      List<String> thirdQuarterName = ['Jul', 'Aug', 'Sep'];
      List<String> fourthQuarterName = ['Oct', 'Nov', 'Dec'];

      List<String> firstQuarter = ['January', 'February', 'March'];
      List<String> secondQuarter = ['April', 'May', 'June'];
      List<String> thirdQuarter = ['July', 'August', 'September'];
      List<String> fourthQuarter = ['October', 'November', 'December'];

      List<String> selectedQuarterMonths = [];

      dateList.clear();
      allDepoQuaterlyConsumedList.clear();

      final provider =
          Provider.of<DemandEnergyProvider>(context, listen: false);

      final selectedCityName = provider.selectedCity;

      switch (provider.selectedQuarter) {
        case 'Jan - Mar':
          selectedQuarterMonths = firstQuarter;
          provider.setQuarterNames(firstQuarterName);
          break;
        case 'Apr - Jun':
          selectedQuarterMonths = secondQuarter;
          provider.setQuarterNames(secondQuarterName);
          break;
        case 'Jul - Sep':
          selectedQuarterMonths = thirdQuarter;
          provider.setQuarterNames(thirdQuarterName);
          break;
        case 'Oct - Dec':
          selectedQuarterMonths = fourthQuarter;
          provider.setQuarterNames(fourthQuarterName);
          break;

        default:
          print('Invalid Quarter Selected in Switch Case');
      }

      print(selectedQuarterMonths);

      double energyConsumedInSingleMonth = 0;
      List<dynamic> selectedDates = [];

      //March Month Data//

      for (int i = 0; i < selectedQuarterMonths.length; i++) {
        List<double> energyConsumedInSelectedQuarter = [];

        for (int m = 0; m < provider.depoList!.length; m++) {
          CollectionReference collectionReference = FirebaseFirestore.instance
              .collection('EnergyManagementTable')
              .doc(selectedCityName)
              .collection('Depots')
              .doc(provider.depoList![m])
              .collection('Year')
              .doc(currentYear.toString())
              .collection('Months');

          QuerySnapshot marchQuerySnap = await collectionReference
              .doc(selectedQuarterMonths[i])
              .collection('Date')
              .get();

          selectedDates = marchQuerySnap.docs.map((data) => data.id).toList();
          dateList = dateList + selectedDates;

          if (selectedDates.isNotEmpty) {
            energyConsumedInSingleMonth =
                // energyConsumedInJanToMarchInEachDepo +
                await fetchMonthlyData(
                    collectionReference,
                    selectedDates,
                    energyConsumedInSingleMonth,
                    selectedQuarterMonths[i],
                    provider.depoList![m]);

            if (energyConsumedInSingleMonth > totalEnergyConsumedQuaterly) {
              totalEnergyConsumedQuaterly = energyConsumedInSingleMonth;
            }

            print('energyconsumedInSingleMonth - $energyConsumedInSingleMonth');
          } else {
            energyConsumedInSingleMonth = 0;
          }

          energyConsumedInSelectedQuarter.add(energyConsumedInSingleMonth);
        }

        allDepoQuaterlyConsumedList.add(energyConsumedInSelectedQuarter);
        // print('AllDepoQuarterlyData - $energyConsumedInSelectedQuarter');
        // print('abc - $allDepoQuaterlyConsumedList');
      }

      provider.setAllDepoQuaterlyConsumedList(allDepoQuaterlyConsumedList);

      //Setting Maximum energy consumed quaterly
      provider.setMaxEnergyConsumed(totalEnergyConsumedQuaterly);
      getStartEndDate();
    } catch (error) {
      print('Error Occured in Fetching All Depo Quaterly Data - $error');
    }
  }

  Future<void> gettAllDepoYearlyData() async {
    try {
      rows.clear();
      monthList.clear();
      timeIntervalList.clear();
      energyConsumedList.clear();
      yearlyEnergyConsumedList.clear();
      dateList.clear();

      final provider =
          Provider.of<DemandEnergyProvider>(context, listen: false);

      final selectedCityName = provider.selectedCity;

      List<String> yearlyMonths = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];

      double greaterValue = 0.0;

      List<double> depotsEnergyMonthly = [];

      List<List<double>> depotsEnergyYearly = [];

      for (int i = 0; i < yearlyMonths.length; i++) {
        depotsEnergyMonthly = [];
        double totalEnergyConsumedYearlyInEachDepo = 0;

        for (int k = 0; k < provider.depoList!.length; k++) {
          CollectionReference collectionReference = FirebaseFirestore.instance
              .collection('EnergyManagementTable')
              .doc(selectedCityName)
              .collection('Depots')
              .doc(provider.depoList![k])
              .collection('Year')
              .doc(currentYear.toString())
              .collection('Months');

          QuerySnapshot marchQuerySnap = await collectionReference
              .doc(yearlyMonths[i])
              .collection('Date')
              .get();

          List<dynamic> marchDates =
              marchQuerySnap.docs.map((data) => data.id).toList();

          dateList = dateList + marchDates;

          double energyConsumed = 0.0;

          energyConsumed = await fetchMonthlyData(
              collectionReference,
              marchDates,
              energyConsumed,
              yearlyMonths[i],
              provider.depoList![k]);

          totalEnergyConsumedYearlyInEachDepo =
              totalEnergyConsumedYearlyInEachDepo + energyConsumed;

          if (energyConsumed > greaterValue) {
            greaterValue = totalEnergyConsumedYearlyInEachDepo;
            print('greaterValue - $greaterValue');
          }

          depotsEnergyMonthly.add(energyConsumed);
        }

        yearlyEnergyConsumedList.add(totalEnergyConsumedYearlyInEachDepo);

        // totalEnergyConsumed =
        //     totalEnergyConsumed + totalEnergyConsumedYearlyInEachDepo;

        allDepotsYearlyConsumedList.add(depotsEnergyMonthly);
      }

      // provider.setAllDepoYearlyConsumedList(depotsEnergyYearly);
      provider.setMaxEnergyConsumed(greaterValue);
      getStartEndDate();
    } catch (error) {
      print('Error Occured in Fetching All Depo Yearly Data - $error');
    }
  }

  Future<void> getCurrentDayData() async {
    try {
      rows.clear();
      timeIntervalList.clear();

      energyConsumedList.clear();

      dateList.clear();

      double maxEnergyConsumed = 0;

      final provider = Provider.of<DemandEnergyProvider>(
        context,
        listen: false,
      );

      final selectedDepoName = provider.selectedDepo;

      final selectedCityName = Provider.of<DemandEnergyProvider>(
        context,
        listen: false,
      ).selectedCity;

      CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('EnergyManagementTable')
          .doc(selectedCityName)
          .collection('Depots')
          .doc(selectedDepoName)
          .collection('Year')
          .doc(currentYear.toString())
          .collection('Months')
          .doc(currentMonth)
          .collection('Date')
          .doc(currentDay)
          .collection('UserId');

      dateList.add(currentDay);

      QuerySnapshot querySnapshot = await collectionReference.get();

      List<dynamic> allUsers = querySnapshot.docs
          .map(
            (userid) => userid.id,
          )
          .toList();

      print('All Users - $allUsers');

      // for (int i = 0; i < allUsers.length; i++) {
      if (allUsers.isNotEmpty) {
        DocumentSnapshot daySnap =
            await collectionReference.doc(allUsers[0]).get();
        Map<String, dynamic> mapData = daySnap.data() as Map<String, dynamic>;
        List<dynamic> userData = mapData['data'];

        for (int j = 0; j < userData.length; j++) {
          List<dynamic> row = [];
          timeIntervalList
              .add(userData[j]['timeInterval']); // Adding Time interval
          energyConsumedList
              .add(userData[j]['energyConsumed']); // Adding Energy Consumed
          maxEnergyConsumed = maxEnergyConsumed +
              double.parse(userData[j]['energyConsumed'].toString());
          row.add(userData[j]['srNo']); // Adding Serial Numbers for table
          row.add(selectedCityName);
          row.add(selectedDepoName);
          row.add(userData[j]['energyConsumed']); //Adding energy consumed
          rows.add(row);
        }
      }

      // }

      provider.setDailyConsumedList(energyConsumedList);
      provider.setMaxEnergyConsumed(maxEnergyConsumed);

      //Sets Start and End Date for provider
      getStartEndDate();
    } catch (e) {
      print('Error Occured in Fetching Daily Data - $e');
    }
  }

  Future<void> getCurrentMonthData() async {
    try {
      rows.clear();
      monthList.clear();
      timeIntervalList.clear();
      energyConsumedList.clear();
      dateList.clear();

      final provider =
          Provider.of<DemandEnergyProvider>(context, listen: false);

      double totalConsumedEnergyMonthly = 0;

      final selectedDepoName = provider.selectedDepo;

      final selectedCityName = provider.selectedCity;

      final selectedMonth = provider.selectedMonth;

      CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('EnergyManagementTable')
          .doc(selectedCityName)
          .collection('Depots')
          .doc(selectedDepoName)
          .collection('Year')
          .doc(currentYear.toString())
          .collection('Months')
          .doc(selectedMonth) // currentMonth
          .collection('Date');

      // dateList.add(currentDay);
      monthList.add(currentMonth);

      QuerySnapshot monthlyQuerySnap = await collectionReference.get();
      List<dynamic> monthlyDateList =
          monthlyQuerySnap.docs.map((data) => data.id).toList();
      dateList = monthlyDateList + dateList;
      print('Monthly Data List - $monthlyDateList');

      for (int i = 0; i < monthlyDateList.length; i++) {
        QuerySnapshot querySnapshot = await collectionReference
            .doc(monthlyDateList[i])
            .collection('UserId')
            .get();

        List<dynamic> allUsers =
            querySnapshot.docs.map((userid) => userid.id).toList();

        if (allUsers.isNotEmpty) {
          DocumentSnapshot daySnap = await collectionReference
              .doc(monthlyDateList[i])
              .collection('UserId')
              .doc(allUsers[0])
              .get();
          Map<String, dynamic> mapData = daySnap.data() as Map<String, dynamic>;
          List<dynamic> userData = mapData['data'];
          print('mapData - $userData');

          for (int j = 0; j < userData.length; j++) {
            List<dynamic> row = [];
            timeIntervalList
                .add(userData[j]['timeInterval']); // Adding Time interval
            energyConsumedList
                .add(userData[j]['energyConsumed']); // Adding Energy Consumed
            row.add(userData[j]['srNo']); // Adding Serial Numbers for table
            row.add(selectedCityName);
            row.add(selectedDepoName);
            row.add(userData[j]['energyConsumed']); //Adding energy consumed
            totalConsumedEnergyMonthly = totalConsumedEnergyMonthly +
                double.parse(userData[j]['energyConsumed'].toString());
            rows.add(row);
          }

          Provider.of<DemandEnergyProvider>(context, listen: false)
              .setMonthlyEnergyConsumed(totalConsumedEnergyMonthly);

          provider.setMaxEnergyConsumed(totalConsumedEnergyMonthly);

          // print('monthly rows - $rows');
          // for (var user in userData) {
          //   List<dynamic> row = [];
          //   timeIntervalList.add(user['timeInterval']);
          //   energyConsumedList.add(user['energyConsumed']);
          //   row.add(user['srNo']);
          //   row.add(selectedCityName);
          //   row.add(selectedDepoName);
          //   row.add(user['energyConsumed']);
          //   rows.add(row);
          // }
        }
        // print('TimeIntervalList - $timeIntervalList');
      }

      //Sets Start and End Date for provider
      getStartEndDate();
    } catch (e) {
      print('Error Occured in Fetching Monthly Data - $e');
    }
  }

  Future<void> getQuaterlyData() async {
    try {
      List<String> firstQuarterName = ['Jan', 'Feb', 'Mar'];
      List<String> secondQuarterName = ['Apr', 'May', 'Jun'];
      List<String> thirdQuarterName = ['Jul', 'Aug', 'Sep'];
      List<String> fourthQuarterName = ['Oct', 'Nov', 'Dec'];

      List<String> firstQuarter = ['January', 'February', 'March'];
      List<String> secondQuarter = ['April', 'May', 'June'];
      List<String> thirdQuarter = ['July', 'August', 'September'];
      List<String> fourthQuarter = ['October', 'November', 'December'];
      List<String> selectedQuarterMonths = [];

      rows.clear();
      monthList.clear();
      timeIntervalList.clear();
      energyConsumedList.clear();
      dateList.clear();
      quaterlyEnergyConsumedList.clear();

      final provider =
          Provider.of<DemandEnergyProvider>(context, listen: false);

      final selectedDepoName = provider.selectedDepo;
      final selectedCityName = provider.selectedCity;

      CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('EnergyManagementTable')
          .doc(selectedCityName)
          .collection('Depots')
          .doc(selectedDepoName)
          .collection('Year')
          .doc(currentYear.toString())
          .collection('Months');

      double energyConsumedInJanToMarch = 0;
      // double energyConsumedInAprToJune = 0;
      // double energyConsumedInJulToSeptember = 0;
      // double energyConsumedInOctToDecember = 0;
      double totalEnergy = 0.0;
      List<dynamic> totalDates = [];

      List<dynamic> marchDates = [];
      // juneDates = [],
      // septemberDates = [],
      // decemberDates = [];

      //March Month Data//

      switch (provider.selectedQuarter) {
        case 'Jan - Mar':
          selectedQuarterMonths = firstQuarter;
          provider.setQuarterNames(firstQuarterName);
          break;
        case 'Apr - Jun':
          selectedQuarterMonths = secondQuarter;
          provider.setQuarterNames(secondQuarterName);
          break;
        case 'Jul - Sep':
          selectedQuarterMonths = thirdQuarter;
          provider.setQuarterNames(thirdQuarterName);
          break;
        case 'Oct - Dec':
          selectedQuarterMonths = fourthQuarter;
          provider.setQuarterNames(fourthQuarterName);
          break;
        default:
          print('Invalid Quarter Selected in Switch Case');
      }

      for (int i = 0; i < selectedQuarterMonths.length; i++) {
        energyConsumedInJanToMarch = 0;
        QuerySnapshot querySnap = await collectionReference
            .doc(selectedQuarterMonths[i])
            .collection('Date')
            .get();

        marchDates = querySnap.docs.map((data) => data.id).toList();
        totalDates.add(marchDates);

        if (marchDates.isNotEmpty) {
          energyConsumedInJanToMarch = await fetchMonthlyData(
              collectionReference,
              marchDates,
              energyConsumedInJanToMarch,
              selectedQuarterMonths[i],
              selectedDepoName);
          totalEnergy = totalEnergy + energyConsumedInJanToMarch;
        }

        quaterlyEnergyConsumedList.add(energyConsumedInJanToMarch);
      }
      provider.setQuaterlyConsumedList(quaterlyEnergyConsumedList);
      provider.setMaxEnergyConsumed(totalEnergy);
      // dateList = marchDates;
      // print(
      //     ' ${provider.quaterlyEnergyConsumedList} & $totalEnergy & $totalDates');

      // //June Month Data//

      // for (int j = 0; j < secondQuarter.length; j++) {
      //   QuerySnapshot juneQuerySnap = await collectionReference
      //       .doc(secondQuarter[j])
      //       .collection('Date')
      //       .get();

      //   juneDates = juneQuerySnap.docs.map((data) => data.id).toList();

      //   if (juneDates.isNotEmpty) {
      //     energyConsumedInAprToJune = await fetchMonthlyData(
      //         collectionReference,
      //         juneDates,
      //         energyConsumedInAprToJune,
      //         secondQuarter[j],
      //         selectedDepoName);
      //   }
      // }

      // //September Month Data

      // for (int k = 0; k < thirdQuarter.length; k++) {
      //   QuerySnapshot septemberQuerySnap = await collectionReference
      //       .doc(thirdQuarter[k])
      //       .collection('Date')
      //       .get();

      //   septemberDates =
      //       septemberQuerySnap.docs.map((data) => data.id).toList();

      //   if (septemberDates.isNotEmpty) {
      //     energyConsumedInJulToSeptember = await fetchMonthlyData(
      //         collectionReference,
      //         septemberDates,
      //         energyConsumedInJulToSeptember,
      //         thirdQuarter[k],
      //         selectedDepoName);
      //   }
      // }

      // //December Month Data

      // for (int z = 0; z < fourthQuarter.length; z++) {
      //   QuerySnapshot decemberQuerySnap = await collectionReference
      //       .doc(fourthQuarter[z])
      //       .collection('Date')
      //       .get();

      //   decemberDates = decemberQuerySnap.docs.map((data) => data.id).toList();

      //   if (decemberDates.isNotEmpty) {
      //     energyConsumedInOctToDecember = await fetchMonthlyData(
      //         collectionReference,
      //         decemberDates,
      //         energyConsumedInOctToDecember,
      //         fourthQuarter[z],
      //         selectedDepoName);
      //   }
      // }

      //  juneDates + septemberDates + decemberDates;

      // quaterlyEnergyConsumedList
      //     .add(energyConsumedInJanToMarch); // Total consumed energy in march
      // quaterlyEnergyConsumedList
      //     .add(energyConsumedInAprToJune); // Total consumed energy in june
      // quaterlyEnergyConsumedList
      //     .add(energyConsumedInJulToSeptember); // Total consumed energy in sept
      // quaterlyEnergyConsumedList
      //     .add(energyConsumedInOctToDecember); // Total consumed energy in dec

      // provider.setQuaterlyConsumedList(quaterlyEnergyConsumedList);

      // totalEnergyConsumedQuaterly = energyConsumedInJanToMarch;

      // energyConsumedInAprToJune +
      // energyConsumedInJulToSeptember +
      // energyConsumedInOctToDecember;

//Setting Maximum energy consumed quaterly
      // provider.setMaxEnergyConsumed(totalEnergyConsumedQuaterly);
    } catch (error) {
      print('Error Occured in Fetching Quaterly Data - $error');
    }
  }

  Future<double> fetchMonthlyData(
      CollectionReference collectionReference,
      List<dynamic> dates,
      double totalEnergyConsumed,
      String month,
      String currentDepoName) async {
    print('dates - $dates , month - $month , currentDepo - $currentDepoName');
    for (int i = 0; i < dates.length; i++) {
      totalEnergyConsumed = 0;
      final provider =
          Provider.of<DemandEnergyProvider>(context, listen: false);
      final selectedCityName = provider.selectedCity;
      // final selectedDepoName = provider.selectedDepo;
      QuerySnapshot querySnapshot = await collectionReference
          .doc(month)
          .collection('Date')
          .doc(dates[i])
          .collection('UserId')
          .get();

      // dateList.add(dates[i]);

      List<dynamic> userIdList =
          querySnapshot.docs.map((data) => data.id).toList();

      // print('SM UserId - $userIdList');

      if (userIdList.isNotEmpty) {
        int srNo = 0;
        DocumentSnapshot documentSnapshot = await collectionReference
            .doc(month)
            .collection('Date')
            .doc(dates[i])
            .collection('UserId')
            .doc(userIdList[0])
            .get();

        Map<String, dynamic> mapData =
            documentSnapshot.data() as Map<String, dynamic>;

        List<dynamic> userData = mapData['data'];

        for (int z = 0; z < userData.length; z++) {
          srNo = srNo + 1;

          totalEnergyConsumed = totalEnergyConsumed +
              double.parse(userData[z]['energyConsumed'].toString());

          List<dynamic> row = [];

          timeIntervalList
              .add(userData[z]['timeInterval']); // Adding Time interval
          row.add(srNo); // Adding Serial Numbers for table
          row.add(selectedCityName);
          row.add(currentDepoName);
          row.add(userData[z]['energyConsumed']); //Adding energy consumed
          rows.add(row);
        }
      }
    }
    print(totalEnergyConsumed);
    return totalEnergyConsumed;
  }

  Future<void> getYearlyData() async {
    try {
      rows.clear();
      monthList.clear();
      timeIntervalList.clear();
      energyConsumedList.clear();
      dateList.clear();
      yearlyEnergyConsumedList.clear();

      final provider =
          Provider.of<DemandEnergyProvider>(context, listen: false);

      final selectedDepoName = provider.selectedDepo;
      final selectedCityName = provider.selectedCity;
      final selectedYear = provider.selectedYear;

      double totalEnergyConsumedYearly = 0;

      CollectionReference collectionReference = FirebaseFirestore.instance
          .collection('EnergyManagementTable')
          .doc(selectedCityName)
          .collection('Depots')
          .doc(selectedDepoName)
          .collection('Year')
          .doc(selectedYear) // currentYear.toString()
          .collection('Months');

      List<String> yearlyMonths = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];

      for (int i = 0; i < yearlyMonths.length; i++) {
        QuerySnapshot marchQuerySnap = await collectionReference
            .doc(yearlyMonths[i])
            .collection('Date')
            .get();

        List<dynamic> marchDates =
            marchQuerySnap.docs.map((data) => data.id).toList();

        double energyConsumed = 0.0;

        energyConsumed = await fetchMonthlyData(collectionReference, marchDates,
            energyConsumed, yearlyMonths[i], selectedDepoName);

        totalEnergyConsumedYearly = totalEnergyConsumedYearly + energyConsumed;

        yearlyEnergyConsumedList.add(energyConsumed);
      }

      provider.setYearlyConsumedList(yearlyEnergyConsumedList);
      provider.setMaxEnergyConsumed(totalEnergyConsumedYearly);
    } catch (error) {
      print('Error Occured in Fetching Yearly Data - $error');
    }
  }

  void getStartEndDate() {
    dateList.sort();
    final provider = Provider.of<DemandEnergyProvider>(context, listen: false);
    final startDate = dateList.first;
    provider.setStartDate(startDate);
    final endDate = dateList.last;
    provider.setEndDate(endDate);
  }
}
