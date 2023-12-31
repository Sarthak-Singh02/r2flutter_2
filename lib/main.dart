import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Diabetes Analysis'),
        ),
        body: DiabetesAnalysis(),
      ),
    );
  }
}

class DiabetesAnalysis extends StatefulWidget {
  @override
  _DiabetesAnalysisState createState() => _DiabetesAnalysisState();
}

class _DiabetesAnalysisState extends State<DiabetesAnalysis> {
  List<Map<String, dynamic>> diabetesData = [];

  @override
  void initState() {
    // Initialize diabetes data (similar to the R code)
    for (int i = 0; i < 50; i++) {
      diabetesData.add({
        'Blood_Pressure': 80 + i * 2,
        'Glucose': 70 + i * 2,
      });
    }

    super.initState();
  }

  String categorizeBloodPressure(int bp) {
    return bp > 160 ? 'High' : 'Normal';
  }

  String categorizeType(int bp, int glucose) {
    return (bp > 160 && glucose > 120) ? 'Type1' : 'Type2';
  }

  @override
  Widget build(BuildContext context) {
    int highBpCount = diabetesData
        .where(
            (data) => categorizeBloodPressure(data['Blood_Pressure']) == 'High')
        .length;

    int type2Count = diabetesData
        .where((data) =>
            categorizeType(data['Blood_Pressure'], data['Glucose']) == 'Type2')
        .length;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Number of patients with High Blood Pressure: $highBpCount',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Text(
          'Number of patients with Type 2: $type2Count',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        // Bar Chart (Histogram)
        Text(
          "Blood Pressure Categories",
          style: TextStyle(fontSize: 15),
        ),
        Container(
          height: 300,
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: [
              BarSeries<Map<String, dynamic>, String>(
                dataLabelSettings: DataLabelSettings(isVisible: true),
                dataSource: diabetesData,
                xValueMapper: (data, _) =>
                    categorizeBloodPressure(data['Blood_Pressure']),
                yValueMapper: (data, _) => diabetesData
                    .where((d) =>
                        categorizeBloodPressure(d['Blood_Pressure']) ==
                        categorizeBloodPressure(data['Blood_Pressure']))
                    .length
                    .toDouble(),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        // Pie Chart
        Container(
          height: 300,
          child: PieChart(
            PieChartData(
              sections: [
                PieChartSectionData(
                    color: Colors.red,
                    value: type2Count.toDouble(),
                    title: 'Type2',
                    badgeWidget: Text(type2Count.toDouble().toString()),
                    badgePositionPercentageOffset: -0.5),
                PieChartSectionData(
                  color: Colors.orange,
                  value: diabetesData.length.toDouble() - type2Count.toDouble(),
                  title: 'Type1',
                  badgeWidget: Text(
                      (diabetesData.length.toDouble() - type2Count.toDouble())
                          .toString()),
                  badgePositionPercentageOffset: -0.5,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
