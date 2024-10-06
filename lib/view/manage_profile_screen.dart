import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class ManageProfileScreen extends StatefulWidget {
  const ManageProfileScreen({Key? key}) : super(key: key);

  @override
  _ManageProfileScreenState createState() => _ManageProfileScreenState();
}

class _ManageProfileScreenState extends State<ManageProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  User? _currentUser;
  String? _profilePictureUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
  }

  Future<void> _getCurrentUser() async {
    setState(() {
      _isLoading = true;
    });
    _currentUser = _auth.currentUser;
    if (_currentUser != null) {
      // Fetch profile picture URL from Firestore with field existence check
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(_currentUser!.uid).get();

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;

        // Use explicit null check to handle nullable values
        if (userData != null && userData.containsKey('profilePicture')) {
          setState(() {
            _profilePictureUrl = userData['profilePicture'];
          });
        } else {
          setState(() {
            _profilePictureUrl = null; // Field doesn't exist, so set to null
          });
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _changePassword(String newPassword) async {
    if (_currentUser != null) {
      try {
        await _currentUser!.updatePassword(newPassword);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _uploadProfilePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String fileName = '${_currentUser!.uid}.jpg';

      try {
        // Upload image to Firebase Storage
        Reference storageRef =
        FirebaseStorage.instance.ref().child('profile_pictures/$fileName');
        await storageRef.putFile(imageFile);

        // Get the download URL and save it in Firestore
        String downloadUrl = await storageRef.getDownloadURL();

        // Update Firestore, adding the 'profilePicture' field if it doesn't exist
        await _firestore.collection('users').doc(_currentUser!.uid).set(
          {'profilePicture': downloadUrl},
          SetOptions(merge: true), // Merge to avoid overwriting existing fields
        );

        setState(() {
          _profilePictureUrl = downloadUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _profilePictureUrl != null
                ? CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(_profilePictureUrl!),
            )
                : const CircleAvatar(
              radius: 60,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _uploadProfilePicture,
              child: const Text('Upload Profile Picture'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                border: OutlineInputBorder(),
              ),
              onFieldSubmitted: _changePassword,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                String newPassword = "yourNewPassword"; // Replace with input
                _changePassword(newPassword);
              },
              child: const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
