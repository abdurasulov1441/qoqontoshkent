import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qoqontoshkent/screens/account_screen.dart';
import 'package:qoqontoshkent/screens/acepted_order_page.dart';
import 'package:qoqontoshkent/screens/civil_page.dart';
import 'package:qoqontoshkent/screens/drivers_page.dart';
import 'package:qoqontoshkent/screens/login_screen.dart';
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
        backgroundColor: AppColors.headerColor,
        title: Text(
          'Asosiy sahifa',
          style: AppStyle.fontStyle
              .copyWith(fontSize: 20, fontWeight: FontWeight.bold),
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
              color: (user == null) ? Colors.black : Colors.yellow,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(child: (user == null) ? const CivilPage() : DriverPage()
            //child: Text('Контент для НЕ зарегистрированных в системе',),
            ),
      ),
    );
  }
}

// class DrawerSimple extends StatelessWidget {
//   const DrawerSimple({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = FirebaseAuth.instance.currentUser;
//     return Column(
//       children: [
//         SizedBox(
//           height: 50,
//         ),
//         (user == null)
//             ? TextButton(
//                 onPressed: () {},
//                 child: Text('user'),
//               )
//             : TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const AcceptedOrdersPage()),
//                   );
//                 },
//                 child: Text('Qabul qilingan buyurtmalar'),
//               )
//       ],
//     );
//   }
// }
