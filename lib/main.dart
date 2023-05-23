import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:movies_repository_pattern/data/database/dao/movies_dao.dart';
import 'package:movies_repository_pattern/data/database/database_mapper.dart';
import 'package:movies_repository_pattern/data/network/client/api_client.dart';
import 'package:movies_repository_pattern/data/network/network_mapper.dart';
import 'package:movies_repository_pattern/data/repository/movies_repository.dart';
import 'package:movies_repository_pattern/domain/model/config.dart';
import 'package:movies_repository_pattern/presentation/app/app.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:sqflite/sqflite.dart';

class InitialData {
  final List<SingleChildWidget> providers;

  InitialData({required this.providers});
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await Sqflite.devSetDebugModeOn(kDebugMode);

  final data = await _createData();

  runApp(App(data: data));
}

Future<InitialData> _createData() async {
  // Util
  final log = Logger(
    printer: PrettyPrinter(),
    level: kDebugMode ? Level.verbose : Level.nothing,
  );

  // Load project configuration
  final _config = await _loadConfig(log);

  // Data
  final apiClient = ApiClient(
    baseUrl: 'https://moviesdatabase.p.rapidapi.com/',
    apiKey: _config.apiKey,
    apiHost: _config.apiHost,
  );

  final networkMapper = NetworkMapper(log: log);
  final moviesDao = MoviesDao();
  final databaseMapper = DatabaseMapper(log: log);

  final moviesRepository = MoviesRepository(
    apiClient: apiClient,
    networkMapper: networkMapper,
    moviesDao: moviesDao,
    databaseMapper: databaseMapper,
  );

  // create and return a list of the create providers
  return InitialData(
    providers: [
      Provider<Logger>.value(value: log),
      Provider<MoviesRepository>.value(value: moviesRepository),
    ],
  );
}

Future<Config> _loadConfig(Logger log) async {
  String raw;

  try {
    raw = await rootBundle.loadString('assets/config/config.json');

    final config = json.decode(raw) as Map<String, dynamic>;

    return Config(
      apiKey: config['apiKey'] as String,
      apiHost: config['apiHost'] as String,
    );
  } catch (e) {
    log.e(
      'Error while while loading project configuration, please make sure '
      'that the file located at /assets/config/config.json'
      'exists ',
      e,
    );
    rethrow;
  }
}
