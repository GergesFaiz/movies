import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/api/model/movies.dart';
import 'package:movies/api/retrofit_service.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/utils/app_styles.dart';

import '../../widgets/movie_card.dart';

class MovieDetails extends StatelessWidget {
  final Movies movie;

  const MovieDetails({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image + Play Button
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl:
                      movie.backgroundImageOriginal ??
                      movie.largeCoverImage ??
                      '',
                  width: double.infinity,
                  height: 520.h,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) =>
                      Container(height: 520.h, color: Colors.grey[900]),
                ),
                Container(
                  height: 520.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.backgroundDark.withOpacity(0.85),
                      ],
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

                // Big Play Button
                Positioned(
                  top: 180.h,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Video Player Coming Soon"),
                          ),
                        );
                      },
                      child: Container(
                        width: 90.w,
                        height: 90.w,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          size: 55.w,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),

                  // Title + Year
                  Text(movie.title ?? '', style: AppStyles.bold24White),
                  SizedBox(height: 4.h),
                  Text(
                    "${movie.year ?? ''} • ${movie.language?.toUpperCase() ?? ''}",
                    style: TextStyle(color: Colors.grey[400], fontSize: 15.sp),
                  ),

                  SizedBox(height: 24.h),

                  // Watch Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.red,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text("Watch", style: AppStyles.bold18White),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStat(Icons.favorite_border, "15", "Likes"),
                      _buildStat(Icons.watch_later_outlined, "90", "Watch"),
                      _buildStat(
                        Icons.star,
                        movie.rating?.toStringAsFixed(1) ?? "0.0",
                        "Rating",
                      ),
                    ],
                  ),

                  SizedBox(height: 32.h),

                  // Screen Shots
                  Text("Screen Shots", style: AppStyles.bold20White),
                  SizedBox(height: 12.h),
                  SizedBox(
                    height: 160.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 12.w),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: CachedNetworkImage(
                              imageUrl: movie.mediumCoverImage ?? '',
                              width: 220.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Similar Movies
                  Text("Similar", style: AppStyles.bold20White),
                  SizedBox(height: 16.h),

                  FutureBuilder(
                    future: RetrofitService(
                      Dio(),
                    ).getMovieSuggestions(movieId: movie.id ?? 0),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final suggestions = snapshot.data?.data?.movies ?? [];
                      if (suggestions.isEmpty) return const SizedBox();

                      return SizedBox(
                        height: 220.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: suggestions.length,
                          itemBuilder: (context, index) {
                            final sug = suggestions[index];
                            return Padding(
                              padding: EdgeInsets.only(right: 12.w),
                              child: SizedBox(
                                width: 145.w,
                                child: MovieCard(
                                  image: sug.mediumCoverImage ?? '',
                                  text: (sug.rating ?? 0).toStringAsFixed(1),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            MovieDetails(movie: sug),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 32.h),

                  // Summary
                  Text("Summary", style: AppStyles.bold20White),
                  SizedBox(height: 12.h),
                  Text(
                    movie.synopsis ??
                        movie.descriptionFull ??
                        "No summary available.",
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 15.sp,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.amber, size: 28),
        SizedBox(height: 6.h),
        Text(value, style: AppStyles.bold18White),
        Text(
          label,
          style: TextStyle(color: Colors.grey[500], fontSize: 13.sp),
        ),
      ],
    );
  }
}
