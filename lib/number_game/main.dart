import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_things/number_game/game_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final darkBlue = Color.fromARGB(255, 18, 32, 47);
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      home: GameWidget(),
    );
  }
}







