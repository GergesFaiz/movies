import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/movie_entity.dart';
import '../repositories/movies_repository.dart';

class GetMoviesParams {
  final String sortBy;
  final int limit;
  final int page;

  const GetMoviesParams({
    this.sortBy = 'date_added',
    this.limit = 100,
    this.page = 1,
  });
}

class GetMoviesUseCase implements UseCase<List<MovieEntity>, GetMoviesParams> {
  final MoviesRepository repository;

  GetMoviesUseCase(this.repository);

  @override
  Future<Either<Failure, List<MovieEntity>>> call(GetMoviesParams params) {
    return repository.getMovies(
      sortBy: params.sortBy,
      limit: params.limit,
      page: params.page,
    );
  }
}
