import 'package:flutter/material.dart';
import 'dart:math' as math;

class BottomBasic extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  const BottomBasic(
      {Key? key, required this.screenHeight, required this.screenWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
              left: 0,
              right: screenWidth * 0.25,
              child: Image.asset(
                'assets/images/icon/ink.png',
                height: screenHeight * 0.14,
                // width: ,
              )),
          Positioned(
            // top: screenHeight
            left: screenWidth * 0.5,
            right: 0,
            child: Transform.rotate(
              angle: math.pi * 0.65,
              child: Image.asset(
                'assets/images/icon/quill.png',
                height: screenHeight * 0.3,
              ),
            ),
          )
        ]);
  }
}
