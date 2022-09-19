import 'dart:math';

import 'package:flutter/material.dart';

const Color PRIMARY_COLOR_LIGHT = Color(0xFF43F0B7);
const Color PRIMARY_COLOR_DARK = Color(0xFF033927);
Color PRIMARY_COLOR = Color(0xFF43F0B7);

const Color TEXT_COLOR_LIGHT = Color(0xFF191919);
const Color TEXT_COLOR_DARK = Color(0xFFDCDCDC);
Color TEXT_COLOR = Color(0xFF191919);

const Color INPUT_BG_COLOR_LIGHT = Color(0xFF0AFBFF);
const Color INPUT_BG_COLOR_DARK = Color(0xFF454545);
Color INPUT_BG_COLOR = Color(0xFF0AFBFF);

const Color INPUT_BORDER_COLOR_LIGHT = Color(0xFF5A96A1);
const Color INPUT_BORDER_COLOR_DARK = Color(0xFF009991);
Color INPUT_BORDER_COLOR = Color(0xFF5A96A1);

Color ballColor = Colors.blueAccent;

List<Gradient> rainbowColors = [
  const LinearGradient(
      colors: [Color(0xFFFF9494), Color(0xFF123334), Color(0xFFAB9833)]),
  const LinearGradient(colors: [Color(0xFFF20298), Color(0xFFcaaa6b)]),
  const LinearGradient(
      colors: ([
    Color(0xFF939897),
    Color(0xFF3764bb),
  ])),
];

class RandomColor {
  Color rdColor() {
    return Color.fromRGBO(rdValue(), rdValue(), rdValue(), 1);
  }

  int rdValue() {
    return Random().nextInt(256);
  }
}
