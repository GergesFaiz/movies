import 'package:flutter/material.dart';
import 'package:movies/utils/app_styles.dart';

import '../utils/app_colors.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
   TextStyle? textStyle= AppStyles.regular20Black;

   PrimaryButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor = AppColors.amber,
     this.textStyle
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 56,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: AppColors.blackColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
      ),
      child: Text(label, style: textStyle),
    ),
  );
}
