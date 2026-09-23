import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../domain/entities/movie_entity.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(
          child: Text(
            AppLocalizations.of(context)!.pleaseLoginFirst,
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.somethingWentWrong,
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child:
                CircularProgressIndicator(color: AppColors.amber));
          }

          final userData = snapshot.data?.data();
          final List<dynamic> historyList = userData?['history'] ?? [];

          if (historyList.isEmpty) {
            return Center(
              child: Image.asset(
                AppAssets.empty1,
                width: 120.w,
                fit: BoxFit.contain,
              ),
            );
          }

          return GridView.builder(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 20.h,
            ),
            itemCount: historyList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.h,
            ),
            itemBuilder: (context, index) {
              final movieData =
              historyList[index] as Map<String, dynamic>;
              final String posterPath = movieData['poster_path'] ?? '';

              return InkWell(
                onTap: () =>
                    Navigator.pushNamed(
                      context,
                      AppRoutes.movieDetails,
                      arguments: MovieEntity(
                        id: movieData['id'] as int?,
                        title: movieData['title'] as String?,
                        rating: (movieData['rating'] as num?)?.toDouble(),
                        mediumCoverImage: posterPath,
                      ),
                    ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: CachedNetworkImage(
                    imageUrl: posterPath,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        Container(
                          color: Colors.grey[900],
                          child: Icon(Icons.movie, color: Colors.white24,
                              size: 30.sp),
                        ),
                    placeholder: (context, url) =>
                        Container(
                          color: Colors.grey[900],
                          child: const Center(
                            child: CircularProgressIndicator(
                                color: AppColors.amber, strokeWidth: 2),
                          ),
                        ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
