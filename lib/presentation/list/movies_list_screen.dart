import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:movies_repository_pattern/domain/model/movie.dart';
import 'package:movies_repository_pattern/presentation/list/movie_preview.dart';
import 'package:movies_repository_pattern/presentation/list/movies_list_model.dart';
import 'package:provider/provider.dart';

class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({super.key});

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  late final MoviesListModel _model;
  final PagingController<int, Movie> _pagingController = PagingController(
    firstPageKey: 1,
  );

  late final Future<void> _future;

  @override
  void initState() {
    _model = MoviesListModel(
      log: Provider.of(context, listen: false),
      moviesRepo: Provider.of(context, listen: false),
    );

    _future = checkNewData();

    _pagingController.addPageRequestListener((pageKey) async {
      try {
        final movies = await _model.fetchPage(pageKey);
        _pagingController.appendPage(movies, pageKey + 1);
      } catch (e) {
        _pagingController.error = e;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upcoming movies'),
      ),
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) => RefreshIndicator(
          onRefresh: refresh,
          child: PagedListView(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Movie>(
              itemBuilder: (context, movie, index) {
                return Container(
                  padding: const EdgeInsets.only(
                    left: 12,
                    top: 6,
                    right: 12,
                    bottom: 6,
                  ),
                  child: MoviePreview(movie: movie),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> refresh() async {
    await _model.deletePersistedMovies();
    _pagingController.refresh();
  }

  Future<void> checkNewData() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      final hasNewData = await _model.hasNewData();

      if (hasNewData) {
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: Text('Refresh to obtain the new available data'),
            action: SnackBarAction(
              label: 'Refresh',
              onPressed: refresh,
            ),
          ),
        );
      }
    });
  }
}
