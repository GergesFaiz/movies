import 'package:flutter/material.dart';
import 'package:movies/screens/reset_password_screen.dart';
import 'package:movies/utils/appRoutes.dart';
import 'package:movies/utils/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.ForgotPasswordScreen,
      routes: {
        AppRoutes.ForgotPasswordScreen: (context) => ForgotPasswordScreen(),
      },
    );
  }
}
