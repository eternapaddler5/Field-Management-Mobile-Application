import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageUsersScreen extends StatefulWidget {
  @override
  _ManageUsersScreenState createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _users = [];
  final List<String> _roles = ['Technician', 'Manager', 'Administrator'];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    QuerySnapshot querySnapshot = await _firestore.collection('users').get();
    setState(() {
      _users = querySnapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'email': doc['email'],
          'role': doc['role'],
        };
      }).toList();
    });
  }

  void _updateUserRole(String userId, String newRole) async {
    await _firestore.collection('users').doc(userId).update({'role': newRole});
    _fetchUsers(); // Refresh the user list after updating
  }

  void _deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
    _fetchUsers(); // Refresh the user list after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users'),
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          String currentRole = _users[index]['role'];

          // Ensure the role is a valid option in the dropdown, otherwise set a default.
          if (!_roles.contains(currentRole)) {
            currentRole = _roles.first;
          }

          return ListTile(
            title: Text(_users[index]['email']),
            subtitle: Text('Role: $currentRole'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<String>(
                  value: currentRole,
                  items: _roles.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      _updateUserRole(_users[index]['id'], newValue);
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _deleteUser(_users[index]['id']);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
