import 'package:field_service_managemen_app/view/Technician_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../view/service_request_form.dart';

class NavigationTech extends StatefulWidget {
  final String userRole; // Role of the user (Manager, Technician, etc.)

  const NavigationTech({super.key, required this.userRole});

  @override
  State<NavigationTech> createState() => _NavigationTechState();
}

class _NavigationTechState extends State<NavigationTech> {
  final appScreens = [
    TechnicianDashboard(),
    ServiceRequestForm(),
    const Text("Access denied"),
    const Text("Settings"), // Placeholder for settings screen
  ];

  var currentIndex = 0;

  void selectedIndex(int index) {
    setState(() {
      currentIndex = index;
      if (index == 3) {
        // Navigate to the settings screen and pass the user role
        Navigator.pushNamed(
          context,
          '/settingsScreen',
          arguments: widget.userRole, // Pass the role dynamically
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
