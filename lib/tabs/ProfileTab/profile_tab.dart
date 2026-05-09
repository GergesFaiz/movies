import 'package:flutter/material.dart';
import 'package:movies/screens/login/login_screen.dart';
import 'package:movies/tabs/ProfileTab/profile_tabs/history_tab.dart';
import 'package:movies/tabs/ProfileTab/profile_tabs/watch_list_tab.dart';
import 'package:movies/utils/appRoutes.dart';
import 'package:movies/utils/app_assets.dart';
import 'package:movies/utils/app_colors.dart';
import 'package:movies/utils/app_styles.dart';
import 'package:movies/utils/screen_utils.dart';
import 'package:movies/widgets/primary_button_widget.dart';

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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.headerBackground,
        automaticallyImplyLeading: false,
        toolbarHeight: height * 0.32,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
          child: Column(
            spacing: height * 0.02,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: width * 0.04,
                children: [
                  ClipOval(
                    child: Image.asset(
                      AppAssets.avatar7,
                      width: width * 0.27,
                      height: width * 0.27,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        buildStat('12', 'Wish List', context),
                        buildStat('10', 'History', context),
                      ],
                    ),
                  ),
                ],
              ),

              Text('John Safwat', style: AppStyles.bold20White),

              Row(
                spacing: width * 0.03,
                children: [
                  Expanded(
                    flex: 2,
                    child: PrimaryButtonWidget(
                      textStyle: AppStyles.regular20Black,
                      label: 'Edit Profile',
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.updateProfileScreen);
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: PrimaryButtonWidget(
                      icon: Icon(
                        Icons.logout,
                        color: AppColors.white,
                        size: 20,
                      ),
                      label: 'Exit',
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context, MaterialPageRoute(builder: (_) =>
                            LoginScreen()), (route) => false);
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
              icon: Icon(Icons.list, size: 30, color: AppColors.amber),
              text: 'Watch List',
            ),
            Tab(
              icon: Icon(Icons.folder, size: 30, color: AppColors.amber),
              text: 'History',
            ),
          ],
        ),
      ),
      body: Expanded(
        child: TabBarView(
          controller: _tabController,
          children: [HistoryTab(), WatchListTab()],
        ),
      ),
    );
  }
}

Widget buildStat(String count, String label, BuildContext context) {
  return Column(
    spacing: context.height * 0.02,
    children: [
      Text(count, style: AppStyles.bold16White.copyWith(fontSize: 32)),
      Text(label, style: AppStyles.bold16White.copyWith(fontSize: 22)),
    ],
  );
}
