import 'package:field_service_managemen_app/view/analytics_screen.dart';
import 'package:field_service_managemen_app/view/manager_screen.dart';
import 'package:field_service_managemen_app/view/service_request_form.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NavigationManager extends StatefulWidget {
  const NavigationManager({super.key});

  @override
  State<NavigationManager> createState() => _NavigationManagerState();
}

class _NavigationManagerState extends State<NavigationManager> {
  final appScreens = [
    ManagerScreen(),
    ServiceRequestForm(),
    AnalyticsScreen(),
    const Text("Settings"), // Placeholder for settings screen
  ];

  var currentIndex = 0;

  void selectedIndex(int index) {
    setState(() {
      currentIndex = index;
      if (index == 3) {
        // Navigate to the settings screen
        Navigator.pushNamed(
          context,
          '/settingsScreen',
          arguments: 'Manager', // Pass Manager role
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: appScreens[currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: selectedIndex,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: const Color(0xFF526400),
        showSelectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Iconsax.home_15),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.receipt_edit),
            label: 'Service Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.trend_up),
            label: 'Analytics',
          ),
          BottomNavigationBarItem(
            icon: Icon(Iconsax.setting_24),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
