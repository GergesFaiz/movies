import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import '../utils/app_styles.dart';

class CastItem extends StatelessWidget {
  final String? imageUrl;
  final String? actorName;
  final String? characterName;

  const CastItem({
    super.key,
    required this.imageUrl,
    required this.actorName,
    required this.characterName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: CachedNetworkImage(
              imageUrl: imageUrl ?? '',
              width: 60.w,
              height: 60.h,
              fit: BoxFit.cover,
              errorWidget: (_, _, _) => Container(
                width: 60.w,
                height: 60.h,
                color: Colors.grey[800],
                child: const Icon(Icons.person, color: AppColors.white),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                 "Name: ${actorName??'Unknown Actor'} ",
                  style:  AppStyles.bold16White, 
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6.h),
                Text(
                "Character: ${characterName ?? 'Unknown Character'}",
                   style:  AppStyles.bold16White, 
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
