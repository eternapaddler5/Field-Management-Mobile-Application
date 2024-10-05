import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class AnalyticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Pie Chart for Service Types
              Text(
                'Popular Service Types',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 200, // Adjust height as needed
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        color: Colors.blue,
                        value: 40, // 40% of service type 1
                        title: 'Type 1\n40%',
                        radius: 60,
                        titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      PieChartSectionData(
                        color: Colors.green,
                        value: 30, // 30% of service type 2
                        title: 'Type 2\n30%',
                        radius: 60,
                        titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      PieChartSectionData(
                        color: Colors.orange,
                        value: 20, // 20% of service type 3
                        title: 'Type 3\n20%',
                        radius: 60,
                        titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      PieChartSectionData(
                        color: Colors.red,
                        value: 10, // 10% of service type 4
                        title: 'Type 4\n10%',
                        radius: 60,
                        titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Line Chart for Requests Over Time
              Text(
                'Requests Completed Over Time',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 300, // Adjust the height as needed
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 5,
                          getTitlesWidget: (value, meta) {
                            return Text(value.toInt().toString());
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            // Assuming each index represents a date or time
                            switch (value.toInt()) {
                              case 1:
                                return Text('Jan');
                              case 2:
                                return Text('Feb');
                              case 3:
                                return Text('Mar');
                              case 4:
                                return Text('Apr');
                              default:
                                return Text('');
                            }
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: true),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(1, 10), // e.g., 10 requests in Jan
                          FlSpot(2, 15), // 15 requests in Feb
                          FlSpot(3, 7),  // 7 requests in Mar
                          FlSpot(4, 20), // 20 requests in Apr
                        ],
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 4,
                        belowBarData: BarAreaData(show: true, color: Colors.blue.withOpacity(0.3)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
