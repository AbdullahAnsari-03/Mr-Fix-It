import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fixitnow/main.dart'; // ✅ Correct import based on your app folder

void main() {
  testWidgets('App starts and shows login screen', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(MrFixItApp());

    // Expect to find the "Login" button on the screen
    expect(find.text('Login'), findsOneWidget);
  });
}
