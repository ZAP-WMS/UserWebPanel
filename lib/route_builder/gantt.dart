import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gantt_chart/gantt_chart.dart';

import '../widget/keyboard_listener.dart';

class GanttChart extends StatefulWidget {
  const GanttChart({super.key});

  @override
  State<GanttChart> createState() => _GanttChartState();
}

class _GanttChartState extends State<GanttChart> {
  ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return keyBoardArrow(
        scrollController: scrollController,
        myScaffold: Scaffold(
          body: SingleChildScrollView(
            child: GanttChartView(
              scrollController: scrollController,
              // scrollPhysics: BouncingScrollPhysics(),
              maxDuration: const Duration(days: 30 * 5),
              //optional, set to null for infinite horizontal scroll
              startDate: DateTime(2022, 6, 7), //required
              dayWidth: 30, //column width for each day
              eventHeight: 30, //row height for events
              stickyAreaWidth: 200, //sticky area width
              showStickyArea: true, //show sticky area or not
              showDays: true, //show days or not
              startOfTheWeek: WeekDay.monday, //custom start of the week
              weekEnds: const {WeekDay.sunday}, //custom weekends
              isExtraHoliday: (context, day) {
                //define custom holiday logic for each day
                return DateUtils.isSameDay(DateTime(2022, 7, 1), day);
              },
              events: [
                //event relative to startDate
                GanttRelativeEvent(
                  relativeToStart: const Duration(days: 0),
                  duration: const Duration(days: 5),
                  displayName: 'Do a very helpful task',
                ),
                //event with absolute start and end
                GanttAbsoluteEvent(
                  startDate: DateTime(2022, 6, 10),
                  endDate: DateTime(2022, 6, 16),
                  displayName: 'Another task',
                ),
                GanttAbsoluteEvent(
                  startDate: DateTime(2022, 6, 10),
                  endDate: DateTime(2022, 7, 25),
                  displayName: 'Another task',
                ),
                GanttRelativeEvent(
                  relativeToStart: const Duration(days: 0),
                  duration: const Duration(days: 5),
                  displayName: 'Do a very helpful task',
                ),
                //event with absolute start and end
                GanttAbsoluteEvent(
                  startDate: DateTime(2022, 6, 10),
                  endDate: DateTime(2022, 6, 16),
                  displayName: 'Another task',
                ),
                GanttAbsoluteEvent(
                  startDate: DateTime(2022, 6, 10),
                  endDate: DateTime(2022, 7, 25),
                  displayName: 'Another task',
                ),
                GanttRelativeEvent(
                  relativeToStart: const Duration(days: 0),
                  duration: const Duration(days: 5),
                  displayName: 'Do a very helpful task',
                ),
                //event with absolute start and end
                GanttAbsoluteEvent(
                  startDate: DateTime(2022, 6, 10),
                  endDate: DateTime(2022, 6, 16),
                  displayName: 'Another task',
                ),
                GanttAbsoluteEvent(
                  startDate: DateTime(2022, 6, 10),
                  endDate: DateTime(2022, 7, 25),
                  displayName: 'Another task',
                ),
                GanttRelativeEvent(
                  relativeToStart: const Duration(days: 0),
                  duration: const Duration(days: 5),
                  displayName: 'Do a very helpful task',
                ),
                //event with absolute start and end
                GanttAbsoluteEvent(
                  startDate: DateTime(2022, 6, 10),
                  endDate: DateTime(2022, 6, 16),
                  displayName: 'Another task',
                ),
                GanttAbsoluteEvent(
                  startDate: DateTime(2022, 6, 10),
                  endDate: DateTime(2022, 7, 25),
                  displayName: 'Another task',
                ),
                GanttRelativeEvent(
                  relativeToStart: const Duration(days: 0),
                  duration: const Duration(days: 5),
                  displayName: 'Do a very helpful task',
                ),
                //event with absolute start and end
                GanttAbsoluteEvent(
                  startDate: DateTime(2022, 6, 10),
                  endDate: DateTime(2022, 6, 16),
                  displayName: 'Another task',
                ),
                GanttAbsoluteEvent(
                  startDate: DateTime(2022, 6, 10),
                  endDate: DateTime(2022, 7, 25),
                  displayName: 'Another task',
                ),
                GanttRelativeEvent(
                  relativeToStart: const Duration(days: 0),
                  duration: const Duration(days: 5),
                  displayName: 'Do a very helpful task',
                ),
                //event with absolute start and end
                GanttAbsoluteEvent(
                  startDate: DateTime(2022, 6, 10),
                  endDate: DateTime(2022, 6, 16),
                  displayName: 'Another task',
                ),
                GanttAbsoluteEvent(
                  startDate: DateTime(2022, 6, 10),
                  endDate: DateTime(2022, 7, 25),
                  displayName: 'Another task',
                ),
                GanttRelativeEvent(
                  relativeToStart: const Duration(days: 0),
                  duration: const Duration(days: 5),
                  displayName: 'Do a very helpful task',
                ),
                //event with absolute start and end
                GanttAbsoluteEvent(
                  startDate: DateTime(2022, 6, 10),
                  endDate: DateTime(2022, 6, 16),
                  displayName: 'Another task',
                ),
                GanttAbsoluteEvent(
                  startDate: DateTime(2022, 6, 10),
                  endDate: DateTime(2022, 7, 25),
                  displayName: 'Another task',
                ),
                GanttRelativeEvent(
                  relativeToStart: const Duration(days: 0),
                  duration: const Duration(days: 5),
                  displayName: 'Do a very helpful task',
                ),
                //event with absolute start and end
                GanttAbsoluteEvent(
                  startDate: DateTime(2022, 6, 10),
                  endDate: DateTime(2022, 6, 16),
                  displayName: 'Another task',
                ),
                GanttAbsoluteEvent(
                  startDate: DateTime(2022, 6, 10),
                  endDate: DateTime(2022, 7, 25),
                  displayName: 'Another task',
                ),
                GanttRelativeEvent(
                  relativeToStart: const Duration(days: 0),
                  duration: const Duration(days: 5),
                  displayName: 'Do a very helpful task',
                ),
                //event with absolute start and end
                GanttAbsoluteEvent(
                  startDate: DateTime(2022, 6, 10),
                  endDate: DateTime(2022, 6, 16),
                  displayName: 'Another task',
                ),
                GanttAbsoluteEvent(
                  startDate: DateTime(2022, 6, 10),
                  endDate: DateTime(2022, 7, 25),
                  displayName: 'Another task',
                ),
                GanttRelativeEvent(
                  relativeToStart: const Duration(days: 0),
                  duration: const Duration(days: 5),
                  displayName: 'Do a very helpful task',
                ),
                //event with absolute start and end
                GanttAbsoluteEvent(
                  startDate: DateTime(2022, 6, 10),
                  endDate: DateTime(2022, 6, 16),
                  displayName: 'Another task',
                ),
                GanttAbsoluteEvent(
                  startDate: DateTime(2022, 6, 10),
                  endDate: DateTime(2022, 7, 25),
                  displayName: 'Another task',
                ),
              ],
            ),
          ),
        ));
  }
}
