// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:assingment/widget/style.dart';

import '../KeysEvents/ChartData.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewPagesState();
}

class _OverviewPagesState extends State<Overview> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('Site Survey', 35, blue),
      ChartData('Detailed Engineering', 38, blue),
      ChartData('Site Mobilization ', 34, blue),
      ChartData('Approval Of Statutory', 52, blue)
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: blue,
        title: const Text('Overview'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SfCircularChart(
            legend: Legend(isVisible: true, position: LegendPosition.bottom),
            series: <CircularSeries>[
              PieSeries<ChartData, String>(
                  dataSource: chartData,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y)
            ],
          ),
          Image.asset(
            'assets/risk.png',
            width: 380,
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }
}
