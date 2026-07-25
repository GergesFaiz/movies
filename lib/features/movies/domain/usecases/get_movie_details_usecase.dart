import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie_details_entity.dart';
import '../repositories/movies_repository.dart';

class GetMovieDetailsUseCase implements UseCase<MovieDetailsEntity, int> {
  final MoviesRepository repository;

  GetMovieDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, MovieDetailsEntity>> call(int movieId) {
    return repository.getMovieDetails(movieId);
  }
}
