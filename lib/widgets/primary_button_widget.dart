/*import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final TextStyle textStyle;
  
  PrimaryButtonWidget({super.key,required this.label,
    required this.onPressed,
    required this.backgroundColor,
    required this.textStyle,
   
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
      child: Row(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: textStyle),
         // (icon ?? Container()),
        ],
      ),
    ),
  );
}*/