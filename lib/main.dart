import 'package:flutter/material.dart';
import 'package:movies/screens/login/forgot_password_screen.dart';
import 'package:movies/screens/login/login_screen.dart';
import 'package:movies/screens/onboarding/onboarding.dart';
import 'package:movies/screens/login/register_screen.dart';
import 'package:movies/screens/updateprofile/update_profile_screen.dart';
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
      initialRoute: AppRoutes.onBoarding,
      theme:AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routes: {
        AppRoutes.onBoarding:(context)=>Onboarding(),
        AppRoutes.homeScreen: (context) => HomeScreen(),
        AppRoutes.loginScreen: (context) => LoginScreen(),
        AppRoutes.forgotPasswordScreen: (context) => ForgotPasswordScreen(),
        AppRoutes.registerScreen: (context) => RegisterScreen(),
        AppRoutes.updateProfileScreen: (context) => UpdateProfileScreen(),

      },
    );
  }
}
