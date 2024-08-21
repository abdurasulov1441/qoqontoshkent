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
        stream:
            FirebaseFirestore.instance.collection('orderReports').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final reports = snapshot.data!.docs;

          final Map<String, int> userOrderCounts = {};

          // Count completed orders per user
          for (var report in reports) {
            final data = report.data() as Map<String, dynamic>;
            final email = data['completedBy'] as String;

            if (userOrderCounts.containsKey(email)) {
              userOrderCounts[email] = userOrderCounts[email]! + 1;
            } else {
              userOrderCounts[email] = 1;
            }
          }

          return ListView(
            children: userOrderCounts.entries.map((entry) {
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
                    'Buyurtmalar soni: ${entry.value}',
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
