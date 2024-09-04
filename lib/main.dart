import 'package:field_service_managemen_app/view/loginScreen.dart';
import'package:flutter/material.dart';

void main (){
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // this comment is just to see if the changes are reflecting
      //seen arlene
      home: LoginScreen(),
    );
  }
}
