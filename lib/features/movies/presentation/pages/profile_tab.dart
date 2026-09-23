import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/router/app_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/firebase_files/auth_function.dart';
import '../../../../core/widgets/custom_elevatedbutton.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../widgets/history_tab.dart';
import '../widgets/watch_list_tab.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong',
              style: TextStyle(fontSize: 16.sp, color: Colors.white)));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) return const LoginPage();

        final user = snapshot.data!;

        return FutureBuilder<Map<String, dynamic>?>(
          future: FirebaseFunctions.getUserData(user.uid),
          builder: (context, userDataSnapshot) {
            final userData = userDataSnapshot.data;
            final userName = userData?['name'] ?? 'Loading...';
            final avatarPath = userData?['avatar'];
            final watchListCount =
            ((userData?['watchlist'] as List?)?.length ?? 0).toString();
            final historyCount =
            ((userData?['history'] as List?)?.length ?? 0).toString();

            return Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.headerBackground,
                automaticallyImplyLeading: false,
                toolbarHeight: 280.h,
                title: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      Row(
                        children: [
                          ClipOval(
                            child: _buildAvatar(
                                avatarPath, 110.w, AppAssets.avatar7),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStat(
                                    watchListCount, 'Watch List'),
                                _buildStat(historyCount, 'History'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Text(userName, style: AppStyles.bold20White),
                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: CustomElevatedButton(
                              textStyle: AppStyles.regular20Black,
                              label: 'Edit Profile',
                              onPressed: () =>
                                  Navigator.pushNamed(
                                      context, AppRoutes.updateProfileScreen),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            flex: 1,
                            child: CustomElevatedButton(
                              icon: Icon(Icons.logout,
                                  color: AppColors.white, size: 20.sp),
                              label: 'Exit',
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                if (context.mounted) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const LoginPage()),
                                        (route) => false,
                                  );
                                }
                              },
                              backgroundColor: AppColors.red,
                              textStyle: AppStyles.regular20white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                bottom: TabBar(
                  dividerHeight: 3.h,
                  dividerColor: AppColors.transparent,
                  controller: _tabController,
                  indicatorColor: AppColors.amber,
                  labelColor: AppColors.white,
                  unselectedLabelColor: AppColors.white,
                  indicatorWeight: 2,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: AppStyles.regular20white,
                  unselectedLabelStyle: AppStyles.regular20white,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.list,
                          size: 30.sp, color: AppColors.amber),
                      text: AppLocalizations.of(context)!.watchlist,
                    ),
                    Tab(
                      icon: Icon(Icons.folder,
                          size: 30.sp, color: AppColors.amber),
                      text: 'History',
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                controller: _tabController,
                children: const [WatchListTab(), HistoryTab()],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildAvatar(String? path, double size, String fallback) {
    if (path != null && path.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: path,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) =>
            Image.asset(fallback, fit: BoxFit.cover),
      );
    }
    return Image.asset(path ?? fallback,
        width: size, height: size, fit: BoxFit.cover);
  }

  Widget _buildStat(String count, String label) {
    return Column(
      children: [
        Text(count,
            style: AppStyles.bold16White.copyWith(fontSize: 32.sp)),
        SizedBox(height: 10.h),
        Text(label,
            style: AppStyles.bold16White.copyWith(fontSize: 18.sp)),
      ],
    );
  }
}
