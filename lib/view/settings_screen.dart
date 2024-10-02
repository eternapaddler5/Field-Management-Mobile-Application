import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final String userRole; // Accept role as a parameter to distinguish privileges

  const SettingsScreen({Key? key, required this.userRole}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _selectedLanguage;
  bool _notificationsEnabled = true;
  List<String> _serviceCategories = ["Cleaning", "Plumbing", "Electrical"]; // Sample categories

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedLanguage = prefs.getString('language') ?? 'English'; // Default language
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
    });
  }

  Future<void> _saveLanguagePreference(String language) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('language', language);
    setState(() {
      _selectedLanguage = language;
    });
  }

  Future<void> _toggleNotifications(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('notifications', enabled);
    setState(() {
      _notificationsEnabled = enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Notification Settings - Accessible by all roles
          SwitchListTile(
            title: const Text('Notifications'),
            subtitle: const Text('Enable or disable notifications'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              _toggleNotifications(value);
            },
          ),
          const Divider(),

          // Language Preferences - Accessible by all roles
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language Preferences'),
            subtitle: Text('Current language: $_selectedLanguage'),
            onTap: () {
              _showLanguageDialog(context);
            },
          ),
          const Divider(),

          // Only show Manage Profile for Manager and Admin
          if (widget.userRole == 'Manager' || widget.userRole == 'Administrator') ...[
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Manage Profile'),
              subtitle: const Text('Edit profile and user information'),
              onTap: () {
                Navigator.pushNamed(context, '/profileScreen');
              },
            ),
            const Divider(),
          ],

          // Service Categories - Accessible by Manager and Admin
          if (widget.userRole == 'Manager' || widget.userRole == 'Administrator') ...[
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Service Categories'),
              subtitle: const Text('Manage default service categories'),
              onTap: () {
                _showCategoryDialog(context);
              },
            ),
            const Divider(),
          ],

          // Manage Roles & Permissions - Only Admin
          if (widget.userRole == 'Administrator') ...[
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Manage Roles and Permissions'),
              subtitle: const Text('Set roles and permissions for users'),
              onTap: () {
                Navigator.pushNamed(context, '/rolesScreen');
              },
            ),
            const Divider(),
          ],
        ],
      ),
    );
  }

  // Function to show the language selection dialog
  void _showLanguageDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Select Language', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            for (String language in ['English', 'Spanish', 'French'])
              ListTile(
                title: Text(language),
                onTap: () {
                  _saveLanguagePreference(language);
                  Navigator.pop(context); // Close the modal
                },
              ),
          ],
        );
      },
    );
  }

  // Function to manage categories
  void _showCategoryDialog(BuildContext context) {
    final TextEditingController categoryController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Manage Service Categories'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Add new category',
                ),
              ),
              const SizedBox(height: 10),
              for (String category in _serviceCategories)
                ListTile(
                  title: Text(category),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _serviceCategories.remove(category);
                      });
                      Navigator.pop(context); // Close the dialog
                    },
                  ),
                ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (categoryController.text.isNotEmpty) {
                  setState(() {
                    _serviceCategories.add(categoryController.text);
                  });
                }
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
