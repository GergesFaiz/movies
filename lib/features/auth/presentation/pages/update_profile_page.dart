import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/router/app_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/firebase_files/dialog_utils.dart';
import '../../../../core/utils/screen_utils.dart';
import '../../../../core/widgets/back_app_bar.dart';
import '../../../../core/widgets/custom_elevatedbutton.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../cubit/profile_cubit.dart';
import '../widgets/avatars_bottom_sheet.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final List<String> _avatarImages = AppAssets.avatars;

  int _selectedAvatar = 0;

  /// Form fields are filled once from the first profile we receive, so later
  /// updates don't overwrite what the user is typing.
  bool _initialized = false;

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _phoneController = TextEditingController();
    _fillForm(context.read<ProfileCubit>().state);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _fillForm(ProfileState state) {
    final user = state.user;
    if (_initialized || user == null) return;
    _initialized = true;
    final index = _avatarImages.indexOf(user.avatar);
    if (index != -1) _selectedAvatar = index;
    _nameController.text = user.name;
    _phoneController.text = user.phone;
  }

  void _onStateChanged(BuildContext context, ProfileState state) {
    final local = AppLocalizations.of(context)!;
    setState(() => _fillForm(state));

    if (state.errorMessage != null && state.action == ProfileAction.none) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
    }

    switch (state.action) {
      case ProfileAction.updated:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(local.profileUpdatedSuccessfully)),
        );
        Navigator.pop(context);
      case ProfileAction.deleted:
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.loginScreen,
          (_) => false,
        );
      default:
        break;
    }
  }

  void _confirmDelete(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    DialogUtils.showMessage(
      context,
      local.deleteAccountConfirm,
      title: local.deleteAccount,
      negActionName: local.cancel,
      posActionName: local.delete,
      posAction: () => context.read<ProfileCubit>().deleteAccount(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width;
    final local = AppLocalizations.of(context)!;

    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) =>
          previous.action != current.action ||
          previous.errorMessage != current.errorMessage ||
          (!_initialized && current.user != null),
      listener: _onStateChanged,
      builder: (context, state) {
        if (state.status == ProfileStatus.loading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.amber),
            ),
          );
        }

        return Scaffold(
          appBar: BackAppBar(title: local.editProfile),
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
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              _avatarImages[_selectedAvatar],
                              fit: BoxFit.cover,
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
                      hintText: local.enterYourName,
                      icon: FieldIcon.person,
                    ),
                    SizedBox(height: height * 0.02),
                    CustomTextField(
                      textInputType: TextInputType.phone,
                      textInputAction: TextInputAction.done,
                      controller: _phoneController,
                      hintText: local.enterYourPhone,
                      icon: FieldIcon.phone,
                    ),
                    SizedBox(height: height * 0.01),

                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.forgotPasswordScreen,
                      ),
                      child: Text(
                        local.resetPassword,
                        style: const TextStyle(
                          color: AppColors.kText,
                          fontSize: 14,
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.23),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomElevatedButton(
                          label: local.deleteAccount,
                          onPressed: state.isBusy
                              ? null
                              : () => _confirmDelete(context),
                          backgroundColor: AppColors.red,
                          textStyle: AppStyles.regular16white,
                        ),
                        const SizedBox(height: 15),
                        CustomElevatedButton(
                          label: local.updateData,
                          textStyle: AppStyles.regular16black,
                          onPressed: state.isBusy
                              ? null
                              : () =>
                                    context.read<ProfileCubit>().updateProfile(
                                      name: _nameController.text.trim(),
                                      phone: _phoneController.text.trim(),
                                      avatar: _avatarImages[_selectedAvatar],
                                    ),
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
          setState(() => _selectedAvatar = index);
        },
      ),
    );
  }
}
