import 'package:field_service_managemen_app/view/Technician_screen.dart';
import 'package:field_service_managemen_app/view/navigation.dart';
import 'package:field_service_managemen_app/view/customer_screen.dart';
import 'package:field_service_managemen_app/view/forgot_password_screen.dart';
import 'package:field_service_managemen_app/view/loginScreen.dart';
import 'package:field_service_managemen_app/view/sign_up_screen.dart';
import 'package:field_service_managemen_app/view/splashScreen.dart';
import'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      // this comment is just to see if the changes are reflecting
      //seen arlene
      home: const SplashScreen(),
        routes: {
          '/loginScreen': (context) => const LoginScreen(),
          '/signUpScreen': (context) => const SignUpScreen(),
          '/dash': (context) =>  const NavigationScreen(),  // this is to the dash with changing tabs
          '/technicianScreen': (context) =>  const TechnicianScreen(),
          '/customerScreen': (context) =>  const CustomerScreen(),
          '/forgotPasswordScreen': (context) => const ForgotPasswordScreen(),

        }

    );
  }
}
