import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qoqontoshkent/screens/account_screen.dart';
import 'package:qoqontoshkent/screens/civil_page.dart';
import 'package:qoqontoshkent/screens/drivers_page.dart';
import 'package:qoqontoshkent/screens/login_screen.dart';
import 'package:qoqontoshkent/screens/statistics_page.dart';
import 'package:qoqontoshkent/style/app_colors.dart';
import 'package:qoqontoshkent/style/app_style.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: TextButton(
            onPressed: () {
              if (user == null) {
                null;
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const StatisticsPage()),
                );
              }
            },
            child: Icon(
              Icons.bar_chart,
              color: Colors.white,
            )),
        backgroundColor: AppColors.taxi,
        title: Text(
          'Asosiy sahifa',
          style: AppStyle.fontStyle.copyWith(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              if ((user == null)) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AccountScreen()),
                );
              }
            },
            icon: Icon(
              Icons.person,
              color: (user == null) ? Colors.white : Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(child: (user == null) ? const CivilPage() : DriverPage()),
      ),
    );
  }
}
