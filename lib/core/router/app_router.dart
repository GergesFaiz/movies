import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/update_profile_page.dart';
import '../../features/movies/domain/entities/movie_entity.dart';
import '../../features/movies/presentation/cubit/movie_details_cubit.dart';
import '../../features/movies/presentation/cubit/movies_cubit.dart';
import '../../features/movies/presentation/cubit/search_cubit.dart';
import '../../features/movies/presentation/pages/home_screen.dart';
import '../../features/movies/presentation/pages/movie_details_page.dart';
import '../../features/movies/presentation/pages/onboarding_page.dart';
import '../di/injection.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

class AppRoutes {
  static const String splash = '/splash';
  static const String onBoarding = '/onboarding';
  static const String homeScreen = '/home';
  static const String movieDetails = '/movie-details';
  static const String loginScreen = '/login';
  static const String forgotPasswordScreen = '/forgot-password';
  static const String registerScreen = '/register';
  static const String updateProfileScreen = '/update-profile';
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    observers: [routeObserver],
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.onBoarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.homeScreen,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<MoviesCubit>()),
            BlocProvider(create: (_) => sl<SearchCubit>()),
          ],
          child: const HomeScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.movieDetails,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<MovieDetailsCubit>(),
          child: MovieDetailsPage(movie: state.extra as MovieEntity),
        ),
      ),
      GoRoute(
        path: AppRoutes.loginScreen,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPasswordScreen,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.registerScreen,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.updateProfileScreen,
        builder: (context, state) => const UpdateProfilePage(),
      ),
    ],
    errorBuilder: (context, state) =>
        const Scaffold(body: Center(child: Text('Page not found'))),
  );
}
