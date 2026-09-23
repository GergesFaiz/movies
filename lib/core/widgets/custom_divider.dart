 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import '../utils/app_styles.dart';


class CustomDivider extends StatelessWidget 
  {
  const CustomDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 60.w),
      child: Row(
        children: [

          const Expanded(
        child: Divider(
          thickness: 1,
          color: AppColors.amber,
          endIndent: 11,
        ),
      ),

      Text(
        "OR",
        style:AppStyles.medium15Amber
      ),

          const Expanded(
        child: Divider(
          thickness: 1,
          color:AppColors.amber,
          indent: 11,
        ),
      ),]),
    )
   ;
  }}
