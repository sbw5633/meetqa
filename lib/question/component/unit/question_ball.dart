import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meetqa/question/model/question_model.dart';
import 'package:meetqa/common/util/data_utils.dart';

class QuestionBall extends StatefulWidget {
  final double angle;
  final int index;
  final double radius;
  final QuestionModel question;
  final onTapQuestionBall;
  const QuestionBall({
    Key? key,
    required this.angle,
    required this.index,
    required this.radius,
    required this.question,
    required this.onTapQuestionBall,
  }) : super(key: key);

  @override
  State<QuestionBall> createState() => _QuestionBallState();
}

class _QuestionBallState extends State<QuestionBall>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late QuestionModel question;

  @override
  initState() {
    question = widget.question;
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));

    Future.delayed(Duration(milliseconds: widget.index * 200), () {
      _controller.forward();
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ballColor = RadialGradient(colors: [
      rdColor().withOpacity(0.4),
      rdColor(),
    ], focal: Alignment.centerLeft, tileMode: TileMode.clamp);

    final x = cos(widget.angle) * widget.radius;
    final y = sin(widget.angle) * widget.radius;

    final ballSize = MediaQuery.of(context).size.width / 3 - 1;

    return AnimatedBuilder(
      child: Center(
        child: BuiltBall(
          x: x,
          y: y,
          ballSize: ballSize,
          ballColor: ballColor,
          question: question,
          onTap: widget.onTapQuestionBall,
        ),
      ),
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _controller.value,
          child: child,
        );
      },
    );
  }

  Color rdColor() {
    final int rdColorR = Random().nextInt(255);
    final int rdColorG = Random().nextInt(255);
    final int rdColorB = Random().nextInt(255);

    final Color color = Color.fromRGBO(rdColorR, rdColorG, rdColorB, 1.0);

    return color;
  }
}

class BuiltBall extends StatelessWidget {
  final double x;
  final double y;
  final double ballSize;
  final RadialGradient ballColor;
  final QuestionModel question;
  final onTap;
  const BuiltBall({
    Key? key,
    required this.x,
    required this.y,
    required this.ballColor,
    required this.ballSize,
    required this.question,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translationValues(x, y, 0.0),
      child: Container(
          decoration: BoxDecoration(
            gradient: ballColor,
            shape: BoxShape.circle,
            // border: Border.all(color: Colors.white),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5,
                spreadRadius: 3,
                offset: Offset(3, 3),
              )
            ],
          ),
          width: ballSize,
          height: ballSize,
          child: InkWell(
            borderRadius: BorderRadius.circular(500),
            onTap: () => onTap(question),
            child: questionContainer(),
          )),
    );
  }

  Widget questionContainer() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Text(DataUtils.getStringFromThemeCode(question.theme)),
              DataUtils.changeDeepToIcon(question.deep),
            ],
          ),
          SizedBox(
            height: 14,
          ),
          printTagText(question.tag),
        ],
      ),
    );
  }

  Widget printTagText(List tag) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
          tag.length,
          (index) => Padding(
                padding: index != tag.length
                    ? const EdgeInsets.only(right: 3.0)
                    : EdgeInsets.zero,
                child: Text(tag[index]),
              )),
    );
  }
}
