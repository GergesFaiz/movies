import 'package:flutter/material.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/app_colors.dart';

import '../../utils/app_styles.dart';
import '../utils/screen_utils.dart';
import '../widgets/back_app_bar.dart';
import '../widgets/primary_button_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => ResetPasswordScreenState();
}

class ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final emailController = TextEditingController();
  bool emailSent = false;

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: BackAppBar(title: 'Forget Password'),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 430,
                child: Center(child: Image.asset(AppAssets.forgotPasswordBro)),
              ),
              TextField(
                controller: emailController,
                style: AppStyles.medium16white,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: AppStyles.medium16white,
                  prefixIcon: ImageIcon(
                    AssetImage(AppAssets.emailIcon),
                    size: 25,
                    color: AppColors.white,
                  ),
                  filled: true,
                  fillColor: AppColors.gray,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.gray),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: height*0.02),
              PrimaryButtonWidget(
                label: "Verify Email",
                onPressed: () {},

              ),
            ],
          ),
        ),
      ),
    );
  }
}