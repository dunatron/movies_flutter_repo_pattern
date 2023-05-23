import 'package:movies_repository_pattern/data/database/dao/movies_dao.dart';
import 'package:movies_repository_pattern/data/database/database_mapper.dart';
import 'package:movies_repository_pattern/data/network/client/api_client.dart';
import 'package:movies_repository_pattern/data/network/network_mapper.dart';
import 'package:movies_repository_pattern/domain/model/movie.dart';

/**
 * in a typical clean architecture you would create useCases or interactors
 * for doing this stuff in its own files. 
 * However these classes are usually empty as logic for different systems usually 
 * resides on backend servers.
 * 
 * This app will then opt to use repositories directly from the presentation layer
 * to work with data
 * 
 */
class MoviesRepository {
  final ApiClient apiClient;

  final NetworkMapper networkMapper;

  final MoviesDao moviesDao;

  final DatabaseMapper databaseMapper;

  MoviesRepository({
    required this.apiClient,
    required this.networkMapper,
    required this.moviesDao,
    required this.databaseMapper,
  });

  Future<List<Movie>> getUpcomingMovies({
    required int limit,
    required int page,
  }) async {
    // try to load the movies from the database
    final dbEntities =
        await moviesDao.selectAll(limit: limit, offset: (page * limit) - limit);

    if (dbEntities.isNotEmpty) {
      return databaseMapper.toMovies(dbEntities);
    }

    // fetch movies from remote API
    final upcomingMovies = await apiClient.getUpcomingMovies(
      page: page,
      limit: limit,
    );

    final movies = networkMapper.toMovies(upcomingMovies.results);

    // Save movies to the database
    moviesDao.insertAll(databaseMapper.toMovieDbEntities(movies));

    return movies;
  }

  Future<void> deleteAll() async => moviesDao.deleteAll();

  Future<bool> checkNewData() async {
    final entities = await moviesDao.selectAll(limit: 1);

    if (entities.isEmpty) {
      return false;
    }

    final entity = entities.first;

    final movies = await apiClient.getUpcomingMovies(page: 1, limit: 1);

    if (entity.movieId == movies.results.first.id) {
      return false;
    } else {
      return true;
    }
  }
}
