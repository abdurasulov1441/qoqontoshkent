import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qoqontoshkent/style/app_colors.dart';
import 'package:qoqontoshkent/style/app_style.dart';

class AcceptedOrdersPage extends StatefulWidget {
  const AcceptedOrdersPage({super.key});

  @override
  _AcceptedOrdersPageState createState() => _AcceptedOrdersPageState();
}

class _AcceptedOrdersPageState extends State<AcceptedOrdersPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User? _user;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
  }

  // Method to reject an order
  Future<void> _rejectOrder(String orderId) async {
    final orderRef =
        FirebaseFirestore.instance.collection('orders').doc(orderId);
    final driverRef =
        FirebaseFirestore.instance.collection('drivers').doc(_user!.uid);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final orderSnapshot = await transaction.get(orderRef);
      final driverSnapshot = await transaction
          .get(driverRef.collection('acceptedOrders').doc(orderId));

      if (orderSnapshot.exists && driverSnapshot.exists) {
        // Revert the order to pending and remove it from the driver's list
        transaction.update(orderRef, {
          'status': 'pending',
          'driverId': null,
          'driverPhoneNumber': null,
        });

        transaction.delete(driverSnapshot.reference);
      }
    });

    _showSnackBar('Buyurtma bekor qilindi');
  }

  // Method to delete an order after completion
  Future<void> _deleteOrder(String orderId) async {
    final orderRef =
        FirebaseFirestore.instance.collection('orders').doc(orderId);
    final driverRef =
        FirebaseFirestore.instance.collection('drivers').doc(_user!.uid);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final driverSnapshot = await transaction
          .get(driverRef.collection('acceptedOrders').doc(orderId));

      if (driverSnapshot.exists) {
        // Remove the order from the driver's accepted orders list
        transaction.delete(driverSnapshot.reference);
      }

      // Optionally, you can delete the order from the main orders collection as well
      transaction.delete(orderRef);
    });

    _showSnackBar('Buyurtma o\'chirildi');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('drivers')
          .doc(_user!.uid)
          .collection('acceptedOrders')
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
              margin: const EdgeInsets.all(10.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${orderData['fromLocation']} dan ${orderData['toLocation']} gacha',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text('Odamlar soni: ${orderData['peopleCount']}'),
                    Text('Telefon: ${orderData['phoneNumber']}'),
                    Text(
                        'Ketish vaqti: ${DateFormat('yyyy-MM-dd – HH:mm').format(orderData['orderTime'].toDate())}'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => _rejectOrder(order.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: Text(
                            'Bekor qilish',
                            style: AppStyle.fontStyle.copyWith(
                                color: AppColors.headerColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => _deleteOrder(order.id),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: Text(
                            'Buyurtmani o\'chirish',
                            style: AppStyle.fontStyle.copyWith(
                                color: AppColors.headerColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
