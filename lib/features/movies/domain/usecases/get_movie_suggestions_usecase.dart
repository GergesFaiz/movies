import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie_entity.dart';
import '../repositories/movies_repository.dart';

class GetMovieSuggestionsUseCase implements UseCase<List<MovieEntity>, int> {
  final MoviesRepository repository;

  GetMovieSuggestionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<MovieEntity>>> call(int movieId) {
    return repository.getMovieSuggestions(movieId);
  }
}
