import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceRequest {
  final String id;
  final String clientName;
  final String description;
  final DateTime dateTime;
  final String location;
  final String status;
  final String technicianId; // Used to filter for technicians

  ServiceRequest({
    required this.id,
    required this.clientName,
    required this.description,
    required this.dateTime,
    required this.location,
    required this.status,
    required this.technicianId,
  });

  factory ServiceRequest.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return ServiceRequest(
      id: doc.id,
      clientName: data['clientName'],
      description: data['description'],
      dateTime: data['dateTime'].toDate(),
      location: data['location'],
      status: data['status'],
      technicianId: data['technicianId'],
    );
  }
}
