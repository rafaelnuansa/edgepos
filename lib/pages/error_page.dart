import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error,
              size: 64,
              color: Colors.red,
            ),
            SizedBox(height: 16),
            Text(
              'An error occurred.',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            // ElevatedButton(
            //   // onPressed: () {
            //   //   // You can add logic to retry or navigate to a different page
            //   // },
            //   // child: Text('Retry'),
            // ),
          ],
        ),
      ),
    );
  }
}
