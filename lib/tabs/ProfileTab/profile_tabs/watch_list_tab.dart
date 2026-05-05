import 'package:flutter/material.dart';

import '../../../utils/app_assets.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/screen_utils.dart';

class WatchListTab extends StatelessWidget {
  const WatchListTab({super.key});

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: Image.asset(
          AppAssets.empty1,
          width: height *0.28,
          height: height *0.13,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
