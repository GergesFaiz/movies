import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final IconData? icon;

  const CustomTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.isPassword = false,
    this.validator,
    required this.textInputType,
    required this.textInputAction,
    this.icon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      validator: widget.validator,
      keyboardType: widget.textInputType,
      textInputAction: widget.textInputAction,
      style: AppStyles.bold16White,
      cursorColor: AppColors.amber,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: AppStyles.bold16White.copyWith(
            color: AppColors.white.withValues(alpha: 0.6)),
        prefixIcon: widget.icon != null ? Icon(
            widget.icon, color: AppColors.white, size: 24.sp) : null,
        suffixIcon: widget.isPassword
            ? IconButton(
          onPressed: () => setState(() => _obscureText = !_obscureText),
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.white,
                  size: 24.sp,
                ),
              )
            : null,
        filled: true,
        fillColor: AppColors.gray,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(color: AppColors.amber, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }
}
