import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:movies_repository_pattern/domain/model/movie.dart';

class MoviePreview extends StatelessWidget {
  static const _size = 100.0;

  final Movie movie;

  const MoviePreview({
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat.yMMMd();
    return Card(
      child: Row(
        children: [
          // Movie image
          if (movie.imageUrl != null)
            Container(
              padding: EdgeInsets.only(
                top: 8.0,
                left: 8.0,
                right: 16.0,
                bottom: 8.0,
              ),
              child: SizedBox(
                width: _size,
                height: _size,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: CachedNetworkImage(
                    imageUrl: movie.imageUrl!,
                  ),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.only(
                top: 8.0,
                left: 8.0,
                right: 16.0,
                bottom: 8.0,
              ),
              child: _PlaceholderWidget(size: _size),
            ),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(
                top: 8.0,
                left: 8.0,
                right: 16.0,
                bottom: 8.0,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      movie.title,
                      style: Theme.of(context).textTheme.titleLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                        formatter.format(movie.releaseDate),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _PlaceholderWidget extends StatelessWidget {
  final double size;

  const _PlaceholderWidget({
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.image_not_supported,
      size: size,
      color: Colors.black38,
    );
  }
}
