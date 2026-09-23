import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';

class AvatarsBottomSheet extends StatefulWidget {
  const AvatarsBottomSheet({
    super.key,
    required this.onAvatarSelected,
    required this.initialAvatar,
  });

  final Function(int) onAvatarSelected;
  final int initialAvatar;

  @override
  State<AvatarsBottomSheet> createState() => _AvatarsBottomSheetState();
}

class _AvatarsBottomSheetState extends State<AvatarsBottomSheet> {
  late int _selectedAvatar;

  final List<String> _avatarImages = [
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

  @override
  void initState() {
    super.initState();
    _selectedAvatar = widget.initialAvatar;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.gray, // Assuming kCard might have been gray or needs adjustment
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _avatarImages.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 14.w,
          mainAxisSpacing: 14.h,
        ),
        itemBuilder: (context, i) {
          final isSelected = i == _selectedAvatar;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedAvatar = i);
              widget.onAvatarSelected(i);
              Future.delayed(
                const Duration(milliseconds: 500),
                () {
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
              );
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.amber.withValues(alpha: 0.35)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.amber, width: 2.w),
              ),
              child: SizedBox(
                width: 80.w,
                child: Image.asset(_avatarImages[i]),
              ),
            ),
          );
        },
      ),
    );
  }
}
