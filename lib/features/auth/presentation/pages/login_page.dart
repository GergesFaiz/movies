import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/di/injection.dart';
import 'package:movies/core/router/app_router.dart';
import 'package:movies/features/auth/presentation/cubit/auth_cubit.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/firebase_files/dialog_utils.dart';
import '../../../../core/utils/screen_utils.dart';
import '../../../../core/widgets/custom_divider.dart';
import '../../../../core/widgets/custom_elevatedbutton.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/language_switch.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
            DialogUtils.showLoading(s: local.loading, context);
          } else if (state is AuthSuccess) {
            DialogUtils.hideLoading(context);
            DialogUtils.showMessage(
              context,
              local.loginSuccess,
              posActionName: local.ok,
              posAction: () =>
                  Navigator.pushReplacementNamed(context, AppRoutes.homeScreen),
            );
          } else if (state is AuthError) {
            DialogUtils.hideLoading(context);
            DialogUtils.showMessage(context, state.message, title: local.error);
          }
        },
        child: Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: height * 0.02),
                      SizedBox(
                        height: height * 0.28,
                        child: Image.asset(AppAssets.splashImage),
                      ),
                      SizedBox(height: height * 0.02),
                      CustomTextField(
                        textInputType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        controller: _emailController,
                        hintText: local.email,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return local.emailRequired;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      CustomTextField(
                        textInputType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        controller: _passwordController,
                        hintText: local.password,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return local.passwordRequired;
                          }
                          if (value.length < 6) return local.passwordTooShort;
                          return null;
                        },
                      ),
                      SizedBox(height: height * 0.01),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () => Navigator.pushNamed(
                            context,
                            AppRoutes.forgotPasswordScreen,
                          ),
                          child: Text(
                            local.forgetPassword,
                            style: AppStyles.medium14Amber,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.02),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          return CustomElevatedButton(
                            label: local.login,
                            textStyle: AppStyles.bold20Gray,
                            onPressed: state is AuthLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthCubit>().login(
                                        _emailController.text.trim(),
                                        _passwordController.text,
                                      );
                                    }
                                  },
                          );
                        },
                      ),
                      SizedBox(height: height * 0.02),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            local.dontHaveAccount,
                            style: AppStyles.medium14White,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () => Navigator.pushNamed(
                              context,
                              AppRoutes.registerScreen,
                            ),
                            child: Text(
                              local.createOne,
                              style: AppStyles.medium14Amber.copyWith(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      CustomDivider(),
                      SizedBox(height: height * 0.02),
                      LanguageSwitch(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
