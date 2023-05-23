import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:movies_repository_pattern/main.dart';
import 'package:movies_repository_pattern/presentation/list/movies_list_screen.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({required this.data});

  final InitialData data;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: data.providers,
      child: MaterialApp(
        title: 'Movies App',
        home: MoviesListScreen(),
      ),
    );
  }
}

// Need to create all the classes and the initialization
// of all their dependency injections.
// i.e establish a way to satisfy the dependencies for each class

// We willl create a small functionality where a route will be able to load data from 
// a local configuration file
