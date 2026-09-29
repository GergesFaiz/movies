import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/router/app_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_styles.dart';
import '../../../../core/utils/screen_utils.dart';
import '../../../../core/widgets/custom_elevatedbutton.dart';
import '../../../auth/presentation/cubit/profile_cubit.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../bloc/user_movies_cubit.dart';
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
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
    final local = AppLocalizations.of(context)!;

    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) =>
          previous.action != current.action &&
          current.action == ProfileAction.loggedOut,
      listener: (context, state) => Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.loginScreen,
        (_) => false,
      ),
      builder: (context, state) {
        if (state.status == ProfileStatus.failure) {
          return Center(
            child: Text(
              local.somethingWentWrong,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }
        if (state.status == ProfileStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.amber),
          );
        }
        if (state.user == null) return const LoginPage();

        final user = state.user!;

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
                          user.avatar,
                          width * 0.27,
                          AppAssets.avatar7,
                        ),
                      ),
                      SizedBox(width: width * 0.04),
                      Expanded(
                        child: BlocBuilder<UserMoviesCubit, UserMoviesState>(
                          builder: (context, moviesState) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStat(
                                moviesState.watchlist.length.toString(),
                                local.watchList,
                                context,
                              ),
                              _buildStat(
                                moviesState.history.length.toString(),
                                local.history,
                                context,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.02),
                  Text(user.name, style: AppStyles.bold20White),
                  SizedBox(height: height * 0.02),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CustomElevatedButton(
                          textStyle: AppStyles.regular20Black,
                          label: local.editProfile,
                          onPressed: () => Navigator.pushNamed(
                            context,
                            AppRoutes.updateProfileScreen,
                          ),
                        ),
                      ),
                      SizedBox(width: width * 0.03),
                      Expanded(
                        flex: 1,
                        child: CustomElevatedButton(
                          icon: const Icon(
                            Icons.logout,
                            color: AppColors.white,
                            size: 20,
                          ),
                          label: local.exit,
                          onPressed: () =>
                              context.read<ProfileCubit>().logout(),
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
                  icon: const Icon(
                    Icons.list,
                    size: 30,
                    color: AppColors.amber,
                  ),
                  text: local.watchlist,
                ),
                Tab(
                  icon: const Icon(
                    Icons.folder,
                    size: 30,
                    color: AppColors.amber,
                  ),
                  text: local.history,
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
  }

  Widget _buildAvatar(String path, double size, String fallback) {
    if (path.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: path,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (_, _) => const CircularProgressIndicator(),
        errorWidget: (_, _, _) => Image.asset(fallback, fit: BoxFit.cover),
      );
    }
    return Image.asset(
      path.isEmpty ? fallback : path,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) =>
          Image.asset(fallback, width: size, height: size, fit: BoxFit.cover),
    );
  }

  Widget _buildStat(String count, String label, BuildContext context) {
    return Column(
      children: [
        Text(count, style: AppStyles.bold16White.copyWith(fontSize: 32)),
        SizedBox(height: context.height * 0.02),
        Text(label, style: AppStyles.bold16White.copyWith(fontSize: 22)),
      ],
    );
  }
}
