import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movies/core/router/app_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/firebase_files/auth_function.dart';
import '../../../../core/utils/screen_utils.dart';
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
    var height = context.height;
    var width = context.width;

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
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
                toolbarHeight: height * 0.32,
                title: Padding(
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.02),
                      Row(
                        children: [
                          ClipOval(
                            child: _buildAvatar(
                                avatarPath, width * 0.27, AppAssets.avatar7),
                          ),
                          SizedBox(width: width * 0.04),
                          Expanded(
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStat(
                                    watchListCount, 'Watch List', context),
                                _buildStat(historyCount, 'History', context),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.02),
                      Text(userName, style: AppStyles.bold20White),
                      SizedBox(height: height * 0.02),
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
                          SizedBox(width: width * 0.03),
                          Expanded(
                            flex: 1,
                            child: CustomElevatedButton(
                              icon: const Icon(Icons.logout,
                                  color: AppColors.white, size: 20),
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
                  dividerHeight: 3,
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
                      icon: const Icon(Icons.list,
                          size: 30, color: AppColors.amber),
                      text: AppLocalizations.of(context)!.watchlist,
                    ),
                    const Tab(
                      icon: Icon(Icons.folder,
                          size: 30, color: AppColors.amber),
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

  Widget _buildStat(String count, String label, BuildContext context) {
    return Column(
      children: [
        Text(count,
            style: AppStyles.bold16White.copyWith(fontSize: 32)),
        SizedBox(height: context.height * 0.02),
        Text(label,
            style: AppStyles.bold16White.copyWith(fontSize: 22)),
      ],
    );
  }
}
