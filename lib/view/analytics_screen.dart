import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AnalyticsScreen extends StatefulWidget {
  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  Map<String, double> serviceTypeData = {};
  Map<int, int> requestsOverTime = {};

  @override
  void initState() {
    super.initState();
    fetchAnalyticsData();
  }

  Future<void> fetchAnalyticsData() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('service_requests').get();

    Map<String, int> tempServiceTypeData = {};
    Map<int, int> tempRequestsOverTime = {};

    snapshot.docs.forEach((doc) {
      final data = doc.data() as Map<String, dynamic>;

      // Count service types
      String serviceType = data['serviceType'] ?? 'Unknown';
      if (tempServiceTypeData.containsKey(serviceType)) {
        tempServiceTypeData[serviceType] = tempServiceTypeData[serviceType]! + 1;
      } else {
        tempServiceTypeData[serviceType] = 1;
      }

      // Count requests over time (assuming there's a 'createdAt' timestamp field)
      if (data['createdAt'] != null) {
        Timestamp timestamp = data['createdAt'] as Timestamp;
        DateTime createdAt = timestamp.toDate();

        int month = createdAt.month; // You can group by month or year
        print('Request completed in month: $month'); // Logging the month for debugging

        if (tempRequestsOverTime.containsKey(month)) {
          tempRequestsOverTime[month] = tempRequestsOverTime[month]! + 1;
        } else {
          tempRequestsOverTime[month] = 1;
        }
      } else {
        print('Missing createdAt field for document: ${doc.id}'); // Log if missing
      }
    });

    // Convert to percentages for the pie chart
    int totalRequests = tempServiceTypeData.values.reduce((a, b) => a + b);
    serviceTypeData = tempServiceTypeData.map((key, value) => MapEntry(key, (value / totalRequests) * 100));

    // Log the requests over time to ensure it's correctly populated
    print('Requests Over Time: $tempRequestsOverTime');

    setState(() {
      requestsOverTime = tempRequestsOverTime;
    });
  }

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
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Popular Service Types',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 440, // Adjust height as needed
                child: PieChart(
                  PieChartData(
                    sections: serviceTypeData.entries.map((entry) {
                      return PieChartSectionData(
                        color: _getColorForServiceType(entry.key),
                        value: entry.value,
                        title: '${entry.key}\n${entry.value.toStringAsFixed(1)}%',
                        radius: 60,
                        titleStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Line Chart for Requests Over Time
            ],
          ),
        ),
      ),
    );
  }

  Color _getColorForServiceType(String serviceType) {
    switch (serviceType) {
      case 'repair':
        return Colors.blue;
      case 'maintenance':
        return Colors.green;
    // Add more service types and colors as needed
      default:
        return Colors.grey;
    }
  }
}
