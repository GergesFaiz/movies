import 'package:flutter/material.dart';

import '../utils/app_assets.dart';
import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

enum FieldIcon { email, person, phone, lock }

class CustomTextField extends StatefulWidget {
  final TextInputType textInputType;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool isPassword;
  final String hintText;

  /// Leading icon. Password fields show a lock when this is left `null`.
  final FieldIcon? icon;

  const CustomTextField({
    super.key,
    required this.textInputType,
    required this.textInputAction,
    required this.controller,
    this.validator,
    this.isPassword = false,
    required this.hintText,
    this.icon,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool isShowPassword;

  @override
  void initState() {
    super.initState();

    isShowPassword = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autocorrect: false,
      enableSuggestions: false,
      cursorColor: AppColors.white,
      cursorRadius: const Radius.circular(16),
      keyboardType: widget.textInputType,
      textInputAction: widget.textInputAction,
      controller: widget.controller,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: AppStyles.regular16white,
      obscureText: isShowPassword,
      onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: AppStyles.regular16white,

        filled: true,
        fillColor: AppColors.gray,
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  setState(() {
                    isShowPassword = !isShowPassword;
                  });
                },
                icon: Icon(
                  isShowPassword ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.white,
                ),
              )
            : null,
        prefixIcon: _buildPrefixIcon(),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.blackColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.blackColor, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.red, width: 1),
        ),
      ),
    );
  }

  Widget? _buildPrefixIcon() {
    final icon = widget.icon ?? (widget.isPassword ? FieldIcon.lock : null);
    switch (icon) {
      case FieldIcon.lock:
        return const Icon(Icons.lock, color: AppColors.white, size: 26);
      case FieldIcon.email:
        return ImageIcon(
          AssetImage(AppAssets.emailIcon),
          size: 31,
          color: AppColors.white,
        );
      case FieldIcon.person:
        return const Icon(Icons.person, color: AppColors.white);
      case FieldIcon.phone:
        return const Icon(Icons.phone, color: AppColors.white);
      case null:
        return null;
    }
  }
}
