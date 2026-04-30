import 'package:flutter/material.dart';
import 'package:movies/screens/login/login_screen.dart';
import 'package:movies/screens/reset_password_screen.dart';
import 'package:movies/utils/appRoutes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.loginScreen,
      routes: {
        AppRoutes.loginScreen:(context)=>LoginScreen(),
        AppRoutes.forgotPasswordScreen: (context) => ForgotPasswordScreen(),
      },
    );
  }
}
