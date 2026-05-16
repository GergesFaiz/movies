import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies/utils/app_styles.dart';

class MovieCard extends StatelessWidget {
  final String image;
  final String text;

  const MovieCard({super.key, required this.image, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // صورة الفيلم
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
                  Container(
                    color: Colors.grey[850],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              errorWidget: (_, __, ___) =>
                  Container(
                    color: Colors.grey[850],
                    child: const Icon(
                        Icons.broken_image, color: Colors.white54),
                  ),
            ),
          ),

          // Gradient في الأسفل عشان الـ rating يقرأ
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.3),
                  ],
                  stops: const [0.6, 1.0],
                ),
              ),
            ),
          ),

          // Rating badge
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 14),
                  const SizedBox(width: 4),
                  Text(text, style: AppStyles.regular16white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
