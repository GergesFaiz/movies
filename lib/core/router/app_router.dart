import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onBoarding:
        return MaterialPageRoute(builder: (_) => const OnboardingPage());

      case AppRoutes.homeScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<MoviesBloc>()),
              BlocProvider(create: (_) => sl<SearchBloc>()),
            ],
            child: const HomeScreen(),
          ),
        );

      case AppRoutes.movieDetails:
        final movie = settings.arguments as MovieEntity;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => sl<MovieDetailsBloc>(),
            child: MovieDetailsPage(movie: movie),
          ),
        );

      case AppRoutes.loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.forgotPasswordScreen:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordPage());

      case AppRoutes.registerScreen:
        return MaterialPageRoute(builder: (_) => const RegisterPage());

      case AppRoutes.updateProfileScreen:
        return MaterialPageRoute(builder: (_) => const UpdateProfilePage());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }
}
