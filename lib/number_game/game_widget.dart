import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_things/number_game/const.dart';
import 'package:flutter_things/number_game/game_timer.dart';
import 'package:flutter_things/number_game/main.dart';
import 'package:flutter_things/number_game/target.dart';
import 'package:flutter_things/number_game/target_data.dart';
import 'package:flutter_things/number_game/text_prompt.dart';

class GameWidget extends StatefulWidget {
  @override
  _GameWidgetState createState() => _GameWidgetState();
}

class _GameWidgetState extends State<GameWidget> {
  static final _rng = Random();

  late Alignment _playerAlignment;
  late List<Alignment> _targets;
  late TargetData _targetData;
  int _score = 0;
  bool _gameInProgress = false;
  GameTimer _gameTimer = GameTimer();

  @override
  void initState() {
    super.initState();
    _playerAlignment = Alignment(0, 0);
    _gameTimer.remainingSeconds.addListener(() {
      if (_gameTimer.remainingSeconds.value == 0) {
        setState(() {
          _gameInProgress = false;
        });
      }
    });
    _randomize();
  }

  void _randomize() {
    _targetData = TargetData(
      type: TargetType.values[_rng.nextInt(2)],
      index: _rng.nextInt(targetColors.length),
    );
    _targets = [
      for (var i = 0; i < targetColors.length; i++)
        Alignment(
          _rng.nextDouble() * 2 - 1,
          _rng.nextDouble() * 2 - 1,
        )
    ];
  }

  void _startGame() {
    _randomize();
    setState(() {
      _score = 0;
      _gameInProgress = true;
    });
    _gameTimer.startGame();
  }

  // This method contains most of the game logic
  void _handleTapDown(TapDownDetails details, int? selectedIndex) {
    if (!_gameInProgress) {
      return;
    }
    final size = MediaQuery.of(context).size;
    setState(() {
      if (selectedIndex != null) {
        _playerAlignment = _targets[selectedIndex];
        final didScore = selectedIndex == _targetData.index;
        Future.delayed(Duration(milliseconds: 250), () {
          setState(() {
            if (didScore) {
              _score++;
            } else {
              _score--;
            }
            _randomize();
          });
        });
        // score point
      } else {
        _playerAlignment = Alignment(
          2 * (details.localPosition.dx / size.width) - 1,
          2 * (details.localPosition.dy / size.height) - 1,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Handle taps anywhere
          Positioned.fill(
            child: GestureDetector(
              onTapDown: (details) => _handleTapDown(details, null),
            ),
          ),
          // Player
          // TO DO: Convert to AnimatedAlign & add a duration argument
          Align(
            alignment: _playerAlignment,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: _targetData.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Targets
          for (var i = 0; i < targetColors.length; i++)
            GestureDetector(
              // Handle taps on targets
              onTapDown: (details) => _handleTapDown(details, i),
              // TO DO: Convert to AnimatedAlign & add a duration argument
              child: Align(
                alignment: _targets[i],
                child: Target(
                  color: targetColors[i],
                  textColor: textColors[i],
                  text: i.toString(),
                ),
              ),
            ),
          // Next Command
          Align(
            alignment: Alignment(0, 0),
            child: IgnorePointer(
              ignoring: _gameInProgress,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextPrompt(
                    'Score: $_score',
                    color: Colors.white,
                    fontSize: 24,
                  ),
                  TextPrompt(
                    _gameInProgress ? 'Tap ${_targetData.text}' : 'Game Over!',
                    color: _gameInProgress ? _targetData.color : Colors.white,
                  ),
                  _gameInProgress
                      ? ValueListenableBuilder(
                          valueListenable: _gameTimer.remainingSeconds,
                          builder: (context, remainingSeconds, _) {
                            return TextPrompt(remainingSeconds.toString(),
                                color: Colors.white);
                          },
                        )
                      : OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: StadiumBorder(),
                            side: BorderSide(width: 2, color: Colors.white),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextPrompt('Start', color: Colors.white),
                          ),
                          onPressed: _startGame,
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
