import 'package:edgepos/pages/custom_loading_screen.dart';
import 'package:edgepos/pages/login_page.dart';
import 'package:edgepos/pages/error_page.dart'; // Import the ErrorPage
import 'package:edgepos/pages/main_page.dart';
import 'package:edgepos/services/login_api.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Initialization method to check the token
  Future<Widget> _getHomePage() async {
    try {
      final bool hasToken = await LoginApi.hasToken();
      if (hasToken) {
        return const MainPage();
      } else {
        return const LoginPage();
      }
    } catch (error) {
      // Handle the error, e.g., if error is 401 (Unauthorized), redirect to login
      if (error is http.ClientException && error.message.contains('401')) {
        return const LoginPage();
      } else {
        // Handle other errors by returning the ErrorPage
        return const ErrorPage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _getHomePage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Return the home page based on the token check
          return MaterialApp(
            title: 'EdgePOS',
            theme: ThemeData(
              useMaterial3: true,
              textTheme: GoogleFonts.poppinsTextTheme(),
            ),
            home: snapshot.data ?? const LoginPage(),
          );
        } else {
          // Return a loading indicator or splash screen while checking for the token
          return MaterialApp(
            title: 'EdgePOS',
            theme: ThemeData(
              useMaterial3: true,
              textTheme: GoogleFonts.poppinsTextTheme(),
            ),
            home: const CustomLoadingScreen(),
          );
        }
      },
    );
  }
}
