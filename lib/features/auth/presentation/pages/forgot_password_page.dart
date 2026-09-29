import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/app_validator.dart';
import '../../../../core/utils/firebase_files/dialog_utils.dart';
import '../../../../core/utils/screen_utils.dart';
import '../../../../core/widgets/back_app_bar.dart';
import '../../../../core/widgets/custom_elevatedbutton.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../cubit/auth_cubit.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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

    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            DialogUtils.showLoading(context, s: local.sendingResetLink);
          } else if (state is AuthEmailSent) {
            DialogUtils.hideLoading(context);
            DialogUtils.showMessage(
              context,
              local.checkEmailToReset,
              posActionName: local.ok,
              posAction: () => Navigator.pop(context),
            );
          } else if (state is AuthError) {
            DialogUtils.hideLoading(context);
            DialogUtils.showMessage(context, state.message, title: local.error);
          }
        },
        child: Scaffold(
          appBar: BackAppBar(title: local.forgotPassword),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.06),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: height * 0.02),
                    SizedBox(
                      height: height * 0.46,
                      child: Center(
                        child: Image.asset(AppAssets.forgotPasswordBro),
                      ),
                    ),
                    SizedBox(height: height * 0.02),
                    CustomTextField(
                      textInputType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.done,
                      controller: _emailController,
                      hintText: local.email,
                      icon: FieldIcon.email,
                      validator: (value) =>
                          AppValidator.validateEmail(value, local),
                    ),
                    SizedBox(height: height * 0.02),
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return CustomElevatedButton(
                          label: local.verifyEmail,
                          textStyle: AppStyles.bold16Black,
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  context.read<AuthCubit>().forgotPassword(
                                    _emailController.text.trim(),
                                  );
                                },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
