import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movies/core/router/app_router.dart';
import 'package:movies/features/auth/presentation/pages/login_page.dart';

import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/screen_utils.dart';
import '../../../../core/widgets/back_app_bar.dart';
import '../../../../core/widgets/custom_elevatedbutton.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../widgets/avatars_bottom_sheet.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  int _selectedAvatar = 2;
  bool _avatarChanged = false;

  final List<String> _avatarImages = [
    AppAssets.avatar7,
    AppAssets.avatar8,
    AppAssets.avatar9,
    AppAssets.avatar4,
    AppAssets.avatar5,
    AppAssets.avatar6,
    AppAssets.avatar1,
    AppAssets.avatar2,
    AppAssets.avatar3,
  ];

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _loadCurrentData();
  }

  Future<void> _loadCurrentData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(uid)
        .get();

    if (doc.exists) {
      final data = doc.data();
      final currentAvatar = data?['avatar'] as String?;
      final index = _avatarImages.indexOf(currentAvatar ?? '');
      setState(() {
        if (index != -1) _selectedAvatar = index;
        _nameController.text = data?['name'] ?? '';
        _phoneController.text = data?['phoneNum'] ?? '';
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Widget _buildAvatarImage(String path) {
    if (path.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: path,
        fit: BoxFit.cover,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) =>
            Image.asset(_avatarImages[_selectedAvatar], fit: BoxFit.cover),
      );
    }
    return Image.asset(path, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width;

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Scaffold(
              body: Center(child: Text('Something went wrong')));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        if (!snapshot.hasData) return const LoginPage();

        final user = snapshot.data!;

        return Scaffold(
          appBar: BackAppBar(title: 'Edit Profile'),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: height * 0.02),

                    // Avatar picker
                    Center(
                      child: GestureDetector(
                        onTap: _showAvatarsBottomSheet,
                        child: Container(
                          width: width * 0.40,
                          height: width * 0.40,
                          decoration:
                          const BoxDecoration(shape: BoxShape.circle),
                          child: ClipOval(
                            child: _avatarChanged
                                ? Image.asset(
                              _avatarImages[_selectedAvatar],
                                    fit: BoxFit.cover,
                                  )
                                : StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(user.uid)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      }
                                      final data = snapshot.data?.data()
                                      as Map<String, dynamic>?;
                                      final avatarPath =
                                          data?['avatar'] as String?;
                                      return _buildAvatarImage(avatarPath ??
                                          _avatarImages[_selectedAvatar]);
                                    },
                                  ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.02),

                    CustomTextField(
                      textInputType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      controller: _nameController,
                      hintText: 'Enter your name',
                    ),
                    SizedBox(height: height * 0.02),
                    CustomTextField(
                      textInputType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      controller: _phoneController,
                      hintText: 'Enter your phone',
                    ),
                    SizedBox(height: height * 0.01),

                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.forgotPasswordScreen),
                      child: Text(
                        'Reset Password',
                        style: TextStyle(
                            color: AppColors.kText, fontSize: 14),
                      ),
                    ),

                    SizedBox(height: height * 0.23),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomElevatedButton(
                          label: 'Delete Account',
                          onPressed: () async {
                            final uid = user.uid;
                            try {
                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(uid)
                                  .delete();
                              await user.delete();
                              if (context.mounted) {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, AppRoutes.loginScreen, (
                                    route) => false);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(
                                      'Failed to delete account: $e')),
                                );
                              }
                            }
                          },
                          backgroundColor: AppColors.red,
                          textStyle: AppStyles.regular16white,
                        ),
                        const SizedBox(height: 15),
                        CustomElevatedButton(
                          label: 'Update Data',
                          textStyle: AppStyles.regular16black,
                          onPressed: () async {
                            try {
                              final updates = <String, dynamic>{
                                'avatar': _avatarImages[_selectedAvatar],
                              };
                              final newName = _nameController.text.trim();
                              final newPhone = _phoneController.text.trim();
                              if (newName.isNotEmpty) updates['name'] = newName;
                              if (newPhone.isNotEmpty) {
                                updates['phoneNum'] = newPhone;
                              }

                              await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(user.uid)
                                  .set(updates, SetOptions(merge: true));

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Profile updated successfully')),
                                );
                                Navigator.pop(context);
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.02),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAvatarsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => AvatarsBottomSheet(
        initialAvatar: _selectedAvatar,
        onAvatarSelected: (index) {
          setState(() {
            _selectedAvatar = index;
            _avatarChanged = true;
          });
        },
      ),
    );
  }
}
