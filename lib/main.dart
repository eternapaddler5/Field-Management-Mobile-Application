import 'package:field_service_managemen_app/view/homeScreen.dart';
import 'package:field_service_managemen_app/view/loginScreen.dart';
import 'package:field_service_managemen_app/view/signUpScreen.dart';
import 'package:field_service_managemen_app/view/splashScreen.dart';
import'package:flutter/material.dart';

void main (){
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
        '/homeScreen': (context) =>  const HomeScreen(),
        '/signUpScreen': (context) => const SignUpScreen(),
        '/loginScreen': (context) => const LoginScreen(),
      },
    );
  }
}
