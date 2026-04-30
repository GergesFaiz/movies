// ═════════════════════════════════════════════
//  2. REGISTER SCREEN
// ═════════════════════════════════════════════
import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/app_styles.dart';
import '../utils/screen_utils.dart';
import '../widgets/app_text_field.dart';
import '../widgets/back_app_bar.dart';
import '../widgets/primary_button_widget.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscurePass = true, _obscureConfirm = true;
  int _selectedAvatar = 0;
  final _avatars = ['🎧', '🧑', '🤖'];

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    return Scaffold(
      backgroundColor: AppColors.kBg,
      appBar: BackAppBar(title: 'Register'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            spacing: height * 0.02,
            children: [
              // Avatar Picker
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_avatars.length, (i) {
                  final sel = i == _selectedAvatar;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedAvatar = i),
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 200),
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.kCard,
                        border: Border.all(
                          color: sel ? AppColors.amber : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _avatars[i],
                          style: TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              Text(
                'Avatar',
                style: TextStyle(color: AppColors.white, fontSize: 12),
              ),
              AppTextField(hint: 'Name', icon: Icons.person_outline),

              AppTextField(
                hint: 'Email',
                icon: Icons.email_outlined,
                keyboard: TextInputType.emailAddress,
              ),

              AppTextField(
                hint: 'Password',
                icon: Icons.lock_outline,
                isPassword: true,
                obscure: _obscurePass,
                onToggle: () => setState(() => _obscurePass = !_obscurePass),
              ),

              AppTextField(
                hint: 'Confirm Password',
                icon: Icons.lock_outline,
                isPassword: true,
                obscure: _obscureConfirm,
                onToggle: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
              ),

              AppTextField(
                hint: 'Phone Number',
                icon: Icons.phone_outlined,
                keyboard: TextInputType.phone,
              ),

              PrimaryButtonWidget(label: 'Create Account', onPressed: () {}),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already Have Account ? ',
                    style: AppStyles.bold14White,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
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
