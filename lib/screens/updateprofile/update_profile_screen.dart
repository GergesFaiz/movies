import 'package:flutter/material.dart';
import 'package:movies/utils/app_styles.dart';
import 'package:movies/utils/screen_utils.dart';
import 'package:movies/widgets/back_app_bar.dart';
import 'package:movies/widgets/custom_text_field.dart';
import 'package:movies/widgets/primary_button_widget.dart';

import '../../utils/appRoutes.dart';
import '../../utils/app_colors.dart';
import 'avatars_bottom_sheet.dart';

class UpdateProfileScreen extends StatefulWidget {
   UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {

  int selectedAvatar = 0;


  final List<String> avatarImages = List.generate(
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
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            spacing: 19,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () => showAvatarsBottomSheet(),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        avatarImages[selectedAvatar],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),

              CustomTextField(
                textInputType: TextInputType.name,
                textInputAction: TextInputAction.next,
                controller: namecontroller,
                hinttext: "John Safwat",
              ),
              CustomTextField(
                textInputType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                controller: phonecontroller,
                hinttext: "01200000000",
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.forgotPasswordScreen,
                ),
                child:  Text(
                  'Reset Password',
                  style: TextStyle(color: AppColors.kText, fontSize: 14),
                ),
              ),
               Spacer(),
              PrimaryButtonWidget(
                label: 'Delete Account',
                onPressed: () {},
                backgroundColor: AppColors.red,
                textStyle: AppStyles.regular16white,
              ),
              PrimaryButtonWidget(label: 'Update Data', onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }

  void showAvatarsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => AvatarsBottomSheet(
        initialAvatar: selectedAvatar,
        onAvatarSelected: (index) {
          setState(() => selectedAvatar = index);
        },
      ),
    );
  }
}
