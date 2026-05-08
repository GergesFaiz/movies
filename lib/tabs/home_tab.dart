import 'package:flutter/material.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/utils/screen_utils.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    double width=context.width;
    return Scaffold(
     
      body: Center(child: Stack(
          fit: StackFit.expand,
          children: [
            
            
               SizedBox(
                      height: context.height * 0.5, 
                      width: double.infinity,
                      child: Image.asset(
                        AppOnboardingImage.onbaordingImage6,
                        fit: BoxFit.cover,
                      ),
              ),
              Container(
                      height: context.height,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent, 
                AppColors.gray.withOpacity(0.8),
                AppColors.gray, 
              ],
              stops: const [0.0, 0.4, 0.9], 
                        ),
                      ),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  spacing: context.height/2.5,
                  children: [
                    SafeArea(
                      child: 
                    Image.asset(AppAssets.available),),
                      
                               Image.asset(AppAssets.watchnow),
                  ],
                ),
              ),
                      
                      
              ],
            
          
      ),)
    );
  }
}