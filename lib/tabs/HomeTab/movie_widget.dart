import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies/api/model/movies.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/utils/app_styles.dart';

class MovieWidget extends StatelessWidget {
  final Movies movie;

  const MovieWidget({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.gray,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Background Image ──
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: movie.backgroundImageOriginal ?? '',
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) =>
                      Container(height: 300, color: Colors.grey[900]),
                ),

                // Gradient
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, AppColors.gray],
                    ),
                  ),
                ),

                // Back Button
                SafeArea(
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),

            // ── Cover + Info ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cover Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: movie.largeCoverImage ?? '',
                      width: 120,
                      height: 170,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        width: 120,
                        height: 170,
                        color: Colors.grey[800],
                        child: const Icon(Icons.movie, color: Colors.white54),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Title + Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          movie.title ?? '',
                          style: AppStyles.bold18White,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),

                        // Rating
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              movie.rating?.toStringAsFixed(1) ?? '0',
                              style: AppStyles.regular16white,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),

                        // Year & Runtime
                        Text(
                          '${movie.year ?? ''} • ${movie.runtime ?? 0} min',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Language
                        Text(
                          movie.language?.toUpperCase() ?? '',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Genres
                        Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: (movie.genres ?? []).map((genre) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.amber),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                genre,
                                style: TextStyle(
                                  color: AppColors.amber,
                                  fontSize: 11,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Synopsis ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Synopsis', style: AppStyles.bold18White),
                  const SizedBox(height: 8),
                  Text(
                    movie.synopsis ??
                        movie.descriptionFull ??
                        'No description available.',
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
