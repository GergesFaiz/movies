import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/app_colors.dart';

import '../utils/app_styles.dart';

class CustomElevatedbutton extends StatelessWidget {
  final String text;

  final bool isIcon;
  final TextStyle textStyle;
  final VoidCallback? navigator;

  const CustomElevatedbutton({
    super.key,
    required this.text,
    this.isIcon = false,
    required this.textStyle,
    required this.navigator,
  });

  @override
  Widget build(BuildContext context) {
   // var height = context.height;

    return ElevatedButton(
      onPressed: () {
        navigator!();
        // Navigator.pushNamed(context, AppRoutes.updateProfileScreen);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.amber,
        padding: EdgeInsets.all(15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(15),
        ),
        alignment: Alignment.center,
      ),
      child: isIcon
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 5,
              children: [
                //Icon(,color: AppColors.gray,size: 40,),
                SvgPicture.asset(AppIcon.googleIcon, height: 26, width: 26),

                Text(
                  text,
                  style: AppStyles.regular16Gray,
                ),
              ],
            )
          : Text(text, style: textStyle),
    );
  }
}
