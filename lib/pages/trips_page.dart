import 'package:flutter/material.dart';

class TripsPage extends StatefulWidget {
  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<TripsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Optional: added background for contrast
      body: Center(
        child: Text(
          "Trips",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ); // ✅ fixed the closing bracket and removed the semicolon from the wrong place
  }
}
