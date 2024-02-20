import 'package:assingment/provider/All_Depo_Select_Provider.dart';
import 'package:assingment/provider/demandEnergyProvider.dart';
import 'package:assingment/widget/style.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BarGraphScreen extends StatefulWidget {
  final List<dynamic> timeIntervalList;
  final List<dynamic> monthList;
  List<List<double>> allDepotsYearlyConsumedList;
  List<double> allDepotsMonthlyConsumedList;
  List<List<double>> allDepotsQuaterlyConsumedList;

  BarGraphScreen({
    super.key,
    required this.timeIntervalList,
    required this.monthList,
    required this.allDepotsYearlyConsumedList,
    required this.allDepotsMonthlyConsumedList,
    required this.allDepotsQuaterlyConsumedList,
  });

  @override
  State<BarGraphScreen> createState() => _BarGraphScreenState();
}

class _BarGraphScreenState extends State<BarGraphScreen> {
  int _selectedIndex = 0;

  List<bool> choiceChipBoolList = [true, false, false, false];

  final Gradient _barRodGradient = const LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    colors: [
      Color.fromARGB(255, 16, 81, 231),
      Color.fromARGB(255, 190, 207, 252)
    ],
  );

  final ScrollController _scrollController = ScrollController();

  List<String> choiceChipLabels = ['Day', 'Monthly', 'Quaterly', 'Yearly'];

  Color themeBlue = const Color.fromARGB(255, 77, 164, 235);

  List<String> quaterlyMonths = [
    'Jan - Mar',
    'Apr - Jun',
    'Jul - Sep',
    'Oct - Dec'
  ];

  List<String> yearlyMonths = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  final List<String> _months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  final List<String> _quarters = [
    "Jan - Mar",
    "Apr - Jun",
    "Jul - Sep",
    "Oct - Dec"
  ];

  final List<String> yearly = [
    "2023",
    "2024",
    "2025",
    "2026",
    "2027",
    "2028",
    "2029",
    "2030",
    "2031",
    "2032",
    "2033",
    "2034",
    "2035",
    "2036",
    "2037",
    "2038",
    "2039",
    "2040"
  ];

  String? _monthValue;
  String? _quarterValue;
  String? _yearValue;

  final double candleWidth = 5;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DemandEnergyProvider>(context, listen: false);
    final allDepoProvider =
        Provider.of<AllDepoSelectProvider>(context, listen: false);

    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 234, 243, 250),
              borderRadius: BorderRadius.circular(5),
            ),
            margin: const EdgeInsets.only(
              bottom: 15,
              top: 10,
            ),
            child: const Text(
              'Energy Consumed (in kW)',
              style: TextStyle(
                fontSize: 18,
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Consumer<DemandEnergyProvider>(
            builder: (context, providerValue, child) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 35),
                        height: 40, //30
                        width: 450, // 320
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: choiceChipLabels.length,
                            shrinkWrap: true,
                            itemBuilder: ((context, index) {
                              return index == 0
                                  ? Container(
                                      margin: const EdgeInsets.only(
                                          left: 10, right: 5.0),
                                      height: 30,
                                      child: ChoiceChip(
                                        side: BorderSide(color: themeBlue),
                                        elevation: 3.0,
                                        labelPadding: const EdgeInsets.only(
                                            left: 20.0,
                                            right: 20.0,
                                            top: 1.0,
                                            bottom: 1.0),
                                        label: Text(
                                          choiceChipLabels[index],
                                          style: TextStyle(
                                              color: _selectedIndex == 0
                                                  ? white
                                                  : themeBlue),
                                        ),
                                        selected: choiceChipBoolList[index],
                                        selectedColor: _selectedIndex == 0
                                            ? Colors.blue
                                            : white,
                                        backgroundColor: white,
                                        onSelected: provider.isLoadingBarCandle
                                            ? (_) {}
                                            : (value) {
                                                if (provider.selectedDepo
                                                        .isNotEmpty ||
                                                    allDepoProvider.isChecked ==
                                                        true) {
                                                  switch (index) {
                                                    case 0:
                                                      _selectedIndex = 0;
                                                      provider
                                                          .setLoadingBarCandle(
                                                              true);
                                                      break;
                                                    case 1:
                                                      _selectedIndex = 1;
                                                      provider
                                                          .setLoadingBarCandle(
                                                              true);
                                                      break;
                                                    case 2:
                                                      _selectedIndex = 2;
                                                      provider
                                                          .setLoadingBarCandle(
                                                              true);
                                                      break;
                                                    case 3:
                                                      _selectedIndex = 3;
                                                      provider
                                                          .setLoadingBarCandle(
                                                              true);
                                                      break;
                                                    default:
                                                      _selectedIndex = 0;
                                                  }
                                                  choiceChipBoolList[index] =
                                                      value;
                                                  resetChoiceChip(index);
                                                  providerValue
                                                      .reloadWidget(true);
                                                  providerValue
                                                      .setSelectedIndex(
                                                          _selectedIndex,
                                                          allDepoProvider
                                                              .isChecked);
                                                } else {
                                                  showCustomAlert();
                                                }
                                              },
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.all(5.0),
                                      child: Center(
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton2<String>(
                                            isExpanded: true,
                                            hint: Row(
                                              children: [
                                                Text(
                                                  choiceChipLabels[index],
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: themeBlue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            items: index == 1
                                                ? customDropDownTab(
                                                    _months,
                                                    index,
                                                    _selectedIndex == 1
                                                        ? white
                                                        : themeBlue)
                                                : index == 2
                                                    ? customDropDownTab(
                                                        _quarters,
                                                        index,
                                                        _selectedIndex == 2
                                                            ? white
                                                            : themeBlue)
                                                    : customDropDownTab(
                                                        yearly,
                                                        index,
                                                        _selectedIndex == 3
                                                            ? white
                                                            : themeBlue),
                                            value: index == 1
                                                ? _monthValue
                                                : index == 2
                                                    ? _quarterValue
                                                    : _yearValue,
                                            onChanged: (String? value) {
                                              if (provider.selectedDepo
                                                      .isNotEmpty ||
                                                  allDepoProvider.isChecked ==
                                                      true) {
                                                choiceChipBoolList[index] =
                                                    !choiceChipBoolList[index];
                                                index == 1
                                                    ? _monthValue = value
                                                    : index == 2
                                                        ? _quarterValue = value
                                                        : _yearValue = value;

                                                switch (index) {
                                                  case 1:
                                                    _selectedIndex = 1;
                                                    provider
                                                        .setLoadingBarCandle(
                                                            true);
                                                    provider.setSelectedMonth(
                                                        value!);
                                                    break;
                                                  case 2:
                                                    _selectedIndex = 2;
                                                    provider
                                                        .setLoadingBarCandle(
                                                            true);
                                                    provider.setQuarterMonth(
                                                        value!);
                                                    break;
                                                  case 3:
                                                    _selectedIndex = 3;
                                                    provider
                                                        .setLoadingBarCandle(
                                                            true);
                                                    provider.setYear(value!);
                                                    break;
                                                  default:
                                                    _selectedIndex = 0;
                                                }

                                                resetChoiceChip(index);
                                                providerValue
                                                    .reloadWidget(true);
                                                providerValue.setSelectedIndex(
                                                    _selectedIndex,
                                                    allDepoProvider.isChecked);
                                              } else {
                                                showCustomAlert();
                                              }
                                            },
                                            buttonStyleData: ButtonStyleData(
                                              height: 30,
                                              width: 90,
                                              padding: const EdgeInsets.only(
                                                  left: 10, right: 5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                border: Border.all(
                                                  color: themeBlue,
                                                ),
                                                color: index == _selectedIndex
                                                    ? themeBlue
                                                    : white,
                                              ),
                                              elevation: 2,
                                            ),
                                            iconStyleData: IconStyleData(
                                              iconSize: 12,
                                              iconEnabledColor:
                                                  index == _selectedIndex
                                                      ? white
                                                      : Colors.blue,
                                            ),
                                            dropdownStyleData:
                                                DropdownStyleData(
                                              maxHeight: 200,
                                              width: 90,
                                              decoration: BoxDecoration(
                                                backgroundBlendMode:
                                                    BlendMode.color,
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                color: index == _selectedIndex
                                                    ? themeBlue
                                                    : Colors.white,
                                              ),
                                              offset: const Offset(0, 0),
                                            ),
                                            menuItemStyleData:
                                                const MenuItemStyleData(
                                              height: 30,
                                              padding: EdgeInsets.only(
                                                  left: 14, right: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                            })),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          Container(
            height: 450,
            width: MediaQuery.of(context).size.width,
            child: Consumer<DemandEnergyProvider>(
              builder: (context, value, child) {
                return Scrollbar(
                  thickness: 3,
                  radius: const Radius.circular(1),
                  thumbVisibility: true,
                  trackVisibility: true,
                  interactive: true,
                  scrollbarOrientation: ScrollbarOrientation.bottom,
                  controller: _scrollController,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    itemCount: 1,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 450,
                        margin: const EdgeInsets.only(top: 50.0),
                        width: (provider.isCheckboxChecked == true &&
                                _selectedIndex == 3)
                            ? 2000
                            : MediaQuery.of(context).size.width * 0.6,
                        child: BarChart(
                          swapAnimationCurve: Curves.easeInOut,
                          swapAnimationDuration: const Duration(
                            milliseconds: 1500,
                          ),
                          BarChartData(
                            alignment: BarChartAlignment.spaceEvenly,
                            barTouchData: BarTouchData(
                              enabled: true,
                              touchTooltipData: BarTouchTooltipData(
                                tooltipRoundedRadius: 5,
                                tooltipBgColor: Colors.white,
                                tooltipMargin: 5,
                                tooltipBorder: BorderSide(color: blue),
                                maxContentWidth: 100,

                                // Hover Depo Name And Energy Consumed

                                getTooltipItem:
                                    (group, groupIndex, rod, rodIndex) {
                                  return BarTooltipItem(
                                    provider.isCheckboxChecked
                                        ? _selectedIndex == 0
                                            ? '${provider.depoList![groupIndex.toInt()]}\n'
                                            : '${provider.depoList![rodIndex.toInt()]}\n'
                                        : provider.selectedDepo.isNotEmpty
                                            ? '${provider.selectedDepo}\n'
                                            : '',
                                    const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 8,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: provider.isCheckboxChecked
                                            ? _selectedIndex == 3
                                                ? '${widget.allDepotsYearlyConsumedList[groupIndex][rodIndex]} kW'
                                                : _selectedIndex == 2
                                                    ? '${widget.allDepotsQuaterlyConsumedList[groupIndex][rodIndex]} kW'
                                                    : _selectedIndex == 1
                                                        ? '${widget.allDepotsMonthlyConsumedList[rodIndex]} kW'
                                                        : '${provider.allDepoDailyEnergyConsumedList[groupIndex]} kW'

                                            // If False
                                            : _selectedIndex == 1
                                                ? '${provider.monthlyEnergyConsumed} kW'
                                                : _selectedIndex == 2
                                                    ? '${provider.quaterlyEnergyConsumedList[groupIndex]} kW'
                                                    : _selectedIndex == 3
                                                        ? '${provider.yearlyEnergyConsumedList[groupIndex]} kW'
                                                        : '0 kW',
                                        style: TextStyle(
                                          color: black,
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            maxY: (provider.maxEnergyConsumed ?? 0.0) + 5000,
                            minY: 0,
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  reservedSize: 60.0,
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    return Container(
                                      margin: const EdgeInsets.only(
                                          left: 20, top: 10),
                                      child: Transform.rotate(
                                        alignment: Alignment.center,
                                        angle: 30.2,
                                        child: Text(
                                          allDepoProvider.isChecked == false
                                              ? provider.selectedIndex == 1
                                                  ? provider.selectedMonth
                                                  : provider.selectedIndex == 2
                                                      ? provider
                                                              .selectedQuarterNames[
                                                          value.toInt()]
                                                      : provider.selectedIndex ==
                                                              3
                                                          ? yearlyMonths[
                                                              value.toInt()]
                                                          : widget.timeIntervalList[
                                                              value.toInt()]

                                              //

                                              : provider.selectedIndex == 0
                                                  ? ''

                                                  //  provider.depoList![
                                                  //     value.toInt()]

                                                  : provider.selectedIndex == 2
                                                      ? provider
                                                              .selectedQuarterNames[
                                                          value.toInt()]
                                                      : provider.selectedIndex ==
                                                              3
                                                          ? yearlyMonths[
                                                              value.toInt()]
                                                          : widget.monthList[
                                                              value.toInt()],
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: false,
                                ),
                              ),
                              // leftTitles: AxisTitles(
                              //   axisNameSize: 150,
                              //   sideTitles: SideTitles(
                              //     showTitles: true,
                              //     reservedSize: 100,
                              //     getTitlesWidget: (value, meta) {
                              //       return Text('100k');
                              //     },
                              //   ),
                              // ),
                            ),
                            gridData: FlGridData(
                              show: false,
                              drawVerticalLine: false,
                              drawHorizontalLine: true,
                              checkToShowHorizontalLine: (value) =>
                                  value % 1 == 0,
                              getDrawingHorizontalLine: (value) {
                                return FlLine(
                                  color: Colors.grey,
                                  strokeWidth: 1,
                                );
                              },
                            ),
                            borderData: FlBorderData(
                              border: const Border(
                                left: BorderSide(),
                                bottom: BorderSide(),
                              ),
                            ),
                            barGroups:
                                //  tempBarData()
                                allDepoProvider.isChecked == false
                                    ? provider.selectedIndex == 1
                                        ? getMonthlyBarGroups()
                                        : provider.selectedIndex == 2
                                            ? getQuaterlyBarData()
                                            : provider.selectedIndex == 3
                                                ? getYearlyBarData()
                                                : getBarGroups()
                                    : provider.selectedIndex == 0
                                        ? getAllDepoDailyBarGroupData()
                                        : provider.selectedIndex == 1
                                            ? getAllDepoMonthlyBarGroupData()
                                            : provider.selectedIndex == 2
                                                ? getAllDepoQuarterlyBarGroupData()
                                                : getAllDepoYearlyBarGroupData(),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> getBarGroups() {
    final provider = Provider.of<DemandEnergyProvider>(context, listen: false);
    // print('Daily BarChart Data Extracting');
    return List.generate(
      provider.dailyEnergyConsumed?.length == null
          ? widget.timeIntervalList.length
          : 0,
      (index) {
        return BarChartGroupData(
          // groupVertically: true,
          // showingTooltipIndicators: [0],
          x: index,
          barRods: [
            BarChartRodData(
              gradient: _barRodGradient,
              width: candleWidth,
              borderRadius: BorderRadius.circular(2),
              toY: provider.dailyEnergyConsumed?[index] ?? 0.0,
            ),
          ],
        );
      },
    ).toList();
  }

  List<BarChartGroupData> getMonthlyBarGroups() {
    final provider = Provider.of<DemandEnergyProvider>(context, listen: false);
    print('MonthlyBarGroup - ${provider.monthlyEnergyConsumed}');
    // print('Monthly BarChart Data Extracting');
    return List.generate(
      1,
      (index) {
        return BarChartGroupData(
          // showingTooltipIndicators: [0],
          x: index,
          barRods: [
            BarChartRodData(
              gradient: _barRodGradient,
              width: candleWidth,
              borderRadius: BorderRadius.circular(2),
              toY: provider.monthlyEnergyConsumed ?? 0.0,
            ),
          ],
        );
      },
    ).toList();
  }

  List<BarChartGroupData> getQuaterlyBarData() {
    final provider = Provider.of<DemandEnergyProvider>(context, listen: false);
    // print('Quaterly BarChart Data Extracting');
    return List.generate(
      3,
      (index) {
        return BarChartGroupData(
          // showingTooltipIndicators: [0],
          x: index,
          barRods: [
            provider.quaterlyEnergyConsumedList.isEmpty
                ? BarChartRodData(
                    gradient: _barRodGradient,
                    width: candleWidth,
                    borderRadius: BorderRadius.circular(2),
                    toY: 100,
                  )
                : BarChartRodData(
                    gradient: _barRodGradient,
                    width: candleWidth,
                    borderRadius: BorderRadius.circular(2),
                    toY: provider.quaterlyEnergyConsumedList[index] ?? 0.0,
                  ),
          ],
        );
      },
    ).toList();
  }

  List<BarChartGroupData> getYearlyBarData() {
    final provider = Provider.of<DemandEnergyProvider>(context, listen: false);

    // print('Yearly BarChart Data Extracting');
    return List.generate(
      12,
      (index) {
        return BarChartGroupData(
          groupVertically: true,
          // showingTooltipIndicators: [0],
          x: index,
          barRods: [
            provider.yearlyEnergyConsumedList.isEmpty
                ? BarChartRodData(
                    gradient: _barRodGradient,
                    width: candleWidth,
                    borderRadius: BorderRadius.circular(2),
                    toY: 100.0,
                  )
                : BarChartRodData(
                    gradient: _barRodGradient,
                    width: candleWidth,
                    borderRadius: BorderRadius.circular(2),
                    toY: provider.yearlyEnergyConsumedList[index],
                  ),
          ],
        );
      },
    ).toList();
  }

  List<BarChartGroupData> getAllDepoDailyBarGroupData() {
    final provider = Provider.of<DemandEnergyProvider>(context, listen: false);
    // print('Daily BarChart Data Extracting');
    return List.generate(
      provider.depoList?.length ?? 5,
      (index) {
        return BarChartGroupData(
          // groupVertically: true,
          // showingTooltipIndicators: [0],
          x: index,
          barRods: [
            provider.allDepoDailyEnergyConsumedList.isEmpty
                ? BarChartRodData(
                    gradient: _barRodGradient,
                    width: candleWidth,
                    borderRadius: BorderRadius.circular(2),
                    toY: 100,
                  )
                : BarChartRodData(
                    gradient: _barRodGradient,
                    width: candleWidth,
                    borderRadius: BorderRadius.circular(2),
                    toY: provider.allDepoDailyEnergyConsumedList[index],
                  ),
          ],
        );
      },
    ).toList();
  }

  List<BarChartGroupData> getAllDepoMonthlyBarGroupData() {
    final provider = Provider.of<DemandEnergyProvider>(context, listen: false);
    print("MonthEnergy - ${widget.allDepotsMonthlyConsumedList}");

    return List.generate(
      widget.allDepotsMonthlyConsumedList.isEmpty ? 1 : 1,
      (index1) {
        return BarChartGroupData(
          x: index1,
          barRods: widget.allDepotsMonthlyConsumedList.isNotEmpty
              ? List.generate(
                  widget.allDepotsMonthlyConsumedList.length,
                  (index2) => BarChartRodData(
                    gradient: _barRodGradient,
                    width: candleWidth,
                    borderRadius: BorderRadius.circular(2),
                    toY: widget.allDepotsMonthlyConsumedList[index2],
                  ),
                ).toList()
              : List.generate(1, (index2) {
                  return BarChartRodData(
                    // color: randomColor,
                    gradient: _barRodGradient,
                    width: candleWidth,
                    borderRadius: BorderRadius.circular(2),
                    toY: 1000,
                  );
                }).toList(),
        );
      },
    ).toList();
  }

  List<BarChartGroupData> getAllDepoQuarterlyBarGroupData() {
    final provider = Provider.of<DemandEnergyProvider>(context, listen: false);
    print('allDepoQuaterlyData - ${widget.allDepotsQuaterlyConsumedList}');
    // print('Daily BarChart Data Extracting');
    return List.generate(
      3,
      (index1) {
        return BarChartGroupData(
            // showingTooltipIndicators: [0],
            x: index1,
            barRods: widget.allDepotsQuaterlyConsumedList.isEmpty
                ? List.generate(
                    10,
                    (index2) => BarChartRodData(
                      gradient: _barRodGradient,
                      width: candleWidth,
                      borderRadius: BorderRadius.circular(2),
                      toY: 100.0,
                    ),
                  )
                : List.generate(
                    widget.allDepotsQuaterlyConsumedList[index1].length,
                    (index2) => BarChartRodData(
                      gradient: _barRodGradient,
                      width: candleWidth,
                      borderRadius: BorderRadius.circular(2),
                      toY: provider.allDepoQuaterlyEnergyConsumedList[index1]
                          [index2],
                    ),
                  ));
      },
    ).toList();
  }

  List<BarChartGroupData> getAllDepoYearlyBarGroupData() {
    print('TempBarData - ${widget.allDepotsYearlyConsumedList}');

    return List.generate(
      widget.allDepotsYearlyConsumedList.isEmpty ? 5 : 12,
      (index1) {
        return BarChartGroupData(
            x: index1,
            barRods: widget.allDepotsYearlyConsumedList.isEmpty
                ? List.generate(1, (index2) {
                    return BarChartRodData(
                      // color: randomColor,
                      gradient: _barRodGradient,
                      width: candleWidth,
                      borderRadius: BorderRadius.circular(2),
                      toY: 100,
                    );
                  }).toList()
                : List.generate(
                    widget.allDepotsYearlyConsumedList[index1].length,
                    (index2) => BarChartRodData(
                      gradient: _barRodGradient,
                      width: candleWidth,
                      borderRadius: BorderRadius.circular(2),
                      toY: widget.allDepotsYearlyConsumedList[index1][index2],
                    ),
                  ).toList());
      },
    ).toList();
  }

  void resetChoiceChip(index) {
    for (int i = 0; i < choiceChipBoolList.length; i++) {
      if (index != i) {
        choiceChipBoolList[i] = false;
      }
    }
  }

  Future<void> showCustomAlert() async {
    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              width: 300,
              height: 170,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: const Icon(
                      Icons.warning,
                      color: Color.fromARGB(255, 240, 222, 67),
                      size: 80,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: const Text(
                      'Please Select a Depot First',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 30,
                    margin: const EdgeInsets.all(5),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(blue)),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'OK',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  customDropDownTab(List<String> dataList, int selectedIndex, Color textColor) {
    // final demandProvider =
    //     Provider.of<DemandEnergyProvider>(context, listen: false);
    return dataList
        .map(
          (String item1) => DropdownMenuItem<String>(
            value: item1,
            onTap: () {
              // selectedIndex == 2
              //     ? demandProvider.setQuarterMonth(item1)
              //     : print('Error in selecting Quarter Month');
            },
            child: Text(
              item1,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        )
        .toList();
  }
}
