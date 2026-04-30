import 'package:flutter/material.dart';
import 'package:movies/screens/register_screen.dart';
import 'package:movies/screens/reset_password_screen.dart';
import 'package:movies/utils/appRoutes.dart';

import '../utils/app_colors.dart';
import '../widgets/app_text_field.dart';
import '../widgets/primary_button_widget.dart';

class LoginScreen extends StatefulWidget {
   LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            children: [
               SizedBox(height: 20),

              // Logo
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.amber, width: 3),
                ),
                child:  Icon(
                  Icons.play_arrow_rounded,
                  color: AppColors.amber,
                  size: 50,
                ),
              ),

               SizedBox(height: 44),

              AppTextField(
                hint: 'Email',
                icon: Icons.email_outlined,
                keyboard: TextInputType.emailAddress,
              ),
               SizedBox(height: 14),
              AppTextField(
                hint: 'Password',
                icon: Icons.lock_outline,
                isPassword: true,
                obscure: _obscure,
                onToggle: () => setState(() => _obscure = !_obscure),
              ),
               SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => ResetPasswordScreen()),
                  ),
                  child:  Text(
                    'Forget Password ?',
                    style: TextStyle(color: AppColors.amber, fontSize: 13),
                  ),
                ),
              ),
               SizedBox(height: 22),

              PrimaryButtonWidget(
                label: 'Login',
                onPressed: () {
                },
              ),
               SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(
                    "Don't Have Account ? ",
                    style: TextStyle(color: AppColors.kIcon, fontSize: 13),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RegisterScreen()),
                    ),
                    child:  Text(
                      'Create One',
                      style: TextStyle(
                        color: AppColors.amber,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
               SizedBox(height: 16),

              // OR Divider
               Row(
                children: [
                  Expanded(child: Divider(color: Color(0xFF444444))),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'OR',
                      style: TextStyle(color: AppColors.white, fontSize: 13),
                    ),
                  ),
                  Expanded(child: Divider(color: Color(0xFF444444))),
                ],
              ),
               SizedBox(height: 16),

              // Google Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.kCard,
                    foregroundColor: AppColors.kText,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  icon:  Text(
                    'G',
                    style: TextStyle(
                      color: AppColors.amber,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                  label:  Text(
                    'Login With Google',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),

               SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('🇺🇸', style: TextStyle(fontSize: 24)),
                  SizedBox(width: 8),
                  Text('🇪🇬', style: TextStyle(fontSize: 24)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
