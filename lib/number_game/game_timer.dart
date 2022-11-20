import 'dart:async';

import 'package:flutter/material.dart';

class GameTimer {
  Timer? _timer;
  ValueNotifier<int> remainingSeconds = ValueNotifier<int>(10);

  //start timer and countdown 15 seconds  
  void startGame() {
    _timer?.cancel();
    remainingSeconds.value = 15;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remainingSeconds.value--;
      if (remainingSeconds.value == 0) {
        _timer?.cancel();
      }
    });
  }
}