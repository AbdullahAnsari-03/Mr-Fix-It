import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/booking_screen.dart';

void main() {
  runApp(MrFixItApp());
}

class MrFixItApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mr. FixIt',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        // Other routes will be pushed with arguments, so not listed here
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/profile') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) => ProfileScreen(
              userEmail: args['email']!,
              userName: args['name']!,
            ),
          );
        }

        if (settings.name == '/book') {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (context) => BookingScreen(
              serviceName: args['serviceName']!,
              userEmail: args['email']!,
            ),
          );
        }

        return null;
      },
    );
  }
}
