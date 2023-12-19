import 'package:flutter/material.dart';
import 'package:filmy/home_page.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Shortcuts(
        shortcuts: <LogicalKeySet, Intent>{
          LogicalKeySet(LogicalKeyboardKey.select): const ActivateIntent()
        },
        child: MaterialApp(
          title: 'Filmy',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const HomePage(),
        ));
  }
}

void main() {
  runApp(
    Phoenix(child: const MyApp()),
  );
}
