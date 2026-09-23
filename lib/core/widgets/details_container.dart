import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_styles.dart';

class DetailsContainer extends StatelessWidget {
  final String text;
  final bool isicon;
  final IconData icon;

  const DetailsContainer({
    super.key,
    required this.text,
    this.isicon = true,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isicon
              ? Icon(
                  icon,
                  color: Colors.amber,
            size: 24.sp,
                )
              : SizedBox(width: 8.w),
          SizedBox(width: 4.w),
          Text(
            text,
            style: AppStyles.regular16white,
          ),
        ],
      ),
    );
  }
}
