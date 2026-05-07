import 'package:flutter/material.dart';
import 'package:movies/utils/app_styles.dart';
import 'package:movies/utils/screen_utils.dart';
import 'package:movies/widgets/back_app_bar.dart';
import 'package:movies/widgets/custom_text_field.dart';
import 'package:movies/widgets/primary_button_widget.dart';

import '../../utils/appRoutes.dart';
import '../../utils/app_assets.dart';
import '../../utils/app_colors.dart';
import 'avatars_bottom_sheet.dart';

class UpdateProfileScreen extends StatefulWidget {
   const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {

  int selectedAvatar = 0;


  final List<String> avatarImages = [
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
    var height = context.height;
    var width = context.width;
    return Scaffold(
      appBar: BackAppBar(title: 'Pick Avatar'),
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(
            horizontal: width * 0.03,

          ),
          child: Column(
            spacing: height * 0.02,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () => showAvatarsBottomSheet(),
                  child: Container(
                    width: width * 0.40,
                    height: width * 0.40,
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
                hintText: "John Safwat",
              ),
              CustomTextField(
                textInputType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                controller: phonecontroller,
                hintText: "01200000000",
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
