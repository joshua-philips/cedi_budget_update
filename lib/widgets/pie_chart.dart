import 'package:cedi_budget_update/models/budget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieChartCardFL extends StatefulWidget {
  final Budget budget;

  const PieChartCardFL({Key? key, required this.budget}) : super(key: key);
  @override
  _PieChartCardFLState createState() => _PieChartCardFLState();
}

class _PieChartCardFLState extends State<PieChartCardFL> {
  int touchedIndex = -1;
  late Map<String, double> dataMap;

  @override
  void initState() {
    super.initState();
    dataMap = {
      'Spent': widget.budget.amountUsed,
      'Saved': widget.budget.amountSaved,
      'Balance': widget.budget.amount -
          widget.budget.amountUsed -
          widget.budget.amountSaved,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: PieChart(
                PieChartData(
                  centerSpaceRadius: 50,
                  sections: getSections(touchedIndex),
                  sectionsSpace: 4,
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      setState(() {
                        if (!event.isInterestedForInteractions ||
                            pieTouchResponse == null ||
                            pieTouchResponse.touchedSection == null) {
                          touchedIndex = -1;
                          return;
                        }
                        touchedIndex = pieTouchResponse
                            .touchedSection!.touchedSectionIndex;
                      });
                    },
                  ),
                ),
              ),
            ),
            Divider(thickness: 1.5),
            SizedBox(width: 8),
            buildIndicators(),
          ],
        ),
      ),
    );
  }

  Widget buildIndicators() {
    double size = 16;
    List<Color> colors = [Colors.pink[600]!, Colors.green, Colors.deepPurple];
    List<String> indicatorText = ['Spent', 'Saved', 'Balance'];
    List<Widget> indicators = [];
    for (int count = 0; count < 3; count++) {
      indicators.add(
        Row(
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors[count],
              ),
            ),
            SizedBox(width: 10),
            Text(
              indicatorText[count],
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(left: 10, bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: indicators,
      ),
    );
  }

  List<PieChartSectionData> getSections(int touchedIndex) {
    return [
      PieChartSectionData(
        color: Colors.pink[600],
        title:
            '¢${dataMap.values.elementAt(0).toStringAsFixed(2)}\n${touchedIndex == 0 ? dataMap.keys.elementAt(0) : ''}',
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        radius: touchedIndex == 0 ? 90 : 70,
      ),
      PieChartSectionData(
        color: Colors.green,
        title:
            '¢${dataMap.values.elementAt(1).toStringAsFixed(2)}\n${touchedIndex == 1 ? dataMap.keys.elementAt(1) : ''}',
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        radius: touchedIndex == 1 ? 90 : 70,
      ),
      PieChartSectionData(
        color: Colors.deepPurple,
        title:
            '¢${dataMap.values.elementAt(2).toStringAsFixed(2)}\n${touchedIndex == 2 ? dataMap.keys.elementAt(2) : ''}',
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        radius: touchedIndex == 2 ? 90 : 70,
      ),
    ];
  }
}
