import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qoqontoshkent/style/app_colors.dart';
import 'package:qoqontoshkent/style/app_style.dart';

class DriverPage extends StatefulWidget {
  const DriverPage({super.key});

  @override
  _DriverPageState createState() => _DriverPageState();
}

class _DriverPageState extends State<DriverPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  Future<void> _acceptOrder(String orderId) async {
    if (_user == null) {
      _showSnackBar('User not authenticated');
      return;
    }

    final orderRef =
        FirebaseFirestore.instance.collection('orders').doc(orderId);
    final driverRef =
        FirebaseFirestore.instance.collection('drivers').doc(_user!.uid);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final orderSnapshot = await transaction.get(orderRef);

      if (orderSnapshot.exists && orderSnapshot['status'] == 'pending') {
        // Update the order status and assign it to the current driver
        transaction.update(orderRef, {
          'status': 'accepted',
          'driverId': _user!.uid,
          'driverEmail': _user!.email,
        });

        // Add the order to the driver's specific list
        transaction.set(driverRef.collection('acceptedOrders').doc(orderId),
            orderSnapshot.data()!);
      }
    });

    if (mounted) {
      _showSnackBar('Buyurtma qabul qilindi');
    }
  }

  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('status', isEqualTo: 'pending')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final orders = snapshot.data!.docs;

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            final orderData = order.data() as Map<String, dynamic>;

            return Card(
              color: Colors.white,
              elevation: 5,
              margin: const EdgeInsets.all(10.0),
              child: ListTile(
                title: Text(
                  '${orderData['fromLocation']} dan ${orderData['toLocation']} gacha',
                  style: AppStyle.fontStyle.copyWith(fontSize: 12),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Odamlar: ${orderData['peopleCount']}',
                      style: AppStyle.fontStyle.copyWith(fontSize: 12),
                    ),
                    Text(
                      'Vaqt: ${DateFormat('yyyy-MM-dd – HH:mm').format(orderData['orderTime'].toDate())}',
                      style: AppStyle.fontStyle.copyWith(fontSize: 12),
                    ),
                  ],
                ),
                trailing: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: AppColors.taxi),
                  onPressed: () => _acceptOrder(order.id),
                  child: Text(
                    'Qabul qilish',
                    style: AppStyle.fontStyle.copyWith(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
