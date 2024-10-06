import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TechnicianDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Technician Dashboard'),
      ),
      body: Column(
        children: [
          // Assigned service requests overview section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Assigned Service Requests',
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
                  return Center(child: Text('No service requests assigned.'));
                }

                final requests = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    final requestId = request.id;
                    final requestData = request.data() as Map<String, dynamic>;

                    final email = requestData['email'] as String? ?? 'No email';
                    final status = requestData['status'] as String? ?? 'Unknown';

                    return ListTile(
                      title: Text('Email: $email'),
                      subtitle: Text('Status: $status'),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editRequestDialog(context, requestId, status);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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
                _updateRequestStatus(requestId, statusController.text, context);
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
    FirebaseFirestore.instance
        .collection('service_requests')
        .doc(requestId)
        .update({'status': newStatus})
        .then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request updated successfully!')));
    })
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update request: $error')));
    });
  }
}
