import 'package:assingment/screen/o&m%20view/monthly_page/monthly_page.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../../../widget/appbar_back_date.dart';
import '../../../widget/style.dart';

class MonthlyManagementHomePage extends StatefulWidget {
  String? cityName;
  String? depoName;
  MonthlyManagementHomePage({super.key, required this.cityName, this.depoName});

  @override
  State<MonthlyManagementHomePage> createState() =>
      _MonthlyManagementHomePageState();
}

class _MonthlyManagementHomePageState extends State<MonthlyManagementHomePage> {
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        initialIndex: _selectedIndex,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: blue,
              title: Text(
                'Monthly Page ',
                style: TextStyle(color: white, fontWeight: FontWeight.bold),
              ),
              actions: [
                
              ],
              bottom: PreferredSize(
                preferredSize: const Size(double.infinity, 50),
                child: TabBar(
                  labelColor: yellow,
                  labelStyle: buttonWhite,
                  unselectedLabelColor: white,
                  indicator: MaterialIndicator(
                      horizontalPadding: 24,
                      bottomLeftRadius: 8,
                      bottomRightRadius: 8,
                      color: white,
                      paintingStyle: PaintingStyle.fill),
                  tabs: const [
                    Tab(text: 'Charger Reading Format'),
                    Tab(text: 'Charger Filter/DC Connector Cleaning Format'),
                  ],
                  onTap: (value) {
                    print('indexxx$value');
                    setState(() {
                      _selectedIndex = value;
                    });
                  },
                ),
              )),
          body: TabBarView(
            children: [
              MonthlyManagementPage(
                  cityName: widget.cityName,
                  depoName: widget.depoName,
                  tabIndex: _selectedIndex,
                  tabletitle: 'Charger Reading Format'),
              MonthlyManagementPage(
                  cityName: widget.cityName,
                  depoName: widget.depoName,
                  tabIndex: _selectedIndex,
                  tabletitle: 'Charger Filter/DC Connector Cleaning Format'),
            ],
          ),
        ));
  }
}
