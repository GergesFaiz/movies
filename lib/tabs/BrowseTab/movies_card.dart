import 'package:flutter/material.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/utils/screen_utils.dart';

class MovieCard extends StatelessWidget {
  final String imageUrl;
  final double rating;

  const MovieCard({
    super.key,
    required this.imageUrl,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    var width = context.width;
    var height = context.height;

    return Stack(
      children: [
        // ── الصورة ──
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrl,
            width: width * 0.44,
            height: height * 0.28,
            fit: BoxFit.cover,
          ),
        ),

        // ── الـ Rating ──
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              spacing: 4,
              children: [
                Text(
                  rating.toString(),
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Icon(Icons.star, color: AppColors.amber, size: 14),
              ],
            ),
          ),
        ),
      ],
    );
  }
}