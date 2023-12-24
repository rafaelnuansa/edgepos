// ignore_for_file: unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  late Map<String, dynamic> _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String userDataString = prefs.getString('user') ?? '';
      final Map<String, dynamic> userData = Map<String, dynamic>.from(json.decode(userDataString));

      setState(() {
        _userData = userData;
      });
    } catch (e) {
      // Handle exceptions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: _userData != null
          ? _buildUserProfile()
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

Widget _buildUserProfile() {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    
      const SizedBox(height: 16),
      if (_userData != null)
        Column(
          children: [
            Text('Name: ${_userData['first_name']} ${_userData['last_name']}'),
            Text('Email: ${_userData['email']}'),
            Text('User Type: ${_userData['user_type']}'),
            // Add more user details as needed
          ],
        ),
    ],
  );
}

}
