import 'package:flutter/material.dart';
import 'dart:math' as math;

class ChancePaper extends StatelessWidget {
  final int index;
  final Gradient color;
  const ChancePaper({
    Key? key,
    required this.index,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: getRadians((index - 3) * 10),
      child: Container(
        width: 50,
        height: 250,
        decoration: BoxDecoration(
          gradient: color,
        ),
      ),
    );
  }

  double getRadians(double degrees) {
    double radians = degrees * math.pi / 180;

    return radians;
  }
}
