import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qoqontoshkent/style/app_colors.dart';
import 'package:qoqontoshkent/style/app_style.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foydalanuvchilar Statistikasi'),
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

          // Aggregating data by user
          final Map<String, Map<String, int>> userOrderData = {};

          for (var report in reports) {
            final data = report.data() as Map<String, dynamic>;
            final email = data['completedBy'] as String;
            final orderCount = data['orderCount'] as int;
            final peopleCount = data['peopleCount'] as int;

            if (!userOrderData.containsKey(email)) {
              userOrderData[email] = {
                'totalOrders': 0,
                'totalPeople': 0,
              };
            }

            userOrderData[email]!['totalOrders'] =
                userOrderData[email]!['totalOrders']! + orderCount;
            userOrderData[email]!['totalPeople'] =
                userOrderData[email]!['totalPeople']! + peopleCount;
          }

          return ListView(
            children: userOrderData.entries.map((entry) {
              return Card(
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
                    'Buyurtmalar soni: ${entry.value['totalOrders']}\nOdamlar soni: ${entry.value['totalPeople']}',
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
