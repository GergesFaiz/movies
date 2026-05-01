
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/app_colors.dart';

class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Center( 
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.amber, width: 2), 
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, 
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: SvgPicture.asset(AppIcon.lr),
            ),
            const SizedBox(width: 10), 
            SizedBox(
              height: 40,
              width: 40,
              child: SvgPicture.asset(AppIcon.eg),
            ),
          ],
        ),
      ),
    );
  }
}
