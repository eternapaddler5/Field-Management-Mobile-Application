import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class FormProvider with ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _serviceRequests = [];

  List<Map<String, dynamic>> get serviceRequests => _serviceRequests;

  Future<void> submitForm(Map<String, dynamic> formData, File? image) async {
    try {
      formData['status'] = 'Pending'; // Set initial status to Pending
      formData['image'] = image;

      // Save to Firestore
      await _firestore.collection('service_requests').add({
        'name': formData['name'],
        'email': formData['email'],
        'phone': formData['phone'],
        'serviceType': formData['serviceType'],
        'description': formData['description'],
        'date': formData['date'],
        'time': formData['time'],
        'latitude': formData['latitude'],
        'longitude': formData['longitude'],
        'status': formData['status'],
        // Add other fields as necessary
      });

      _serviceRequests.add(formData);
      notifyListeners();
    } catch (e) {
      print("Error submitting form: $e");
    }
  }

  void updateStatus(int index, String status) {
    _serviceRequests[index]['status'] = status;
    notifyListeners();
  }

  void updateForm(int index, Map<String, dynamic> updatedData, File? image) {
    updatedData['image'] = image;
    _serviceRequests[index] = updatedData;
    notifyListeners();
  }
}
