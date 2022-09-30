import 'package:flutter/material.dart';

///...............
/// 큰공 <-> 작은공 (MainBall class)
///...............
// class MainBall extends StatelessWidget {
//   final AnimationController controller;
//   final GestureTapCallback onTap;
//   const MainBall({
//     Key? key,
//     required this.controller,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: AnimatedBuilder(
//           animation: controller,
//           child: GestureDetector(
//             onTap: onTap,
//             child: Container(
//                 decoration:
//                     BoxDecoration(shape: BoxShape.circle, color: ballColor),
//                 width: initBallSize,
//                 height: initBallSize,
//                 child: Center(
//                   child: Text("click!"),
//                 )),
//           ),
//           builder: (context, child) {
//             return Transform.scale(
//               scale: controller.value * 2,
//               child: child,
//             );
//           }),
//     );
//   }
// }