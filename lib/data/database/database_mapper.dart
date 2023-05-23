import 'package:logger/logger.dart';
import 'package:movies_repository_pattern/data/database/entity/movie_db_entity.dart';
import 'package:movies_repository_pattern/domain/exception/mapper_exception.dart';
import 'package:movies_repository_pattern/domain/model/movie.dart';

class DatabaseMapper {
  final Logger log;

  DatabaseMapper({required this.log});

  Movie toMovie(MovieDbEntity entity) {
    try {
      return Movie(
        id: entity.movieId,
        title: entity.title,
        imageUrl: entity.imageUrl,
        releaseDate: DateTime.fromMillisecondsSinceEpoch(entity.releaseDate),
      );
    } catch (e) {
      throw MapperException<MovieDbEntity, Movie>(e.toString());
    }
  }

  List<Movie> toMovies(List<MovieDbEntity> entities) {
    final List<Movie> movies = [];
    for (final entity in entities) {
      try {
        movies.add(toMovie(entity));
      } catch (e) {
        log.v('Could not map entity ${entity.movieId}', e);
      }
    }
    return movies;
  }

  MovieDbEntity toMovieDbEntity(Movie movie) {
    try {
      return MovieDbEntity(
        id: null,
        movieId: movie.id,
        title: movie.title,
        imageUrl: movie.imageUrl,
        releaseDate: movie.releaseDate.millisecondsSinceEpoch,
      );
    } catch (e) {
      throw MapperException<Movie, MovieDbEntity>(e.toString());
    }
  }

  toMovieDbEntities(List<Movie> movies) {
    final List<MovieDbEntity> entities = [];

    for (final movie in movies) {
      try {
        entities.add(toMovieDbEntity(movie));
      } catch (e) {
        log.v('Could not map movie ${movie.id}', e);
      }
    }
    return entities;
  }
}
