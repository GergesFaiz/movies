import 'package:flutter/material.dart';
import 'package:movies/utils/app_colors.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Home Tab',style: TextStyle(color: AppColors.white),)),
    );
  }
}