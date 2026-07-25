import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/movie_details_entity.dart';
import '../entities/movie_entity.dart';

abstract class MoviesRepository {
  Future<Either<Failure, List<MovieEntity>>> getMovies({
    String sortBy = 'date_added',
    int limit = 50,
    int page = 1,
  });

  Future<Either<Failure, MovieDetailsEntity>> getMovieDetails(int movieId);

  Future<Either<Failure, List<MovieEntity>>> getMovieSuggestions(int movieId);

  Future<Either<Failure, List<MovieEntity>>> searchMovies(String query);
}
