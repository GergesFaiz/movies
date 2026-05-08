import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movies/screens/login/forgot_password_screen.dart';
import 'package:movies/screens/login/login_screen.dart';
import 'package:movies/screens/login/register_screen.dart';
import 'package:movies/screens/onboarding/onboarding.dart';
import 'package:movies/screens/updateprofile/update_profile_screen.dart';
import 'package:movies/utils/appRoutes.dart';
import 'package:movies/utils/app_theme.dart';
import 'package:movies/utils/firebase_files/firebase_options.dart';

import 'home_screen.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
FirebaseFirestore.instance.settings = const Settings(
  persistenceEnabled: true, 
);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('en'),
      debugShowCheckedModeBanner: false,
      theme:AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      initialRoute: AppRoutes.registerScreen,
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
