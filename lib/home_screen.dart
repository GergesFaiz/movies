import 'package:flutter/material.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/widgets/primary_button_widget.dart';

import 'utils/appRoutes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(spacing: 16,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PrimaryButtonWidget(label: 'LoginScreen', onPressed: (){
            Navigator.pushNamed(context, AppRoutes.loginScreen);
          }),

          PrimaryButtonWidget(label: 'UpdateProfileScreen', onPressed: (){
            Navigator.pushNamed(context, AppRoutes.updateProfileScreen);
          }),
        ],
      ),
    );
  }
}
