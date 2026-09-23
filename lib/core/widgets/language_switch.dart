import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../features/auth/presentation/cubit/app_language_cubit.dart';
import '../utils/app_colors.dart';
import '../utils/app_icons.dart';

class LanguageSwitch extends StatelessWidget {
  const LanguageSwitch({super.key});

  @override
  Widget build(BuildContext context) {
    final languageCubit = context.read<AppLanguageCubit>();
    final isEnglish = languageCubit.state.languageCode == 'en';

    return Center(
      child: Container(
        width: 100.w,
        height: 40.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: AppColors.amber, width: 2.w),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  languageCubit.changeLanguage('en');
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),

                    border: Border.all(
                      color: isEnglish ? AppColors.amber : Colors.transparent,
                      width: 3.w,
                    ),
                  ),
                  child: SvgPicture.asset(
                    AppIcon.lr,
                    fit: BoxFit.contain,
                    height: 24.h,
                    width: 24.w,
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
                    borderRadius: BorderRadius.circular(30.r),

                    border: Border.all(
                      color: !isEnglish ? AppColors.amber : Colors.transparent,
                      width: 3.w,
                    ),
                  ),
                  child: SvgPicture.asset(
                    AppIcon.eg,
                    fit: BoxFit.contain,
                    height: 24.h,
                    width: 24.w,
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
