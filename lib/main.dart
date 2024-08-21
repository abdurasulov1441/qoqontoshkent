import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qoqontoshkent/screens/account_screen.dart';
import 'package:qoqontoshkent/screens/home_screen.dart';
import 'package:qoqontoshkent/screens/login_screen.dart';
import 'package:qoqontoshkent/screens/reset_password_screen.dart';
import 'package:qoqontoshkent/screens/signup_screen.dart';
import 'package:qoqontoshkent/screens/verify_email_screen.dart';
import 'package:qoqontoshkent/services/firebase_streem.dart';

// Firebase Авторизация - Сценарии:
//    Войти - Почта / Пароль
//    Личный кабинет
//    Зарегистрироваться - Почта / Пароль два раза
//        Подтвердить почту - Отправить письмо снова / Отменить
//    Сбросить пароль - Почта

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp()); // Replace with your actual app widget
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        }),
      ),
      routes: {
        '/': (context) => const FirebaseStream(),
        '/home': (context) => const HomeScreen(),
        '/account': (context) => const AccountScreen(),
        '/login': (context) => const LoginScreen(),
        '/reset_password': (context) => const ResetPasswordScreen(),
        '/verify_email': (context) => const VerifyEmailScreen(),
      },
      initialRoute: '/',
    );
  }
}
