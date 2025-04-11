import 'package:flutter/material.dart';
import 'service_details_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatelessWidget {
  final String userEmail;
  final String userName;

  HomeScreen({required this.userEmail, required this.userName});

  final List<Map<String, dynamic>> services = [
    {"name": "Plumbing", "description": "Fix leaks and pipes", "icon": Icons.plumbing},
    {"name": "Electrician", "description": "Wiring & electrical fixes", "icon": Icons.electrical_services},
    {"name": "Carpentry", "description": "Furniture repairs", "icon": Icons.carpenter},
    {"name": "Painting", "description": "Home & office painting", "icon": Icons.format_paint},
    {"name": "Cleaning", "description": "House & office cleaning", "icon": Icons.cleaning_services},
    {"name": "Appliance Repair", "description": "Fix home appliances", "icon": Icons.build_circle},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mr. FixIt",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(userEmail: userEmail, userName: userName),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Available Services",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1,
                ),
                itemCount: services.length,
                itemBuilder: (context, index) {
                  final service = services[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ServiceDetailsScreen(
                            serviceName: service["name"],
                            userEmail: userEmail,
                            serviceIcon: service["icon"], // ✅ Pass icon correctly
                          ),
                        ),
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(service["icon"], size: 50, color: Colors.blueAccent), // ✅ Icon now correctly set
                            SizedBox(height: 10),
                            Text(
                              service["name"],
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                              service["description"],
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
