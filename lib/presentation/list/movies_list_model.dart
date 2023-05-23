import 'package:logger/logger.dart';
import 'package:movies_repository_pattern/data/repository/movies_repository.dart';
import 'package:movies_repository_pattern/domain/model/movie.dart';

class MoviesListModel {
  final Logger log;

  final MoviesRepository moviesRepo;

  MoviesListModel({
    required this.log,
    required this.moviesRepo,
  });

  Future<List<Movie>> fetchPage(int page) async {
    try {
      return await moviesRepo.getUpcomingMovies(limit: 10, page: page);
    } catch (e) {
      log.e('Error fetching page $page', e);
      rethrow;
    }
  }

  Future<void> deletePersistedMovies() async {
    try {
      await moviesRepo.deleteAll();
    } catch (e) {
      log.e('Error when deleting movies', e);
      rethrow;
    }
  }

  Future<bool> hasNewData() async {
    try {
      return await moviesRepo.checkNewData();
    } catch (e) {
      log.e('Error when checking for new data', e);
      return true;
    }
  }
}
