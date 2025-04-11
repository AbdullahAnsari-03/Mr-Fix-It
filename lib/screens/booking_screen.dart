import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../database_helper.dart'; // Import database helper
import 'profile_screen.dart'; // Ensure profile screen exists

class BookingScreen extends StatefulWidget {
  final String serviceName;
  final String userEmail; // Pass user email

  BookingScreen({required this.serviceName, required this.userEmail});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> _confirmBooking() async {
    if (selectedDate != null && selectedTime != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate!);
      String formattedTime = DateFormat('hh:mm a').format(
        DateTime(0, 0, 0, selectedTime!.hour, selectedTime!.minute),
      );

      DatabaseHelper dbHelper = DatabaseHelper();
      await dbHelper.insertBooking(
        widget.userEmail, // Store for logged-in user
        widget.serviceName,
        formattedDate,
        formattedTime,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Booking Confirmed!")),
      );

      // Navigate back and refresh Profile Screen
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isBookingEnabled = selectedDate != null && selectedTime != null;

    return Scaffold(
      appBar: AppBar(title: Text("Book Service")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Select Date:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text(selectedDate == null ? "Choose Date" : DateFormat('yyyy-MM-dd').format(selectedDate!)),
              ),
              SizedBox(height: 10),
              Text("Select Time:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: () => _selectTime(context),
                child: Text(selectedTime == null ? "Choose Time" : selectedTime!.format(context)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isBookingEnabled ? _confirmBooking : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isBookingEnabled ? Colors.blue : Colors.grey,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text("Confirm Booking", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
