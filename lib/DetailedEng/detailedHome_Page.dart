import 'package:assingment/overview/detailed_Eng.dart';
import 'package:assingment/widget/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../widget/style.dart';

class DetailedHomePage extends StatefulWidget {
  String? cityName;
  String? depoName;
  DetailedHomePage({super.key, required this.cityName, required this.depoName});

  @override
  State<DetailedHomePage> createState() => _DetailedHomePageState();
}

class _DetailedHomePageState extends State<DetailedHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
