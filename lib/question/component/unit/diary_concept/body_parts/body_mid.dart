import 'package:flutter/material.dart';

class BodyMid extends StatelessWidget {
  final String asker;
  final String reply;
  const BodyMid({
    Key? key,
    required this.asker,
    required this.reply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow.withOpacity(0.1),
      child: Column(
        children: [
          SizedBox(
            height: 32,
          ),
          Text(
            "$asker 님이 질문할 차례입니다.",
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                backgroundColor: Colors.white),
          ),
        ],
      ),
    );
  }
}
