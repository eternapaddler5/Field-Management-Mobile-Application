import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Column(
        children: [
          // User overview
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatusCard('Technicians', 20),
                  _buildStatusCard('Managers', 5),
                  _buildStatusCard('Admins', 2),
                ],
              ),
            ),
          ),
          // Service request overview section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Service Requests Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('service_requests').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No service requests available.'));
                }

                final requests = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    final requestId = request.id; // Keep for reference
                    final requestData = request.data() as Map<String, dynamic>;

                    return ListTile(
                      title: Text('Email: ${requestData['email']}'),
                      subtitle: Text('Status: ${requestData['status']}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Open edit dialog
                              _editRequestDialog(context, requestId, requestData['status']);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // Delete the request
                              _deleteRequest(requestId);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          // User management and system settings buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context,'/ManageUserScreen');
                },
                child: Text('Manage Users'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/serviceRequestList');
                  // Navigate to system settings
                },
                child: Text('Request Log'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Status card builder
  Widget _buildStatusCard(String title, int count) {
    return Card(
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              '$count',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(title),
          ],
        ),
      ),
    );
  }

  // Function to edit request
  void _editRequestDialog(BuildContext context, String requestId, String currentStatus) {
    final TextEditingController statusController = TextEditingController(text: currentStatus);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Request Status'),
          content: TextField(
            controller: statusController,
            decoration: InputDecoration(labelText: 'Status'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateRequestStatus(requestId, statusController.text, context); // Pass context for Snackbar
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Function to update request status in Firestore
  void _updateRequestStatus(String requestId, String newStatus, BuildContext context) {
    print('Updating request $requestId with new status: $newStatus'); // Debug print
    FirebaseFirestore.instance
        .collection('service_requests')
        .doc(requestId)
        .update({'status': newStatus})
        .then((_) {
      print('Request updated successfully');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request updated successfully!')));
    })
        .catchError((error) {
      print('Failed to update request: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update request: $error')));
    });
  }

  // Function to delete request
  void _deleteRequest(String requestId) {
    FirebaseFirestore.instance.collection('service_requests').doc(requestId).delete().then((_) {
      print('Request deleted successfully');
    }).catchError((error) {
      print('Failed to delete request: $error');
    });
  }
}
