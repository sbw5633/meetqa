import 'package:flutter/material.dart';
import 'package:meetqa/common/model/person_model.dart';

import 'package:meetqa/question/component/unit/diary_concept/body_parts/body_left.dart';
import 'package:meetqa/question/component/unit/diary_concept/body_parts/body_mid.dart';
import 'package:meetqa/question/component/unit/diary_concept/body_parts/body_right.dart';
import 'package:meetqa/question/component/unit/diary_concept/bottom_parts/bottom_basic.dart';
import 'package:meetqa/question/model/question_model.dart';

class DiaryConcept extends StatelessWidget {
  final PersonModel asker;
  final PersonModel reply;
  final List<QuestionModel> questions;
  final List<LinearGradient> colors;
  final nextTurn;
  const DiaryConcept({
    Key? key,
    required this.asker,
    required this.reply,
    required this.questions,
    required this.colors,
    required this.nextTurn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //기종별 비율 맞추기 위한 높이/너비값 가져오기
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Expanded(
          flex: 3,
          child: _BodyContainer(
            questions: questions,
            colors: colors,
            asker: asker,
            reply: reply,
            nextTurn: nextTurn,
          ),
        ),
        Expanded(
            flex: 1,
            child: BottomBasic(
              screenHeight: screenHeight,
              screenWidth: screenWidth,
            )),
      ],
    );
  }
}

class _BodyContainer extends StatefulWidget {
  final PersonModel asker;
  final PersonModel reply;
  final List<QuestionModel> questions;
  final List<LinearGradient> colors;
  final nextTurn;
  const _BodyContainer({
    Key? key,
    required this.asker,
    required this.reply,
    required this.questions,
    required this.colors,
    required this.nextTurn,
  }) : super(key: key);

  @override
  State<_BodyContainer> createState() => __BodyContainerState();
}

class __BodyContainerState extends State<_BodyContainer> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          'assets/images/diary_temp_img.jpg',
          fit: BoxFit.fill,
          height: double.infinity,
        ),
        Row(
          children: [
            Expanded(flex: 1, child: BodyLeft()),
            Expanded(
              flex: 2,
              child: BodyMid(
                asker: widget.asker.name,
                reply: widget.reply.name,
              ),
            ),
            Expanded(
                flex: 1,
                child: BodyRight(
                  questions: widget.questions,
                  colors: widget.colors,
                  asker: widget.asker.name,
                  nextTurn: widget.nextTurn,
                )),
          ],
        )
      ],
    );
  }
}
