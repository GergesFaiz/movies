import 'package:flutter/material.dart';
import 'package:movies/utils/app_styles.dart';
import 'package:movies/utils/screen_utils.dart';
import 'package:movies/widgets/back_app_bar.dart';
import 'package:movies/widgets/custom_text_field.dart';
import 'package:movies/widgets/primary_button_widget.dart';

import '../utils/appRoutes.dart';
import '../utils/app_colors.dart';

class UpdateProfileScreen extends StatefulWidget {
  UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  int _selectedAvatar = 0;
  bool _showAvatarPicker = false;

  final List<String> _avatarImages = List.generate(
    9,
    (i) => 'assets/images/avatars/gamer (${i + 1}).png',
  );

  late TextEditingController namecontroller;
  late TextEditingController phonecontroller;

  @override
  void initState() {
    namecontroller = TextEditingController();
    phonecontroller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    namecontroller.dispose();
    phonecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackAppBar(title: 'Pick Avatar'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () =>
                      setState(() => _showAvatarPicker = !_showAvatarPicker),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(shape: BoxShape.circle),
                    child: ClipOval(
                      child: Image.asset(
                        _avatarImages[_selectedAvatar],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 35),

              CustomTextField(
                textInputType: TextInputType.name,
                textInputAction: TextInputAction.next,
                controller: namecontroller,
                hinttext: "John Safwat",
              ),
              SizedBox(height: 19),
              CustomTextField(
                textInputType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                controller: phonecontroller,
                hinttext: "01200000000",
              ),
              SizedBox(height: 14),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.forgotPasswordScreen,
                ),
                child: Text(
                  'Reset Password',
                  style: TextStyle(color: AppColors.kText, fontSize: 14),
                ),
              ),
              SizedBox(height: 20),

              AnimatedCrossFade(
                duration: Duration(milliseconds: 300),
                crossFadeState: _showAvatarPicker
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: _buildAvatarGrid(),
                secondChild: SizedBox.shrink(),
              ),

              SizedBox(height: context.height * .28),
              PrimaryButtonWidget(
                label: 'Delete Account',
                onPressed: () {},
                backgroundColor: AppColors.red,
                textStyle: AppStyles.regular16white,
              ),
              SizedBox(height: 14),
              PrimaryButtonWidget(label: 'Update Data', onPressed: () {}),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildAvatarGrid() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _avatarImages.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemBuilder: (context, i) {
          final selected = i == _selectedAvatar;
          return GestureDetector(
            onTap: () => setState(() {
              _selectedAvatar = i;
              _showAvatarPicker = false;
            }),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.amber : Colors.transparent,
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: Image.asset(_avatarImages[i], fit: BoxFit.cover),
              ),
            ),
          );
        },
      ),
    );
  }
}
