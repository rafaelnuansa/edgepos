// ignore_for_file: use_build_context_synchronously

import 'package:edgepos/pages/main_page.dart';
import 'package:edgepos/services/login_api.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  // Text editing controllers for email and password
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // State variables
  bool isLoading = false;
  String errorMessage = '';

  // Function to handle the login
  void login() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    // Show loading indicator
    setState(() {
      isLoading = true;
      errorMessage = ''; // Reset error message
    });

    try {
      // Call the login API
      final Map<String, dynamic> response =
          await LoginApi().login(email, password);

      // Check the success status in the response
      if (response['success'] == true) {
        // If login is successful, navigate to the dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
        );
      } else {
        // If login fails, display the error message
        setState(() {
          isLoading = false;
          errorMessage = response.containsKey('message')
              ? response['message']
              : 'Login failed. Please check your credentials.';
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        errorMessage = '$error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 200,
              child: Image.asset(
                'assets/illustration.png',
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Login to Your Account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fillColor: Colors.lightBlue[50],
                filled: true,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                fillColor: Colors.lightBlue[50],
                filled: true,
              ),
            ),
            if (errorMessage.isNotEmpty) const SizedBox(height: 10),
            Text(
              errorMessage,
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                isLoading ? 'Logging in...' : 'Login',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
