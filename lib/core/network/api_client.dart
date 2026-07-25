import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../features/movies/data/models/source_response_model.dart';

part 'api_client.g.dart';

const String _baseUrl = 'https://movies-api.accel.li/api/v2';

@RestApi(baseUrl: _baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @GET('/list_movies.json')
  Future<SourceResponseModel> getMovies({
    @Query('sort_by') String sortBy = 'date_added',
    @Query('query_term') String? queryTerm,
    @Query('limit') int limit = 50,
    @Query('page') int page = 1,
  });

  @GET('/movie_suggestions.json')
  Future<SourceResponseModel> getMovieSuggestions({
    @Query('movie_id') required int movieId,
  });

  @GET('/movie_details.json')
  Future<HttpResponse<dynamic>> getMovieDetails({
    @Query('movie_id') required int movieId,
    @Query('with_images') bool withImages = true,
    @Query('with_cast') bool withCast = true,
  });
}
