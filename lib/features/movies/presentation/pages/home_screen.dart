import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/core/di/injection.dart';
import 'package:movies/features/movies/presentation/bloc/movies_bloc.dart';
import 'package:movies/features/movies/presentation/bloc/search_bloc.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../auth/presentation/cubit/profile_cubit.dart';
import '../bloc/user_movies_cubit.dart';
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
  static const int _browseTabIndex = 2;

  int _currentIndex = 0;

  // Browse keeps its own MoviesBloc so its state doesn't clash with Home's.
  late final MoviesBloc _browseBloc = sl<MoviesBloc>()
    ..add(LoadBrowseMoviesEvent());

  @override
  void dispose() {
    _browseBloc.close();
    super.dispose();
  }

  /// "See More" on Home: open Browse filtered by that genre.
  void _openBrowse(String genre) {
    _browseBloc.add(SelectGenreEvent(genre));
    setState(() => _currentIndex = _browseTabIndex);
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    // الـ tabs بتتبنى lazily عشان مش كلهم محتاجين نفس الـ Bloc
    final tabs = [
      HomeTab(onSeeMore: _openBrowse),
      BlocProvider.value(
        value: context.read<SearchBloc>(),
        child: const SearchTab(),
      ),
      BlocProvider.value(value: _browseBloc, child: const BrowseTab()),
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<ProfileCubit>()..watchProfile()),
          BlocProvider(create: (_) => sl<UserMoviesCubit>()..watch()),
        ],
        child: const ProfileTab(),
      ),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: AppColors.gray,
        selectedItemColor: AppColors.amber,
        unselectedItemColor: AppColors.white,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: local.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: local.search,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bookmark_outline),
            activeIcon: const Icon(Icons.bookmark),
            label: local.browse,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            activeIcon: const Icon(Icons.person),
            label: local.profile,
          ),
        ],
      ),
    );
  }
}
