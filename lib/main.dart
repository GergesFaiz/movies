import 'package:flutter/material.dart';
import 'package:movies/screens/login_screen.dart';
import 'package:movies/screens/reset_password_screen.dart';
import 'package:movies/screens/update_profile_screen.dart';
import 'package:movies/utils/appRoutes.dart';
import 'package:movies/utils/app_theme.dart';

import 'home_screen.dart';

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
        AppRoutes.homeScreen: (context) => HomeScreen(),
        AppRoutes.resetPasswordScreen: (context) => ResetPasswordScreen(),
        AppRoutes.loginScreen: (context) => LoginScreen(),
        AppRoutes.updateProfileScreen: (context) => UpdateProfileScreen(),
      },
    );
  }
}
