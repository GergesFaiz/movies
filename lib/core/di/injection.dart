import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Auth feature
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/app_language_cubit.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/profile_cubit.dart';
// Movies feature
import '../../features/movies/data/datasources/movies_remote_datasource.dart';
import '../../features/movies/data/datasources/user_movies_remote_datasource.dart';
import '../../features/movies/data/repositories/movies_repository_impl.dart';
import '../../features/movies/data/repositories/user_movies_repository_impl.dart';
import '../../features/movies/domain/repositories/movies_repository.dart';
import '../../features/movies/domain/repositories/user_movies_repository.dart';
import '../../features/movies/domain/usecases/add_to_history_usecase.dart';
import '../../features/movies/domain/usecases/get_movie_details_usecase.dart';
import '../../features/movies/domain/usecases/get_movie_suggestions_usecase.dart';
import '../../features/movies/domain/usecases/get_movies_usecase.dart';
import '../../features/movies/domain/usecases/is_movie_in_watchlist_usecase.dart';
import '../../features/movies/domain/usecases/search_movies_usecase.dart';
import '../../features/movies/domain/usecases/toggle_watchlist_usecase.dart';
import '../../features/movies/domain/usecases/watch_history_usecase.dart';
import '../../features/movies/domain/usecases/watch_watchlist_usecase.dart';
import '../../features/movies/presentation/bloc/movie_details_bloc.dart';
import '../../features/movies/presentation/bloc/movies_bloc.dart';
import '../../features/movies/presentation/bloc/search_bloc.dart';
import '../../features/movies/presentation/bloc/user_movies_cubit.dart';
import '../network/api_client.dart';
import '../network/dio_factory.dart';
import '../storage/app_preferences.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // ─── External ────────────────────────────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => AppPreferences(sharedPreferences));
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  // ─── Network ─────────────────────────────────────────────────────────────
  sl.registerLazySingleton(() => DioFactory.create());
  sl.registerLazySingleton(() => ApiClient(sl()));

  // ─── Movies Feature ───────────────────────────────────────────────────────
  // Datasource
  sl.registerLazySingleton<MoviesRemoteDataSource>(
    () => MoviesRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<UserMoviesRemoteDataSource>(
    () => UserMoviesRemoteDataSourceImpl(sl(), sl()),
  );
  // Repository
  sl.registerLazySingleton<MoviesRepository>(() => MoviesRepositoryImpl(sl()));
  sl.registerLazySingleton<UserMoviesRepository>(
    () => UserMoviesRepositoryImpl(sl()),
  );
  // UseCases
  sl.registerLazySingleton(() => GetMoviesUseCase(sl()));
  sl.registerLazySingleton(() => GetMovieDetailsUseCase(sl()));
  sl.registerLazySingleton(() => GetMovieSuggestionsUseCase(sl()));
  sl.registerLazySingleton(() => SearchMoviesUseCase(sl()));
  sl.registerLazySingleton(() => ToggleWatchlistUseCase(sl()));
  sl.registerLazySingleton(() => AddToHistoryUseCase(sl()));
  sl.registerLazySingleton(() => IsMovieInWatchlistUseCase(sl()));
  sl.registerLazySingleton(() => WatchWatchlistUseCase(sl()));
  sl.registerLazySingleton(() => WatchHistoryUseCase(sl()));
  // Blocs (factory = new instance each time)
  sl.registerFactory(() => MoviesBloc(sl(), sl()));
  sl.registerFactory(() => MovieDetailsBloc(sl(), sl(), sl(), sl()));
  sl.registerFactory(() => SearchBloc(sl()));
  sl.registerFactory(() => UserMoviesCubit(sl(), sl()));

  // ─── Auth Feature ─────────────────────────────────────────────────────────
  // Datasource
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl(), sl()),
  );
  // Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  // Cubit
  sl.registerFactory(() => AuthCubit(sl()));
  sl.registerFactory(() => ProfileCubit(sl()));
  sl.registerLazySingleton(() => AppLanguageCubit(sl()));
}
