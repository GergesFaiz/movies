import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/di/injection.dart';
import 'package:movies/core/router/app_router.dart';
import 'package:movies/core/storage/app_preferences.dart';
import 'package:movies/features/auth/presentation/cubit/app_language_cubit.dart';

import 'core/l10n/app_localizations.dart';
import 'core/utils/app_theme.dart';
import 'core/utils/firebase_files/firebase_options.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  await setupDependencies();

  runApp(
    BlocProvider(
      create: (_) => sl<AppLanguageCubit>(),
      child: MyApp(
        initialRoute: AppRouter.initialRoute(
          onboardingSeen: sl<AppPreferences>().isOnboardingSeen,
          isLoggedIn: sl<FirebaseAuth>().currentUser != null,
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, this.initialRoute = AppRoutes.homeScreen});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => BlocBuilder<AppLanguageCubit, Locale>(
        builder: (context, localeState) {
          return MaterialApp(
            onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
            navigatorObservers: [routeObserver],
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: localeState,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.dark,
            initialRoute: initialRoute,
            // Start with exactly one route. The default would treat e.g.
            // '/login' as a deep link and push home ('/') underneath it.
            onGenerateInitialRoutes: (route) => [
              AppRouter.generateRoute(RouteSettings(name: route)),
            ],
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}
