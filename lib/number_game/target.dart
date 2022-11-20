import 'package:flutter/material.dart';

class Target extends StatelessWidget {
  const Target({
    Key? key,
    required this.color,
    required this.textColor,
    required this.text,
  }) : super(key: key);
  final Color color;
  final Color textColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      height: 75,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
      ),
    );
  }
}