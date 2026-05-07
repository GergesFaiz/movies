import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/utils/firebase_files/auth_function.dart';
import 'package:movies/utils/firebase_files/dialog_utils.dart';
import 'package:movies/widgets/back_app_bar.dart';
import '../../../utils/app_styles.dart';
import '../../utils/screen_utils.dart';
import '../../widgets/primary_button_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  bool emailSent = false;

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    return Scaffold(
      appBar: BackAppBar(title: "Forget Password"),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width*0.06
        ),
        child: SingleChildScrollView(
          child: Column(
            spacing: height * 0.02,
            children: [
              SizedBox(
                height: height * 0.46,
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
                    size: 31,
                    color: AppColors.white,
                  ),
                  filled: true,
                  fillColor: AppColors.gray.withOpacity(0.2),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.gray),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              PrimaryButtonWidget(
                label: "Verify Email",
                onPressed: () async {
                  if (emailController.text.isNotEmpty) {
                    DialogUtils.showLoading(
                      context,
                      s: "Sending reset link...",
                    );
                    try {
                      String? result = await FirebaseFunctions.resetPassword(
                        emailController.text.trim(),
                      );

                      DialogUtils.hideLoading(context);

                      if (result == null) {
                        DialogUtils.showMessage(
                          context,
                          "Check your email to reset your password!",
                          posActionName: "Ok",
                          posAction: () {
                            Navigator.pop(context);
                          },
                        );
                      } else {
                        DialogUtils.showMessage(
                          context,
                          result,
                          title: "Error",
                        );
                      }
                    } catch (e) {
                      if (context.mounted) DialogUtils.hideLoading(context);
                      DialogUtils.showMessage(
                        context,
                        e.toString(),
                        title: "System Error",
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

