// form_provider.dart

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

class FormProvider extends ChangeNotifier {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void submitForm(Map<String, dynamic> formData, File? image) async {
    // Logic to handle form submission, including Firebase Firestore operations
    try {
      await FirebaseFirestore.instance.collection('service_requests').add(formData);
      if (image != null) {
        // Handle image upload here if needed
      }
      notifyListeners();
    } catch (e) {
      print('Error submitting form: $e');
    }
  }
}
