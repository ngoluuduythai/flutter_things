import 'package:flutter/material.dart';
import 'package:flutter_things/number_game/const.dart';

class TargetData {
  TargetData({required this.type, required this.index});
  final TargetType type;
  final int index;

  String get text => type == TargetType.color
      ? 'COLOR ${colorNames[index]}'
      : 'NUMBER $index';
  Color get color => textColors[index];
}