import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qoqontoshkent/screens/civil_page.dart';
import 'package:qoqontoshkent/screens/drivers_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return CivilPage();
    } else {
      return DriverPage();
    }
  }
}
