import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isOutlined = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null
            ? Icon(icon,
            color: isOutlined ? AppColors.white : AppColors.blackColor)
            : const SizedBox.shrink(),
        label: Text(
          label,
          style: isOutlined ? AppStyles.bold15White:  AppStyles.bold16Black ,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor:
          isOutlined ? Colors.transparent : AppColors.amber, // Filled
          foregroundColor:
          isOutlined ? AppColors.white : AppColors.blackColor, // Text/Icon
          side: isOutlined
              ? const BorderSide(color: AppColors.amber, width: 1.5)
              : BorderSide.none,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: isOutlined ? 0 : 2,
        ),
      ),
    );
  }
}
