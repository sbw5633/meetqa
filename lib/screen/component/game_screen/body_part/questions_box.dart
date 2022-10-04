import 'package:flutter/material.dart';
import 'package:meetqa/common/const/path.dart';
import 'package:meetqa/common/const/user_info.dart';
import 'package:meetqa/question/model/question_model.dart';
import 'package:meetqa/screen/component/game_screen/body_part/component/question_board.dart';
import 'package:meetqa/screen/component/game_screen/body_part/component/question_card.dart';

class QuestionsBox extends StatefulWidget {
  final List<QuestionModel> questions;
  final int turn;
  final onTapReLoad;
  final nextTurn;
  QuestionsBox({
    Key? key,
    required this.questions,
    required this.turn,
    required this.onTapReLoad,
    required this.nextTurn,
  }) : super(key: key);

  @override
  State<QuestionsBox> createState() => _QuestionsBoxState();
}

class _QuestionsBoxState extends State<QuestionsBox> {
  //questionBoard 표시용
  bool onTapCard = false;

  QuestionModel? question;

  @override
  Widget build(BuildContext context) {
    String asker = widget.turn % 2 == 1 ? user[0].name : user[1].name;

    double paddingWidth = MediaQuery.of(context).size.width * 0.05;
    return Padding(
      padding: EdgeInsets.only(
          right: paddingWidth, left: paddingWidth, bottom: paddingWidth * 0.5),
      child: onTapCard == true && question != null
          ? QuestionBoard(
              asker: asker,
              question: question!,
              nextTurn: onTapNextTurn,
            )
          //질문 선택하면 questionBoard 표시, 선택단계에서는 아래 QuestionCard 표시
          : Container(
              decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade200),
              child: Column(children: [
                _top(asker),
                Expanded(
                  child: ListView.separated(
                      itemBuilder: (ctx, idx) => QuestionCard(
                          question: widget.questions[idx],
                          onTapCard: onTapQuestionCard),
                      separatorBuilder: ((context, index) => SizedBox(
                            height: 16,
                          )),
                      itemCount: widget.questions.length),
                )
              ]),
            ),
    );
  }

  void onTapNextTurn(QuestionModel question) {
    print("oh: ${question.asking}");
    this.question = null;
    onTapCard = false;
    widget.nextTurn(question);
  }

  void onTapQuestionCard(QuestionModel asking) {
    question = asking;
    setState(() {
      onTapCard = true;
    });
  }

  Widget _top(String asker) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$asker 님이 질문을 선택할 차례에요.",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          InkWell(onTap: widget.onTapReLoad, child: Image.asset(REFRESH_ICON)),
        ],
      ),
    );
  }
}
