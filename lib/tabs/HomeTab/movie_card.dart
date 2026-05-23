import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies/utils/app_styles.dart';

class MovieCard extends StatelessWidget {
  final String image;
  final String text; // Rating
  final String? title;
  final VoidCallback? onTap;
  final int? movieId;

  const MovieCard({
    super.key,
    required this.image,
    required this.text,
    this.title,
    this.onTap,
    this.movieId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                placeholder: (_, _) => Container(
                  color: Colors.grey[850],
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (_, _, _) => Container(
                  color: Colors.grey[850],
                  child: const Icon(Icons.broken_image, color: Colors.white54),
                ),
              ),
            ),

            // Gradient
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.75),
                    ],
                    stops: const [0.6, 1.0],
                  ),
                ),
              ),
            ),

            // Rating
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(text, style: AppStyles.regular16white),
                  ],
                ),
              ),
            ),

            // Title
            if (title != null)
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Text(
                  title!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.bold16White.copyWith(fontSize: 14),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
