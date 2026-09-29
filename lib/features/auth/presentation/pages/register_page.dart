import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/di/injection.dart';
import 'package:movies/core/router/app_router.dart';
import 'package:movies/features/auth/presentation/cubit/auth_cubit.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/app_validator.dart';
import '../../../../core/utils/firebase_files/dialog_utils.dart';
import '../../../../core/utils/screen_utils.dart';
import '../../../../core/widgets/back_app_bar.dart';
import '../../../../core/widgets/custom_elevatedbutton.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/language_switch.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _nameController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _phoneController;

  final _formKey = GlobalKey<FormState>();
  String _chosenAvatar = AppAssets.avatars.first;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _nameController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
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
              local.accountCreated,
              posActionName: local.ok,
              posAction: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.homeScreen,
                (_) => false,
              ),
            );
          } else if (state is AuthError) {
            DialogUtils.hideLoading(context);
            DialogUtils.showMessage(context, state.message, title: local.error);
          }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: BackAppBar(title: local.register),
          body: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                child: Column(
                  children: [
                    SizedBox(height: height * 0.01),

                    // Avatar carousel
                    CarouselSlider(
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        height: height * 0.18,
                        viewportFraction: 0.37,
                        enableInfiniteScroll: true,
                        enlargeFactor: 0.4,
                        onPageChanged: (index, _) {
                          setState(
                            () => _chosenAvatar = AppAssets.avatars[index],
                          );
                        },
                      ),
                      items: AppAssets.avatars
                          .map((path) => Image.asset(path, fit: BoxFit.cover))
                          .toList(),
                    ),
                    SizedBox(height: height * 0.01),

                    Text(
                      local.avatar,
                      style: AppStyles.regular16white,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: height * 0.02),

                    CustomTextField(
                      textInputType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      controller: _nameController,
                      hintText: local.name,
                      icon: FieldIcon.person,
                      validator: (value) =>
                          AppValidator.validateName(value, local),
                    ),
                    SizedBox(height: height * 0.02),
                    CustomTextField(
                      textInputType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      controller: _emailController,
                      hintText: local.email,
                      icon: FieldIcon.email,
                      validator: (value) =>
                          AppValidator.validateEmail(value, local),
                    ),
                    SizedBox(height: height * 0.02),
                    CustomTextField(
                      textInputType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      controller: _passwordController,
                      hintText: local.password,
                      isPassword: true,
                      validator: (value) =>
                          AppValidator.validatePassword(value, local),
                    ),
                    SizedBox(height: height * 0.02),
                    CustomTextField(
                      textInputType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.next,
                      controller: _confirmPasswordController,
                      hintText: local.confirmPassword,
                      isPassword: true,
                      validator: (value) =>
                          AppValidator.validateConfirmPassword(
                            value,
                            _passwordController.text,
                            local,
                          ),
                    ),
                    SizedBox(height: height * 0.02),
                    CustomTextField(
                      textInputType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      controller: _phoneController,
                      hintText: local.phoneNumber,
                      icon: FieldIcon.phone,
                      validator: (value) =>
                          AppValidator.validatePhone(value, local),
                    ),
                    SizedBox(height: height * 0.02),

                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        return SizedBox(
                          width: double.infinity,
                          child: CustomElevatedButton(
                            label: local.createAccount,
                            textStyle: AppStyles.bold20black,
                            onPressed: state is AuthLoading
                                ? null
                                : () {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    context.read<AuthCubit>().register(
                                      name: _nameController.text.trim(),
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text,
                                      phone: _phoneController.text.trim(),
                                      avatar: _chosenAvatar,
                                    );
                                  },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: height * 0.02),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          local.alreadyHaveAccount,
                          style: AppStyles.bold14White,
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.loginScreen,
                          ),
                          child: Text(
                            local.login,
                            style: AppStyles.bold14White.copyWith(
                              color: AppColors.amber,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                    const Center(child: LanguageSwitch()),
                    SizedBox(height: height * 0.02),
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
