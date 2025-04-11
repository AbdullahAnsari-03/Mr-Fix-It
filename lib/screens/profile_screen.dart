import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database_helper.dart';
import 'login_screen.dart'; // import login screen to navigate back

class ProfileScreen extends StatefulWidget {
  final String userEmail;
  final String userName;

  ProfileScreen({required this.userEmail, required this.userName});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Map<String, dynamic>> activeBookings = [];
  List<Map<String, dynamic>> previousBookings = [];

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    DatabaseHelper dbHelper = DatabaseHelper();

    // Update expired bookings
    await dbHelper.updateBookingStatus();

    List<Map<String, dynamic>> active = await dbHelper.getActiveBookings(widget.userEmail);
    List<Map<String, dynamic>> previous = await dbHelper.getPreviousBookings(widget.userEmail);

    print("✅ Active Bookings: $active");
    print("🔄 Previous Bookings: $previous");

    setState(() {
      activeBookings = active;
      previousBookings = previous;
    });
  }

  String formatBookingDate(String dateString) {
    try {
      DateTime parsedDate = DateTime.parse(dateString);
      return DateFormat("yyyy-MM-dd 'at' hh:mm a").format(parsedDate);
    } catch (e) {
      print("❌ Error parsing date: $e");
      return "Invalid date";
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Logout"),
        content: Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // dismiss dialog
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false,
              );
            },
            child: Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(Icons.power_settings_new),
            tooltip: "Logout",
            onPressed: _confirmLogout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text("User Info", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ListTile(
              leading: Icon(Icons.person, color: Colors.blueAccent),
              title: Text(widget.userName),
              subtitle: Text(widget.userEmail),
            ),
            SizedBox(height: 20),

            // Active Bookings
            Text("Active Bookings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            activeBookings.isEmpty
                ? Text("No active bookings", style: TextStyle(color: Colors.grey))
                : Column(
              children: activeBookings.map((booking) {
                return ListTile(
                  leading: Icon(Icons.calendar_today, color: Colors.green),
                  title: Text("${booking["serviceName"]}"),
                  subtitle: Text("Date: ${formatBookingDate(booking["date"]!)}"),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // Previous Bookings
            Text("Previous Bookings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            previousBookings.isEmpty
                ? Text("No previous bookings", style: TextStyle(color: Colors.grey))
                : Column(
              children: previousBookings.map((booking) {
                return ListTile(
                  leading: Icon(Icons.history, color: Colors.blueAccent),
                  title: Text("${booking["serviceName"]}"),
                  subtitle: Text("Date: ${formatBookingDate(booking["date"]!)}"),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
