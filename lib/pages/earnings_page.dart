import 'package:flutter/material.dart';

class EarningsPage extends StatefulWidget {
  const EarningsPage({super.key});

  @override
  State<EarningsPage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<EarningsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Optional: added background for contrast
      body: Center(
        child: Text(
          "Earnings",
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
