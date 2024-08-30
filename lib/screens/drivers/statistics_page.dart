import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qoqontoshkent/screens/drivers/account_screen.dart';
import 'package:qoqontoshkent/style/app_colors.dart';
import 'package:qoqontoshkent/style/app_style.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountScreen()),
              );
            },
            icon: Icon(
              Icons.person,
              color: (user == null) ? Colors.white : Colors.white,
            ),
          ),
        ],
        centerTitle: true,
        title: Text(
          'Statistika',
          style: AppStyle.fontStyle.copyWith(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.taxi,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('orderStatistics')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final reports = snapshot.data!.docs;

          final Map<String, Map<String, dynamic>> userOrderData = {};

          for (var report in reports) {
            final data = report.data() as Map<String, dynamic>;
            final email = data['completedBy'] as String;
            final orderCount = data['orderCount'] as int;
            final peopleCount = data['peopleCount'] ?? 0;
            final orderType = data['orderType'] ?? '';

            if (!userOrderData.containsKey(email)) {
              userOrderData[email] = {
                'totalOrders': 0,
                'totalPeople': 0,
                'totalDeliveries': 0,
              };
            }

            // Counting orders based on the orderType
            if (orderType == 'taksi') {
              userOrderData[email]!['totalOrders'] += orderCount;
              userOrderData[email]!['totalPeople'] += peopleCount;
            } else if (orderType == 'dostavka') {
              userOrderData[email]!['totalDeliveries'] += orderCount;
              userOrderData[email]!['totalOrders'] += orderCount;
            }
          }

          return ListView(
            children: userOrderData.entries.map((entry) {
              return Card(
                color: Colors.white,
                elevation: 5,
                margin: const EdgeInsets.all(10.0),
                child: ListTile(
                  title: Text(
                    'Foydalanuvchi: ${entry.key}',
                    style: AppStyle.fontStyle.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Jami buyurtmalar soni: ${entry.value['totalOrders']}\n'
                    'Odamlar soni: ${entry.value['totalPeople']}\n'
                    'Dostavka soni: ${entry.value['totalDeliveries']}',
                    style: AppStyle.fontStyle.copyWith(fontSize: 14),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
