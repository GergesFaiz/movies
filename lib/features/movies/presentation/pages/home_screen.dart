import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/di/injection.dart';
import 'package:movies/features/movies/presentation/bloc/movies_bloc.dart';
import 'package:movies/features/movies/presentation/bloc/search_bloc.dart';

import '../../../../core/utils/app_colors.dart';
import 'browse_tab.dart';
import 'home_tab.dart';
import 'profile_tab.dart';
import 'search_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    // الـ tabs بتتبنى lazily عشان مش كلهم محتاجين نفس الـ Bloc
    final tabs = [
      const HomeTab(),
      BlocProvider.value(
        value: context.read<SearchBloc>(),
        child: const SearchTab(),
      ),
      BlocProvider(create: (_) => sl<MoviesBloc>(), child: const BrowseTab()),
      const ProfileTab(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: tabs),
      bottomNavigationBar: SizedBox(
        height: 80.h,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: AppColors.gray,
          selectedItemColor: AppColors.amber,
          unselectedItemColor: AppColors.white,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          iconSize: 28.sp,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline),
              activeIcon: Icon(Icons.bookmark),
              label: 'Browse',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
