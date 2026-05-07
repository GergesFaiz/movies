import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Search',style: TextStyle(
        color: AppColors.white,
      ),)),
    );
  }
}