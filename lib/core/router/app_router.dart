import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/cubit/profile_cubit.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/update_profile_page.dart';
import '../../features/movies/domain/entities/movie_entity.dart';
import '../../features/movies/presentation/bloc/movie_details_bloc.dart';
import '../../features/movies/presentation/bloc/movies_bloc.dart';
import '../../features/movies/presentation/bloc/search_bloc.dart';
import '../../features/movies/presentation/pages/home_screen.dart';
import '../../features/movies/presentation/pages/movie_details_page.dart';
import '../../features/movies/presentation/pages/onboarding_page.dart';
import '../di/injection.dart';
import '../l10n/app_localizations.dart';

class AppRoutes {
  static const String onBoarding = '/onboarding';
  static const String homeScreen = '/';
  static const String movieDetails = '/movie-details';
  static const String loginScreen = '/login';
  static const String forgotPasswordScreen = '/forgot-password';
  static const String registerScreen = '/register';
  static const String updateProfileScreen = '/update-profile';
}

class AppRouter {
  /// First screen: onboarding on the very first launch, then login until the
  /// user signs in, and home afterwards.
  static String initialRoute({
    required bool onboardingSeen,
    required bool isLoggedIn,
  }) {
    if (!onboardingSeen) return AppRoutes.onBoarding;
    if (!isLoggedIn) return AppRoutes.loginScreen;
    return AppRoutes.homeScreen;
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onBoarding:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const OnboardingPage(),
        );

      case AppRoutes.homeScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<MoviesBloc>()),
              BlocProvider(create: (_) => sl<SearchBloc>()),
            ],
            child: const HomeScreen(),
          ),
        );

      case AppRoutes.movieDetails:
        final movie = settings.arguments;
        if (movie is! MovieEntity) return _notFound(settings);
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => sl<MovieDetailsBloc>(),
            child: MovieDetailsPage(movie: movie),
          ),
        );

      case AppRoutes.loginScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginPage(),
        );

      case AppRoutes.forgotPasswordScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ForgotPasswordPage(),
        );

      case AppRoutes.registerScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const RegisterPage(),
        );

      case AppRoutes.updateProfileScreen:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => BlocProvider(
            create: (_) => sl<ProfileCubit>()..watchProfile(),
            child: const UpdateProfilePage(),
          ),
        );

      default:
        return _notFound(settings);
    }
  }

  static Route<dynamic> _notFound(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Text(AppLocalizations.of(context)!.pageNotFound),
        ),
      ),
    );
  }
}
