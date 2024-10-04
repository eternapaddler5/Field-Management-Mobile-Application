import 'package:field_service_managemen_app/view/form_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:field_service_managemen_app/controller/navigation_manger.dart';
import 'package:field_service_managemen_app/controller/navigation_tech.dart';
import 'package:field_service_managemen_app/model/firebase_options.dart';
import 'package:field_service_managemen_app/view/Technician_screen.dart';
import 'package:field_service_managemen_app/view/admin_screen.dart';
import 'package:field_service_managemen_app/view/manager_screen.dart';
import 'package:field_service_managemen_app/view/forgot_password_screen.dart';
import 'package:field_service_managemen_app/view/loginScreen.dart';
import 'package:field_service_managemen_app/controller/navigation_Admin.dart';
import 'package:field_service_managemen_app/view/service_request_form.dart';
import 'package:field_service_managemen_app/view/settings_screen.dart';
import 'package:field_service_managemen_app/view/sign_up_screen.dart';
import 'package:field_service_managemen_app/view/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false; // Dark mode state
  String _selectedLanguage = 'English'; // Default language

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FormProvider()), // Provide FormProvider here
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Field Service Management App',
        theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
        home: const SplashScreen(),
        routes: {
          '/serviceRequestForm': (context) => ServiceRequestForm(),
          '/loginScreen': (context) => const LoginScreen(),
          '/signUpScreen': (context) => const SignUpScreen(),
          '/adminScreen': (context) => const AdminScreen(),
          '/technicianScreen': (context) => const TechnicianScreen(),
          '/managerScreen': (context) => const ManagerScreen(),
          '/forgotPasswordScreen': (context) => const ForgotPasswordScreen(),
          '/navigationAdmin': (context) => const NavigationAdmin(),
          '/navigationManager': (context) => const NavigationManager(),
          '/navigationTech': (context) => const NavigationTech(userRole: '',),
          '/settingsScreen': (context) => SettingsScreen(
            userRole: ModalRoute.of(context)?.settings.arguments as String,
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
        },
      ),
    );
  }
}
