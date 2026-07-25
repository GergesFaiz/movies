import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/router/app_router.dart';
import 'package:movies/features/movies/presentation/bloc/movies_bloc.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../widgets/movie_card.dart';

class BrowseTab extends StatefulWidget {
  const BrowseTab({super.key});

  @override
  State<BrowseTab> createState() => _BrowseTabState();
}

class _BrowseTabState extends State<BrowseTab> {
  @override
  void initState() {
    super.initState();
    context.read<MoviesBloc>().add(LoadBrowseMoviesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MoviesBloc, MoviesState>(
      buildWhen: (prev, curr) =>
          curr is BrowseMoviesLoading ||
          curr is BrowseMoviesLoaded ||
          curr is BrowseMoviesError,
      builder: (context, state) {
        if (state is BrowseMoviesLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.amber),
          );
        }

        if (state is BrowseMoviesError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red, fontSize: 18),
            ),
          );
        }

        if (state is BrowseMoviesLoaded) {
          return Scaffold(
            backgroundColor: AppColors.backgroundDark,
            body: SafeArea(
              child: Column(
                children: [
                  // Genre chips
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    child: SizedBox(
                      height: 52.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: state.genres.length,
                        itemBuilder: (context, index) {
                          final genre = state.genres[index];
                          final isSelected = state.selectedGenre == genre;
                          return GestureDetector(
                            onTap: () => context.read<MoviesBloc>().add(
                              SelectGenreEvent(genre),
                            ),
                            child: Container(
                              margin: EdgeInsets.only(right: 12.w),
                              padding: EdgeInsets.symmetric(
                                horizontal: 28.w,
                                vertical: 12.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.amber
                                    : AppColors.gray.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                              child: Text(
                                genre,
                                style: AppStyles.bold16White.copyWith(
                                  color: isSelected
                                      ? Colors.black
                                      : AppColors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Movies grid
                  Expanded(
                    child: state.movies.isEmpty
                        ? const Center(
                            child: Text(
                              'No movies found',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                          )
                        : GridView.builder(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 8.h,
                            ),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 14.w,
                                  mainAxisSpacing: 18.h,
                                  childAspectRatio: 0.67,
                                ),
                            itemCount: state.movies.length,
                            itemBuilder: (context, index) {
                              final movie = state.movies[index];
                              return MovieCard(
                                imageUrl: movie.coverImage,
                                rating: (movie.rating ?? 0).toStringAsFixed(1),
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.movieDetails,
                                  arguments: movie,
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
