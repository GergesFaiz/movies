import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/app_validator.dart';
import '../../../../core/utils/firebase_files/auth_function.dart';
import '../../../../core/utils/firebase_files/dialog_utils.dart';
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
    final local = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: BackAppBar(title: local.forgotPassword),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.h),
              SizedBox(
                height: 400.h,
                child: Center(child: Image.asset(AppAssets.forgotPasswordBro)),
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                textInputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                controller: _emailController,
                hintText: local.email,
                validator: AppValidator.validateEmail,
              ),
              SizedBox(height: 20.h),
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
