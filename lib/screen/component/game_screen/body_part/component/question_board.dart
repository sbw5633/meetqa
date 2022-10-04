import 'package:flutter/material.dart';
import 'package:meetqa/common/const/path.dart';
import 'package:meetqa/common/util/data_utils.dart';
import 'package:meetqa/question/model/question_model.dart';
import 'package:meetqa/screen/component/game_screen/body_part/component/unit/skip_btn.dart';

class QuestionBoard extends StatelessWidget {
  final String asker;
  final QuestionModel question;
  final nextTurn;
  const QuestionBoard({
    Key? key,
    required this.asker,
    required this.question,
    required this.nextTurn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          // width: 300,
          // height: 100,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                QUESTION_BOX,
              ),
              fit: BoxFit.fill,
            ),
          ),
          child:
              _PartData(asker: asker, question: question, nextTurn: nextTurn),
        ),
      ],
    );
  }
}

class _PartData extends StatelessWidget {
  final String asker;
  final QuestionModel question;
  final nextTurn;
  _PartData({
    Key? key,
    required this.asker,
    required this.question,
    required this.nextTurn,
  }) : super(key: key);

  TextStyle ts = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, left: 16, right: 16, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "$asker (이)의 질문",
                style: ts,
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                question.asking,
                style: ts.copyWith(fontWeight: FontWeight.normal),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DataUtils().changeDeepToIcon(question.deep),
              SkipBtn(
                turnOver: () => nextTurn(question),
              ),
            ],
          )
        ],
      ),
    );
  }
}
