import 'package:flutter/material.dart';
import 'booking_screen.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final String serviceName;
  final String userEmail;
  final IconData serviceIcon; // ✅ Added serviceIcon

  ServiceDetailsScreen({
    required this.serviceName,
    required this.userEmail,
    required this.serviceIcon, // ✅ Accept icon
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(serviceName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(serviceIcon, size: 100, color: Colors.blueAccent), // ✅ Show icon
            SizedBox(height: 20),
            Text(
              serviceName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Get professional assistance for your $serviceName needs.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingScreen(
                      serviceName: serviceName,
                      userEmail: userEmail,
                    ),
                  ),
                );
              },
              child: Text("Book Service"),
            ),
          ],
        ),
      ),
    );
  }
}
