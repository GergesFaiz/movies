import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/app_colors.dart';

class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 128),
      child: Container(
        width: 60,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          border: BoxBorder.all(color: AppColors.amber, width: 2),
        ),
        child: Row(
          spacing: 10,
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: SvgPicture.asset(AppIcon.lr),
              // Image.asset("assets/images/LR.png"),
            ),

            SizedBox(
              height: 40,
              width: 40,
              child: SvgPicture.asset(AppIcon.eg),
              // Image.asset("assets/images/EG.png"),
            ),
          ],
        ),
      ),
    );
  }
}
