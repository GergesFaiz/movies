import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movies/core/di/injection.dart';
import 'package:movies/core/router/app_router.dart';
import 'package:movies/features/auth/presentation/cubit/app_language_cubit.dart';

import 'core/l10n/app_localizations.dart';
import 'core/utils/app_theme.dart';
import 'core/utils/firebase_files/firebase_options.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
RouteObserver<ModalRoute<void>>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  await setupDependencies();

  runApp(
    BlocProvider(
      create: (_) => sl<AppLanguageCubit>(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
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
            initialRoute: AppRoutes.splash,
            onGenerateRoute: AppRouter.generateRoute,
          );
        },
      ),
    );
  }
}
