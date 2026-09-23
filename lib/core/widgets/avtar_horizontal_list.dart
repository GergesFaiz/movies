import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_assets.dart';
import '../utils/app_colors.dart';

class AvtarHorizontalList extends StatefulWidget {
  
  final Function(int) onAvatarSelected;

  const AvtarHorizontalList({super.key, required this.onAvatarSelected});

  @override
  State<AvtarHorizontalList> createState() => _AvtarHorizontalListState();
}

class _AvtarHorizontalListState extends State<AvtarHorizontalList> {
  final List<String> avatarImages = [
    AppAssets.avatar1,
    AppAssets.avatar2,
    AppAssets.avatar3,
    AppAssets.avatar4,
    AppAssets.avatar5,
    AppAssets.avatar6,
    AppAssets.avatar7,
    AppAssets.avatar8,
    AppAssets.avatar9,
    AppAssets.avatar10,
  ];

int? selectedAvatar;
  @override
  Widget build(BuildContext context) {
    double baseRadius = 50.w;
    double selectedRadius = baseRadius * 1.2;
    return SizedBox(
      height: 140.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: avatarImages.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedAvatar == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedAvatar = index;
              });
              
              widget.onAvatarSelected(index);
            },
              child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.symmetric(horizontal: 8.w),
              transform: isSelected?Matrix4.diagonal3Values(1.1, 1.1, 1.0):Matrix4.identity(),
              alignment: Alignment.center,
              child: CircleAvatar(
                radius: isSelected?selectedRadius : baseRadius,
                backgroundColor: isSelected?AppColors.amber:AppColors.gray,
                child: CircleAvatar(
                  radius: isSelected ? (selectedRadius - 3.w) : (baseRadius -
                      2.w),
                  backgroundImage: AssetImage(avatarImages[index]),
                ),
              ),
            )
          );
        },
      ),
    );
  }
}
