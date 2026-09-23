import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/utils/app_assets.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final bool seenOnboarding = prefs.getBool('seenOnboarding') ?? false;

    if (!seenOnboarding) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.onBoarding);
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (!mounted) return;
    if (user != null) {
      Navigator.pushReplacementNamed(context, AppRoutes.homeScreen);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          AppAssets.onboardingOne, // Or a dedicated logo if available
          width: 200.w,
        ),
      ),
    );
  }
}
