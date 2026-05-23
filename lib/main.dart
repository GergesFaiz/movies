import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/cubit/movie_cubit.dart';
import 'package:movies/cubit/app_language_cubit.dart';
import 'package:movies/l10n/app_localizations.dart';
import 'package:movies/screens/login/forgot_password_screen.dart';
import 'package:movies/screens/login/login_screen.dart';
import 'package:movies/screens/login/register_screen.dart';
import 'package:movies/screens/onboarding/onboarding.dart';
import 'package:movies/screens/updateprofile/update_profile_screen.dart';
import 'package:movies/utils/appRoutes.dart';
import 'package:movies/utils/app_theme.dart';
import 'package:movies/utils/firebase_files/firebase_options.dart';

import 'home_screen.dart';

final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: true,
  );

  runApp(
    BlocProvider(
      create: (context) => AppLanguageCubit(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => BlocBuilder<AppLanguageCubit, Locale>(
        builder: (context, localeState) {
          return MaterialApp(
            navigatorObservers: [routeObserver],
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: localeState,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.dark,
            initialRoute: AppRoutes.homeScreen,
            routes: {
              AppRoutes.onBoarding: (context) => Onboarding(),
              AppRoutes.homeScreen: (context) => BlocProvider(
                    create: (context) => MoviesCubit(),
                    child: HomeScreen(),
                  ),
              AppRoutes.loginScreen: (context) => LoginScreen(),
              AppRoutes.forgotPasswordScreen: (context) => ForgotPasswordScreen(),
              AppRoutes.registerScreen: (context) => RegisterScreen(),
              AppRoutes.updateProfileScreen: (context) => UpdateProfileScreen(),
            },
          );
        },
      ),
    );
  }
}