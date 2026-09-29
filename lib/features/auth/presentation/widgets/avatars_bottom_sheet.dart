import 'package:flutter/material.dart';

import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/screen_utils.dart';

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

  final List<String> _avatarImages = AppAssets.avatars;

  @override
  void initState() {
    super.initState();
    _selectedAvatar = widget.initialAvatar;
  }

  @override
  Widget build(BuildContext context) {
    final width = context.width;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.kCard,
        borderRadius: BorderRadius.circular(20),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: _avatarImages.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
        ),
        itemBuilder: (_, i) {
          final isSelected = i == _selectedAvatar;
          return GestureDetector(
            onTap: () async {
              setState(() => _selectedAvatar = i);
              widget.onAvatarSelected(i);
              await Future.delayed(const Duration(milliseconds: 500));
              if (!mounted) return;
              Navigator.pop(this.context);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.amber.withAlpha(90)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.amber, width: 2),
              ),
              child: SizedBox(
                width: width * 0.2,
                child: Image.asset(_avatarImages[i]),
              ),
            ),
          );
        },
      ),
    );
  }
}
