import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movies/core/router/app_router.dart';
import 'package:movies/features/movies/presentation/bloc/search_bloc.dart';

import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_icons.dart';
import '../../../../core/utils/app_styles.dart';
import '../widgets/movie_card.dart';

class SearchTab extends StatelessWidget {
  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: SafeArea(
          child: Column(
            children: [
              // Search field
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: TextFormField(
                  autocorrect: false,
                  enableSuggestions: false,
                  cursorColor: AppColors.white,
                  style: AppStyles.bold18White,
                  decoration: InputDecoration(
                    hintText: 'Search movies...',
                    hintStyle: AppStyles.bold18White.copyWith(
                      color: AppColors.lightGreyColor,
                      fontSize: 16.sp,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(12.r),
                      child: SvgPicture.asset(
                        AppIcon.search,
                        width: 24.w,
                        height: 24.h,
                      ),
                    ),
                    filled: true,
                    fillColor: AppColors.gray.withValues(alpha: 0.6),
                    contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) => context.read<SearchBloc>().add(
                    SearchQueryChangedEvent(value),
                  ),
                ),
              ),

              // Results area
              Expanded(
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state is SearchInitial) {
                      return Center(
                        child: Image.asset(AppAssets.empty1, width: 240.w),
                      );
                    }

                    if (state is SearchLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.amber,
                        ),
                      );
                    }

                    if (state is SearchError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: TextStyle(color: Colors.red, fontSize: 18.sp),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    if (state is SearchEmpty) {
                      return Center(
                        child: Text(
                          'No movies found',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 18.sp,
                          ),
                        ),
                      );
                    }

                    if (state is SearchLoaded) {
                      return GridView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 16.h,
                          childAspectRatio: 0.68,
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
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
