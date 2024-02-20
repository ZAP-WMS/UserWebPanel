import 'package:assingment/model/daily_projectModel.dart';
import 'package:assingment/model/energy_management.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SummaryProvider extends ChangeNotifier {
  List<DailyProjectModel> _dailydata = [];
  List<EnergyManagementModel> _energydata = [];

  List<dynamic> intervalListData = [];
  List<dynamic> energyListData = [];

  List<dynamic> get intervalData => intervalListData;
  List<dynamic> get energyConsumedData => energyListData;

  List<DailyProjectModel> get dailydata {
    return _dailydata;
  }

  List<EnergyManagementModel> get energyData {
    return _energydata;
  }

  fetchdailydata(
      String depoName, String userId, DateTime date, DateTime endDate) async {
    final List<DailyProjectModel> loadeddata = [];
    _dailydata.clear();
    for (DateTime initialdate = endDate;
        initialdate.isAfter(date.subtract(const Duration(days: 1)));
        initialdate = initialdate.subtract(const Duration(days: 1))) {
      print(date.add(const Duration(days: 1)));
      print(DateFormat.yMMMMd().format(initialdate));
      FirebaseFirestore.instance
          .collection('DailyProjectReport2')
          .doc(depoName)
          .collection('userId')
          .doc(userId)
          .collection('date')
          .doc(DateFormat.yMMMMd().format(initialdate))
          .get()
          .then((value) {
        if (value.data() != null) {
          print('swswssw${value.data()!['data'].length}');
          for (int i = 0; i < value.data()!['data'].length; i++) {
            var _data = value.data()!['data'][i];
            loadeddata.add(DailyProjectModel.fromjson(_data));
          }
          _dailydata = loadeddata;
          notifyListeners();
        }
      });
    }
  }

  fetchEnergyData(String cityName, String depoName, String userId,
      DateTime date, DateTime endDate) async {
    final List<dynamic> timeIntervalList = [];
    final List<dynamic> energyConsumedList = [];
    int currentMonth = DateTime.now().month;
    String monthName = DateFormat('MMMM').format(DateTime.now());
    final List<EnergyManagementModel> fetchedData = [];
    _energydata.clear();
    timeIntervalList.clear();
    energyConsumedList.clear();
    for (DateTime initialdate = endDate;
        initialdate.isAfter(date.subtract(const Duration(days: 1)));
        initialdate = initialdate.subtract(const Duration(days: 1))) {
      // print(date.add(const Duration(days: 1)));
      // print(DateFormat.yMMMMd().format(initialdate));

      FirebaseFirestore.instance
          .collection('EnergyManagementTable')
          .doc(cityName)
          .collection('Depots')
          .doc(depoName)
          .collection('Year')
          .doc(DateTime.now().year.toString())
          .collection('Months')
          .doc(monthName)
          .collection('Date')
          .doc(DateFormat.yMMMMd().format(initialdate))
          .collection('UserId')
          .doc(userId)
          .get()
          .then((value) {
        if (value.data() != null) {
          for (int i = 0; i < value.data()!['data'].length; i++) {
            var data = value.data()!['data'][i];
            fetchedData.add(EnergyManagementModel.fromJson(data));
            timeIntervalList.add(value.data()!['data'][i]['timeInterval']);
            energyConsumedList.add(value.data()!['data'][i]['energyConsumed']);
          }
          _energydata = fetchedData;
          intervalListData = timeIntervalList;
          energyListData = energyConsumedList;
          notifyListeners();
        } else {
          intervalListData = timeIntervalList;
          energyListData = energyConsumedList;

          notifyListeners();
        }
      });
    }
  }
}
