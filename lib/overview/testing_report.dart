import 'package:assingment/widget/custom_appbar.dart';
import 'package:flutter/material.dart';

import '../widget/style.dart';

class TestingReport extends StatefulWidget {
  String? cityName;
  String? depoName;
  TestingReport({super.key, required this.cityName, required this.depoName});

  @override
  State<TestingReport> createState() => _TestingReportState();
}

class _TestingReportState extends State<TestingReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CustomAppBar(
          showDepoBar: true,
          toTesting: true,
          cityname: widget.cityName,
          text: ' ${widget.cityName} / ${widget.depoName} / Keys Events',
          haveSynced: false,
        ),
      ),
      body: const Center(
        child: Text(
          'Testing & Commissioning flow \n Under Process',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
