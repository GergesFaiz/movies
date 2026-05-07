import 'package:flutter/material.dart';
import 'package:movies/utils/app_assets.dart';

class AvtarHorizontalList extends StatefulWidget {
  // بنضيف الـ Function دي عشان نبعت الاختيار لصفحة الـ Register
  final Function(String) onAvatarSelected;

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

  String? selectedAvatar;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: avatarImages.length,
        itemBuilder: (context, index) {
          bool isSelected = selectedAvatar == avatarImages[index];
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedAvatar = avatarImages[index];
              });
              // بنادي الفنكشن اللي جاية من برا عشان تبلغ صفحة الـ Register
              widget.onAvatarSelected(avatarImages[index]);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.amber : Colors.transparent,
                  // خليها لون شيك يليق مع الموفيز
                  width: 3,
                ),
              ),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage(avatarImages[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}
