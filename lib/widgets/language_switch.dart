import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/app_colors.dart';
import '../cubit/app_language_cubit.dart'; 
import '../utils/screen_utils.dart';

class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    var height = context.height;
    var width = context.width;

    final languageCubit = context.read<AppLanguageCubit>();
    final isEnglish = languageCubit.state.languageCode == 'en';

    return Center(
      child: Container(
        width: width * 0.22,
        height: height * 0.045,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.amber, width: 2),
        ),
        child: Row(
          spacing: width * 0.025,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  languageCubit.changeLanguage('en'); 
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                 
                    border: Border.all(
                      color: isEnglish ? AppColors.amber : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: SvgPicture.asset(
                    AppIcon.lr, 
                    fit: BoxFit.fill,
                    height: height * 0.03,
                    width: width * 0.06,
                  ),
                ),
              ),
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  languageCubit.changeLanguage('ar'); 
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                   
                    border: Border.all(
                      color: !isEnglish ? AppColors.amber : Colors.transparent,
                      width: 3,
                    ),
                  ),
                  child: SvgPicture.asset(
                    AppIcon.eg,
                    fit: BoxFit.fill,
                    height: height * 0.03,
                    width: width * 0.06,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}