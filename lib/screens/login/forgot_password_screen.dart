import 'package:flutter/material.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/firebase_files/auth_function.dart';
import 'package:movies/utils/firebase_files/dialog_utils.dart';
import 'package:movies/widgets/back_app_bar.dart';

import '../../utils/app_validator.dart';
import '../../utils/screen_utils.dart';
import '../../widgets/custom_elevatedbutton.dart';
import '../../widgets/custom_text_field.dart';

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
              CustomTextField(
                textInputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                controller: emailController,
                hintText: "Email",
                validator: AppValidator.validateEmail,
              ),
              CustomElevatedButton(
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

