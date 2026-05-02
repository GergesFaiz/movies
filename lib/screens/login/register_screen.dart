// ═════════════════════════════════════════════
//  2. REGISTER SCREEN
// ═════════════════════════════════════════════
import 'package:flutter/material.dart';
import 'package:movies/utils/appRoutes.dart';
import 'package:movies/widgets/custom_elevatedbutton.dart';
import 'package:movies/widgets/custom_text_field.dart';
import 'package:movies/widgets/language_switch.dart';

import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_styles.dart';
import '../../utils/screen_utils.dart';
import '../../widgets/back_app_bar.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // bool _obscurePass = true, _obscureConfirm = true;
  int _selectedAvatar = 0;
  final _avatars = ['🎧', '🧑', '🤖'];
  late TextEditingController emailcontroller;
  late TextEditingController passwordcontroller;
  late TextEditingController namecontroller;
  late TextEditingController confirmpasswordcontroller;
  late TextEditingController phonecontroller;

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void initState() {
    emailcontroller = TextEditingController();
    passwordcontroller = TextEditingController();
    namecontroller = TextEditingController();
    confirmpasswordcontroller = TextEditingController();
    phonecontroller = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passwordcontroller.dispose();
    namecontroller.dispose();
    confirmpasswordcontroller.dispose();
    phonecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: BackAppBar(title: 'Register'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24 ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: height * 0.02,
            children: [
              // Avatar Picker
         Row(
           mainAxisAlignment: MainAxisAlignment.center,
           spacing: 16,
           children: [
             Image.asset(AppAssets.avatar8),
             Image.asset(AppAssets.avatar10,height: 161,),
             Image.asset(AppAssets.avatar7),
           ],
         ),

              Text(
                'Avatar',
                style: TextStyle(color: AppColors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              CustomTextField(
                textInputType: TextInputType.name,
                textInputAction: TextInputAction.next,
                controller: namecontroller,
                hinttext: "Name",
              ),
              CustomTextField(
                textInputType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                controller: emailcontroller,
                hinttext: "Email",
              ),
              CustomTextField(
                textInputType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                controller: passwordcontroller,
                hinttext: "Password",
                ispassword: true,
              ),
              CustomTextField(
                textInputType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                controller: confirmpasswordcontroller,
                hinttext: "Confirm Password",
                ispassword: true,
              ),
              CustomTextField(
                textInputType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                controller: phonecontroller,
                hinttext: "Phone Number",
              ),

              /* AppTextField(hint: 'Name', icon: Icons.person),

              AppTextField(
                hint: 'Email',
                icon: Icons.email,
                keyboard: TextInputType.emailAddress,
              ),

              AppTextField(
                hint: 'Password',
                icon: Icons.lock,
                isPassword: true,
                obscure: _obscurePass,
                onToggle: () => setState(() => _obscurePass = !_obscurePass),
              ),

              AppTextField(
                hint: 'Confirm Password',
                icon: Icons.lock,
                isPassword: true,
                obscure: _obscureConfirm,
                onToggle: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),

              AppTextField(
                hint: 'Phone Number',
                icon: Icons.phone,
                keyboard: TextInputType.phone,
              ),*/

              /* PrimaryButtonWidget(label: 'Create Account', onPressed: () {}),*/
              CustomElevatedbutton(
                text: "Create Account",
                textStyle: AppStyles.bold20black,
                navigator: () {},
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already Have Account ? ', style: AppStyles.bold14White),
                  GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(
                      context,
                      AppRoutes.loginScreen,
                    ),
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: AppColors.amber,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              // SizedBox(height: 10,),
              Center(child: LanguageSwitch()),
              SizedBox(height: 10),
              /*  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🇺🇸', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 8),
                  Text('🇪🇬', style: TextStyle(fontSize: 24)),
                ],
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
