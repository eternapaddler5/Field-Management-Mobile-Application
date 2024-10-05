import 'package:field_service_managemen_app/view/admin_screen.dart';
import 'package:field_service_managemen_app/view/analytics_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../view/service_request_form.dart';
import '../view/settings_screen.dart';

class NavigationAdmin extends StatefulWidget {
  const NavigationAdmin({super.key});

  @override
  State<NavigationAdmin> createState() => _NavigationAdminState();
}

class _NavigationAdminState extends State<NavigationAdmin> {
  bool _isDarkMode = false; // Dark mode state
  String _selectedLanguage = 'English'; // Default language

  var currentIndex = 0;

  void selectedIndex(var index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final appScreens = [
      const AdminScreen(),
      ServiceRequestForm(),
      AnalyticsScreen(),
      SettingsScreen(
        userRole: ModalRoute.of(context)?.settings.arguments as String? ?? 'Administrator',
        isDarkMode: _isDarkMode,
        selectedLanguage: _selectedLanguage,
        onThemeChanged: (value) {
          setState(() {
            _isDarkMode = value;
          });
        },
        onLanguageChanged: (value) {
          setState(() {
            _selectedLanguage = value;
          });
        },
      ),
    ];

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
              icon: Icon(Iconsax.home_15), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Iconsax.receipt_edit), label: 'Service Requests'),
          BottomNavigationBarItem(
              icon: Icon(Iconsax.trend_up), label: 'Analytics'),
          BottomNavigationBarItem(
              icon: Icon(Iconsax.setting_24), label: 'Settings'),
        ],
      ),
    );
  }
}
