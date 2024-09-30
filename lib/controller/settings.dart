import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  String _selectedLanguage = 'English'; // Default language

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Settings Screen',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: SettingsScreen(
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
    );
  }
}

class SettingsScreen extends StatefulWidget {
  final bool isDarkMode;
  final String selectedLanguage;
  final ValueChanged<bool> onThemeChanged;
  final ValueChanged<String> onLanguageChanged;

  SettingsScreen({
    required this.isDarkMode,
    required this.selectedLanguage,
    required this.onThemeChanged,
    required this.onLanguageChanged,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool emailNotifications = false;
  bool pushNotifications = false;
  bool smsNotifications = false;

  // List to hold the checked state of each service
  List<bool> _selectedServices = [false, false, false];
  final List<String> _serviceNames = ['IT support', 'Electricity', 'Plumbing'];
  final List<String> _profiles = ['User 1', 'User 2'];

  // Translated strings
  Map<String, Map<String, String>> _localizedStrings = {
    'English': {
      'settings': 'Settings',
      'default_service_categories': 'Default Service Categories',
      'notification_settings': 'Notification Settings',
      'language_preferences': 'Language Preferences',
      'dark_mode': 'Dark Mode',
      'enable_dark_mode': 'Enable Dark Mode',
      'manage_profiles': 'Manage Profiles',
      'edit_profile': 'Edit Profile',
    },
    'Spanish': {
      'settings': 'Configuraciones',
      'default_service_categories': 'Categorías de Servicio Predeterminadas',
      'notification_settings': 'Configuraciones de Notificación',
      'language_preferences': 'Preferencias de Idioma',
      'dark_mode': 'Modo Oscuro',
      'enable_dark_mode': 'Activar Modo Oscuro',
      'manage_profiles': 'Gestionar Perfiles',
      'edit_profile': 'Editar Perfil',
    },
    'French': {
      'settings': 'Paramètres',
      'default_service_categories': 'Catégories de Service Par Défaut',
      'notification_settings': 'Paramètres de Notification',
      'language_preferences': 'Préférences de Langue',
      'dark_mode': 'Mode Sombre',
      'enable_dark_mode': 'Activer le Mode Sombre',
      'manage_profiles': 'Gérer les Profils',
      'edit_profile': 'Modifier le Profil',
    },
    'Arabic': {
      'settings': 'الإعدادات',
      'default_service_categories': 'فئات الخدمة الافتراضية',
      'notification_settings': 'إعدادات الإشعارات',
      'language_preferences': 'تفضيلات اللغة',
      'dark_mode': 'الوضع المظلم',
      'enable_dark_mode': 'تفعيل الوضع المظلم',
      'manage_profiles': 'إدارة الملفات الشخصية',
      'edit_profile': 'تعديل الملف الشخصي',
    },
    // Add more languages here...
    'German': {
      'settings': 'Einstellungen',
      'default_service_categories': 'Standarddienstkategorien',
      'notification_settings': 'Benachrichtigungseinstellungen',
      'language_preferences': 'Spracheinstellungen',
      'dark_mode': 'Dunkler Modus',
      'enable_dark_mode': 'Dunklen Modus aktivieren',
      'manage_profiles': 'Profile verwalten',
      'edit_profile': 'Profil bearbeiten',
    },
    'Chinese': {
      'settings': '设置',
      'default_service_categories': '默认服务类别',
      'notification_settings': '通知设置',
      'language_preferences': '语言偏好',
      'dark_mode': '深色模式',
      'enable_dark_mode': '启用深色模式',
      'manage_profiles': '管理个人资料',
      'edit_profile': '编辑个人资料',
    },
    // ...add 23 more languages...
  };

  String get _currentLanguage => widget.selectedLanguage;

  void _onServiceChanged(int index, bool? value) {
    setState(() {
      _selectedServices[index] = value ?? false;
    });
  }

  void _editProfile(String profile) {
    TextEditingController controller = TextEditingController(text: profile);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(_localizedStrings[_currentLanguage]!['edit_profile']!),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Profile Name"),
          ),
          actions: [
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  int index = _profiles.indexOf(profile);
                  if (index != -1) {
                    _profiles[index] = controller.text;
                  }
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_localizedStrings[_currentLanguage]!['settings']!),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(_localizedStrings[_currentLanguage]!['default_service_categories']!),
            subtitle: Column(
              children: [
                for (int i = 0; i < _serviceNames.length; i++)
                  CheckboxListTile(
                    title: Text(_serviceNames[i]),
                    value: _selectedServices[i],
                    onChanged: (bool? value) => _onServiceChanged(i, value),
                  ),
              ],
            ),
          ),
          ListTile(
            title: Text(_localizedStrings[_currentLanguage]!['notification_settings']!),
            subtitle: Column(
              children: [
                SwitchListTile(
                  title: Text('Email Notifications'),
                  value: emailNotifications,
                  onChanged: (bool value) {
                    setState(() {
                      emailNotifications = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('Push Notifications'),
                  value: pushNotifications,
                  onChanged: (bool value) {
                    setState(() {
                      pushNotifications = value;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('SMS Notifications'),
                  value: smsNotifications,
                  onChanged: (bool value) {
                    setState(() {
                      smsNotifications = value;
                    });
                  },
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(_localizedStrings[_currentLanguage]!['language_preferences']!),
            subtitle: DropdownButton<String>(
              value: _currentLanguage,
              onChanged: (String? newValue) {
                widget.onLanguageChanged(newValue!);
              },
              items: _localizedStrings.keys
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: Text(_localizedStrings[_currentLanguage]!['dark_mode']!),
            subtitle: SwitchListTile(
              title: Text(_localizedStrings[_currentLanguage]!['enable_dark_mode']!),
              value: widget.isDarkMode,
              onChanged: widget.onThemeChanged,
            ),
          ),
          ListTile(
            title: Text(_localizedStrings[_currentLanguage]!['manage_profiles']!),
            subtitle: Column(
              children: [
                for (String profile in _profiles)
                  ListTile(
                    title: Text(profile),
                    trailing: Icon(Icons.edit),
                    onTap: () => _editProfile(profile),
                  ),
              ],
            ),
          ),
          ListTile(
            title: Text('Roles and Permissions'),
            subtitle: Column(
              children: [
                ListTile(
                  title: Text('Admin'),
                  trailing: Icon(Icons.edit),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
