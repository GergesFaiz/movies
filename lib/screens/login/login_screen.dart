import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies/utils/appRoutes.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/utils/app_styles.dart';
import 'package:movies/widgets/custom_divider.dart';
import 'package:movies/widgets/custom_elevatedbutton.dart';
import 'package:movies/widgets/custom_text_field.dart';
import 'package:movies/widgets/language_switch.dart';
import '../../utils/screen_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailcontroller;
  late TextEditingController passwordcontroller;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void initState() {
    emailcontroller = TextEditingController();
    passwordcontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: width*0.04
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20,

            children: [
              SizedBox(
                height: height*0.126,
                width: width*0.28,
                child: Image.asset(AppAssets.splashImage),
              ),
              Form(
                key: formkey,
                child: Column(
                  spacing: 15,
                  children: [
                    CustomTextField(
                      textInputType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      controller: emailcontroller,
                      hinttext: "Email",
                    ),
                    CustomTextField(
                      textInputType: TextInputType.visiblePassword,
                      textInputAction: TextInputAction.done,
                      controller: passwordcontroller,
                      hinttext: "Password",
                      ispassword: true,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: AlignmentGeometry.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.forgotPasswordScreen,
                    );
                  },
                  child: Text(
                    "Forget Password ?",
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.amber,
                    ),
                  ),
                ),
              ),
              CustomElevatedbutton(
                text: 'Login',
                textStyle: AppStyles.bold20Gray,
                navigator: ()  {
                  Navigator.pushNamed(context, AppRoutes.homeScreen);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don’t Have Account ?",
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.registerScreen);
                    },
                    child: Text(
                      "Create One ",
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.amber,
                      ),
                    ),
                  ),
                ],
              ),
              CustomDivider(),
              CustomElevatedbutton(
                text: 'Login With Google',
                isIcon: true,
                textStyle: AppStyles.bold20black,
                navigator: () => Navigator,
              ),

              LanguageSwitch(),
            ],
          ),
        ),
      ),
    );
  }
}
