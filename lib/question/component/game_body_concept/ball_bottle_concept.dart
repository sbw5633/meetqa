import 'dart:math';

import 'package:flutter/material.dart';
import 'package:meetqa/common/const/colors.dart';
import 'package:meetqa/common/const/user_info.dart';
import 'package:meetqa/common/model/person_model.dart';
import 'package:meetqa/question/component/question_board.dart';
import 'package:meetqa/question/component/reload_button.dart';
import 'package:meetqa/question/component/unit/ball_bottle.dart';
import 'package:meetqa/question/component/unit/question_ball.dart';
import 'package:meetqa/question/model/question_model.dart';
import 'package:meetqa/screen/game_screen.dart';

class BallBottleConcept extends StatefulWidget {
  final bool questionTime;
  final String category;
  final List<QuestionModel> questions;
  final colors;
  final onTapBall;
  final onTapReLoad;
  final reloadLimit;

  final nextTurn;

  final PersonModel asker;
  final PersonModel respondent;
  const BallBottleConcept({
    Key? key,
    required this.questionTime,
    required this.category,
    required this.questions,
    required this.colors,
    required this.onTapBall,
    required this.onTapReLoad,
    required this.reloadLimit,
    required this.asker,
    required this.respondent,
    required this.nextTurn,
  }) : super(key: key);

  @override
  State<BallBottleConcept> createState() => _BallBottleConceptState();
}

class _BallBottleConceptState extends State<BallBottleConcept> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 2,
            child: _TopContainer(
                asker: widget.asker, respondent: widget.respondent)),
        Expanded(
            flex: 8,
            child: Stack(
              children: [
                !widget.questionTime
                    ? BallBottle(
                        category: widget.category,
                        questions: widget.questions,
                        colors: widget.colors,
                        onTapBall: widget.onTapBall,
                      )

                    // MainBall(
                    //     controller: _controller,
                    //     onTap: onTapBall,
                    //   )
                    : ReLoadButton(
                        onPressed: widget.onTapReLoad,
                        limitNo: widget.reloadLimit,
                      ),
                widget.questionTime
                    ? Stack(
                        children: list(),
                      )
                    : Container(),
              ],
            ))
      ],
    );
  }

  List<int> data = List.generate(6, (index) => index);

  List<Widget> list() {
    const double firstItemAngle = pi;
    const double lastItemAngle = pi;
    const double angleDiff = (firstItemAngle + lastItemAngle) / 6; //??? ?????? ??? ??????
    double currentAngle = firstItemAngle;

    //??????????????? ???????????? ???????????? ??????
    Future.delayed(Duration(seconds: 2), () {
      print("isAni: false");
    });

    return data.map((int index) {
      currentAngle += angleDiff;

      return QuestionBall(
        angle: currentAngle,
        index: index,
        radius: 125,
        question: widget.questions[index],
        onTapQuestionBall: onTapQuetionBall,
      );
    }).toList();
  }

  //????????? ??????
  onTapQuetionBall(
    QuestionModel question,
  ) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) {
          return QuestionBoard(
            question: question,
          );
        }));
    widget.questions.remove(question);
    widget.nextTurn();
  }
}

class _TopContainer extends StatelessWidget {
  final PersonModel asker;
  final PersonModel respondent;
  const _TopContainer({Key? key, required this.asker, required this.respondent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.white, PRIMARY_COLOR],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.2, 0.7],
          )),
          alignment: Alignment.bottomCenter,
          child: Text(
              "${asker.name} ?????? ${respondent.name} ????????? ????????? ???????????????. \n${asker.name} ?????? ????????? ??????????????????!")),
    );
  }
}
