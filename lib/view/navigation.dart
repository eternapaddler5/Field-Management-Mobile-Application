import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
    Get.put(NavigationController()); // for the changing index

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("DEFY Services"),
      ),

      bottomNavigationBar: Obx(
            () => NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            // user-selected index to highlight the tab
            onDestinationSelected: (index) =>
            controller.selectedIndex.value = index,
            destinations: const [
              NavigationDestination(
                // index = 0
                  icon: Icon(Iconsax.home_15),
                  label: 'Dashboard'),
              NavigationDestination(
                // index = 1
                  icon: Icon(Iconsax.receipt_edit),
                  label: 'Service Requests'),
              NavigationDestination(
                // index = 2
                  icon: Icon(Iconsax.trend_up),
                  label: 'Analytics'),
              NavigationDestination(
                // index = 3
                  icon: Icon(Iconsax.setting_24),
                  label: 'Settings')
            ]),
      ),
      // show the corresponding screen with the selection
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

// to highlight and display the selected screen
class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [

    // change Containers to screen by replacing with const ScreenName
    Container(
      color: Colors.orange,
    ), // Technician Dashboard, index = 0
    Container(
      color: Colors.red,
    ), // Service Requests screen, index = 1
    Container(
      color: Colors.green,
    ), // Analytics screen, index = 2
    Container(
      color: Colors.purple,
    ), // Settings screen, index = 3
  ];
}

