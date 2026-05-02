import 'package:flutter/material.dart';

import '../../utils/app_colors.dart';

class AvatarsBottomSheet extends StatefulWidget {
   AvatarsBottomSheet({
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
  late int selectedAvatar;

  final List<String> avatarImages = List.generate(
    9,
        (i) => 'assets/images/avatars/gamer (${i + 1}).png',
  );

  @override
  void initState() {
    super.initState();
    selectedAvatar = widget.initialAvatar;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics:  NeverScrollableScrollPhysics(),
        itemCount: avatarImages.length,
        gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemBuilder: (context, i) {
          final selected = i == selectedAvatar;
          return GestureDetector(
            onTap: () {
              setState(() => selectedAvatar = i);
              widget.onAvatarSelected(i);
              Future.delayed(
                 Duration(milliseconds: 500),
                    () => Navigator.pop(context),
              );
            },
            child: AnimatedContainer(
              duration:  Duration(milliseconds: 200),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.amber : Colors.transparent,
                  width: 3,
                ),
              ),
              child: ClipOval(
                child: Image.asset(avatarImages[i], fit: BoxFit.cover),
              ),
            ),
          );
        },
      ),
    );
  }
}