import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  final String userRole; // Accept role as a parameter to distinguish privileges
  final bool isDarkMode; // Dark mode status
  final String selectedLanguage; // Selected language
  final ValueChanged<bool> onThemeChanged; // Callback for theme change
  final ValueChanged<String> onLanguageChanged; // Callback for language change

  const SettingsScreen({
    Key? key,
    required this.userRole,
    required this.isDarkMode,
    required this.selectedLanguage,
    required this.onThemeChanged,
    required this.onLanguageChanged,
  }) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  late bool _isDarkMode;
  List<String> _serviceCategories = [
    "Cleaning",
    "Plumbing",
    "Electrical"
  ]; // Sample categories

  // Translated strings
  final Map<String, Map<String, String>> _localizedStrings = {
    'English': {
      'settings': 'Settings',
      'default_service_categories': 'Default Service Categories',
      'notification_settings': 'Notification Settings',
      'language_preferences': 'Language Preferences',
      'dark_mode': 'Dark Mode',
      'enable_dark_mode': 'Enable Dark Mode',
      'manage_profiles': 'Manage Profiles',
      'logout': 'Logout',
    },
    'Spanish': {
      'settings': 'Configuraciones',
      'default_service_categories': 'Categorías de Servicio Predeterminadas',
      'notification_settings': 'Configuraciones de Notificación',
      'language_preferences': 'Preferencias de Idioma',
      'dark_mode': 'Modo Oscuro',
      'enable_dark_mode': 'Activar Modo Oscuro',
      'manage_profiles': 'Gestionar Perfiles',
      'logout': 'Cerrar Sesión',
    },
    'French': {
      'settings': 'Paramètres',
      'default_service_categories': 'Catégories de Service Par Défaut',
      'notification_settings': 'Paramètres de Notification',
      'language_preferences': 'Préférences de Langue',
      'dark_mode': 'Mode Sombre',
      'enable_dark_mode': 'Activer le Mode Sombre',
      'manage_profiles': 'Gérer les Profils',
      'logout': 'Se Déconnecter',
    },
    // Add more languages here...
  };

  String get _currentLanguage => widget.selectedLanguage;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode; // Initialize with passed value
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
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
        title: Text(_localizedStrings[_currentLanguage]!['settings']!),
      ),
      body: ListView(
        children: [
          // Notification Settings
          SwitchListTile(
            title: Text(
                _localizedStrings[_currentLanguage]!['notification_settings']!),
            subtitle: const Text('Enable or disable notifications'),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              _toggleNotifications(value);
            },
          ),
          const Divider(),

          // Language Preferences
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language Preferences'),
            subtitle: Text('Current language: ${widget.selectedLanguage}'),
            onTap: () {
              _showLanguageDialog(context);
            },
          ),
          const Divider(),

          // Dark Mode
          SwitchListTile(
            title:
                Text(_localizedStrings[_currentLanguage]!['enable_dark_mode']!),
            value: _isDarkMode,
            onChanged: (bool value) {
              setState(() {
                _isDarkMode = value;
              });
              widget.onThemeChanged(value); // Notify parent widget
            },
          ),
          const Divider(),

          // Profile Management and Service Categories for Manager/Admin
          if (widget.userRole == 'Manager' ||
              widget.userRole == 'Administrator') ...[
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(
                  _localizedStrings[_currentLanguage]!['manage_profiles']!),
              onTap: () {
                // Profile management code here
              },
            ),
            const Divider(),
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

          // Admin-only settings
          if (widget.userRole == 'Administrator') ...[
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Manage Roles and Permissions'),
              subtitle: const Text('Set roles and permissions for users'),
              onTap: () {
                // Role management code here
              },
            ),
            const Divider(),
          ],

          // Logout Option
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(_localizedStrings[_currentLanguage]!['logout']!),
            onTap: () {
              _logout();
            },
          ),
        ],
      ),
    );
  }

  // Function to handle logout
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear user data
    // Navigate to login screen or other logic
    Navigator.of(context).pushReplacementNamed('/loginScreen');
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
                  widget.onLanguageChanged(language);
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
