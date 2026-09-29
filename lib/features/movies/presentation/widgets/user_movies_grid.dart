import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/screen_utils.dart';
import '../../domain/entities/movie_entity.dart';

/// Poster grid used by the profile's Watch List and History tabs.
class UserMoviesGrid extends StatelessWidget {
  final List<MovieEntity> movies;
  final bool isLoading;
  final String emptyMessage;

  const UserMoviesGrid({
    super.key,
    required this.movies,
    required this.isLoading,
    required this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    final height = context.height;
    final width = context.width;

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.amber),
      );
    }

    if (movies.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              AppAssets.empty1,
              width: height * 0.28,
              height: height * 0.13,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 12),
            Text(
              emptyMessage,
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.02,
      ),
      itemCount: movies.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.7,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final movie = movies[index];
        return InkWell(
          onTap: () => Navigator.pushNamed(
            context,
            AppRoutes.movieDetails,
            arguments: movie,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: movie.coverImage,
              fit: BoxFit.cover,
              errorWidget: (_, _, _) => Container(
                color: Colors.grey[900],
                child: const Icon(Icons.movie, color: Colors.white24),
              ),
              placeholder: (context, url) => Container(
                color: Colors.grey[900],
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.amber,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
