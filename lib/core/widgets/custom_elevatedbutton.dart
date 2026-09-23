import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/app_colors.dart';
import '../utils/app_icons.dart';
import '../utils/app_styles.dart';

class CustomElevatedButton extends StatelessWidget {
  final bool isIcon;
  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final TextStyle? textStyle;
  final Icon? icon;

  const CustomElevatedButton({
    this.isIcon = false,
    this.textStyle,
    super.key,
    required this.label,
    this.onPressed,
    this.backgroundColor = AppColors.amber,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.all(15.r),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        alignment: Alignment.center,
        minimumSize: Size(double.infinity, 56.h),
      ),
      child: isIcon
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(AppIcon.googleIcon, height: 26.h, width: 26.w),
                SizedBox(width: 8.w),
                Text(label, style: AppStyles.regular16Gray),
              ],
            )
          : Text(label, style: textStyle ?? AppStyles.regular20Black),
    );
  }
}
