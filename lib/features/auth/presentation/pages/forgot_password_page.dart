import 'package:flutter/material.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/app_validator.dart';
import '../../../../core/utils/firebase_files/auth_function.dart';
import '../../../../core/utils/firebase_files/dialog_utils.dart';
import '../../../../core/utils/screen_utils.dart';
import '../../../../core/widgets/back_app_bar.dart';
import '../../../../core/widgets/custom_elevatedbutton.dart';
import '../../../../core/widgets/custom_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width;
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: BackAppBar(title: local.forgotPassword),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.06),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: height * 0.02),
              SizedBox(
                height: height * 0.46,
                child: Center(child: Image.asset(AppAssets.forgotPasswordBro)),
              ),
              SizedBox(height: height * 0.02),
              CustomTextField(
                textInputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                controller: _emailController,
                hintText: local.email,
                validator: AppValidator.validateEmail,
              ),
              SizedBox(height: height * 0.02),
              CustomElevatedButton(
                label: local.verifyEmail,
                textStyle: AppStyles.bold16Black,
                onPressed: () async {
                  if (_emailController.text.isNotEmpty) {
                    DialogUtils.showLoading(context, s: local.sendingResetLink);
                    try {
                      final result = await FirebaseFunctions.resetPassword(
                        _emailController.text.trim(),
                      );

                      if (context.mounted) DialogUtils.hideLoading(context);

                      if (context.mounted) {
                        if (result == null) {
                          DialogUtils.showMessage(
                            context,
                            local.checkEmailToReset,
                            posActionName: 'Ok',
                            posAction: () => Navigator.pop(context),
                          );
                        } else {
                          DialogUtils.showMessage(
                            context,
                            result,
                            title: 'Error',
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) DialogUtils.hideLoading(context);
                      if (context.mounted) {
                        DialogUtils.showMessage(
                          context,
                          e.toString(),
                          title: 'System Error',
                        );
                      }
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
