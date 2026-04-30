import 'package:flutter/material.dart';
import 'package:movies/utils/app_styles.dart';

import '../utils/app_colors.dart';

class AppTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool isPassword, obscure;
  final VoidCallback? onToggle;
  final TextInputType keyboard;

   const AppTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.obscure = false,
    this.onToggle,
    this.keyboard = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        obscureText: isPassword && obscure,
        keyboardType: keyboard,
        style: AppStyles.bold16White,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle:  AppStyles.bold16White,
          prefixIcon: Icon(icon, color: AppColors.white, size: 20),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscure ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.white,
                    size: 20,
                  ),
                  onPressed: onToggle,
                )
              : null,
          border: InputBorder.none,
          contentPadding:  EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
