import 'package:flutter/material.dart';
import 'package:movies/screens/forgot_password_screen.dart';

import '../utils/app_colors.dart';
import '../widgets/app_text_field.dart';
class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});
  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  int _selectedAvatar = 0;
  bool _showAvatarPicker = false;

  // Replace these with your actual avatar image assets or network images
  final List<String> _avatarEmojis = [
    '🧑‍🎤', '🕵️', '👩‍🦰',
    '🧔',   '👩',  '🧑‍💻',
    '👩‍🎨', '🧑‍🚀', '🧓',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.kBg,
      appBar: AppBar(
        backgroundColor: AppColors.kBg,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.kText, size: 18),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: GestureDetector(
          onTap: () => setState(() => _showAvatarPicker = !_showAvatarPicker),
          child: const Text(
            'Pick Avatar',
            style: TextStyle(color: AppColors.amber, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Selected Avatar ──────────────────────
              Center(
                child: GestureDetector(
                  onTap: () => setState(() => _showAvatarPicker = !_showAvatarPicker),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.kCard,
                      border: Border.all(color: AppColors.amber, width: 3),
                    ),
                    child: Center(
                      child: Text(
                        _avatarEmojis[_selectedAvatar],
                        style: const TextStyle(fontSize: 48),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ── Name Field ──────────────────────────
              AppTextField(
                hint: 'John Safwat',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 14),

              // ── Phone Field ─────────────────────────
              AppTextField(
                hint: '01200000000',
                icon: Icons.phone_outlined,
                keyboard: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // ── Reset Password ──────────────────────
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>  ForgotPasswordScreen())),
                child: const Text(
                  'Reset Password',
                  style: TextStyle(color: AppColors.kText, fontSize: 14),
                ),
              ),
              const SizedBox(height: 20),
              // ── Avatar Picker Grid ──────────────────
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: _showAvatarPicker
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: _buildAvatarGrid(),
                secondChild: const SizedBox.shrink(),
              ),

              const SizedBox(height: 24),

              // ── Delete Account Button ───────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => _showDeleteDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE53935),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Delete Account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // ── Update Data Button ──────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.amber,
                    foregroundColor: const Color(0xFF111111),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Update Data',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ── Avatar Grid ────────────────────────────
  Widget _buildAvatarGrid() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.kCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _avatarEmojis.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, i) {
          final selected = i == _selectedAvatar;
          return GestureDetector(
            onTap: () => setState(() {
              _selectedAvatar = i;
              _showAvatarPicker = false;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3A3A3A),
                border: Border.all(
                  color: selected ? AppColors.amber : Colors.transparent,
                  width: 3,
                ),
              ),
              child: Center(
                child: Text(
                  _avatarEmojis[i],
                  style: const TextStyle(fontSize: 36),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ── Delete Confirm Dialog ──────────────────
  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.kCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Account',
            style: TextStyle(color: AppColors.kText, fontWeight: FontWeight.bold)),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
          style: TextStyle(color: AppColors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.amber)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53935),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Delete',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}