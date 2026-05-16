import 'package:flutter/material.dart';
import 'package:movies/utils/appRoutes.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/app_styles.dart';
import 'package:movies/widgets/custom_divider.dart';
import 'package:movies/widgets/custom_elevatedbutton.dart';
import 'package:movies/widgets/custom_text_field.dart';
import 'package:movies/widgets/language_switch.dart';

import '../../utils/firebase_files/auth_function.dart';
import '../../utils/firebase_files/dialog_utils.dart';
import '../../utils/screen_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.04),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: height * 0.02,
                children: [
                  SizedBox(
                    height: height * 0.28,
                    width: width * 0.28,
                    child: Image.asset(AppAssets.splashImage),
                  ),
                  CustomTextField(
                    textInputType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    controller: emailController,
                    hintText: "Email",
                  ),
                  CustomTextField(
                    textInputType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    controller: passwordController,
                    hintText: "Password",
                    isPassword: true,
                  ),
                  Align(
                    alignment: AlignmentGeometry.centerRight,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.forgotPasswordScreen,
                        );
                      },
                      child: Text(
                        "Forget Password ?",
                        style: AppStyles.medium14Amber,
                      ),
                    ),
                  ),
                  CustomElevatedButton(
                    label: 'Login',
                    textStyle: AppStyles.bold20Gray,
                    onPressed: () async {
                      print("Start Login");
                      if (formKey.currentState!.validate()) {
                        DialogUtils.showLoading(s: 'LOADING...', context);
                        try {
                          String? error =
                              await FirebaseFunctions.signInWithEmailAndPassword(
                                emailAddress: emailController.text,
                                password: passwordController.text,
                              );

                          DialogUtils.hideLoading(context);

                          if (error == null) {
                            DialogUtils.showMessage(
                              context,
                              'Login successfully!',
                              posActionName: 'Ok',
                              posAction: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  AppRoutes.homeScreen,
                                );
                              },
                            );
                          } else {
                            DialogUtils.showMessage(
                              context,
                              error,
                              title: "Error",
                            );
                          }
                        } catch (e) {
                          DialogUtils.hideLoading(context);
                          DialogUtils.showMessage(
                            context,
                            e.toString(),
                            title: "System Error",
                          );
                        }
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don’t Have Account ? ",
                        style: AppStyles.medium14White,
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.registerScreen,
                          );
                        },
                        child: Text(
                          " Create One ",
                          style: AppStyles.medium14Amber.copyWith(
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  CustomDivider(),
                  CustomElevatedButton(
                    label: ' Login With Google ',
                    isIcon: true,
                    textStyle: AppStyles.regular16black,
                    onPressed: () => Navigator,
                  ),
                  LanguageSwitch(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
