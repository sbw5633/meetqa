import 'package:flutter/material.dart';
import 'package:meetqa/common/const/path.dart';
import 'package:meetqa/common/const/user_info.dart';
import 'package:meetqa/common/model/person_model.dart';
import 'package:meetqa/question/model/category_card_model.dart';
import 'package:meetqa/question/model/question_model.dart';
import 'package:meetqa/screen/component/game_screen/body_part/questions_box.dart';
import 'package:meetqa/screen/component/game_screen/body_part/user_card.dart';

class Game_Body extends StatefulWidget {
  final String cate;
  final List<QuestionModel> questions;
  final int turn;
  final onTapReLoad;
  final nextTurn;
  const Game_Body({
    Key? key,
    required this.cate,
    required this.questions,
    required this.turn,
    required this.onTapReLoad,
    required this.nextTurn,
  }) : super(key: key);

  @override
  State<Game_Body> createState() => _Game_BodyState();
}

class _Game_BodyState extends State<Game_Body> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(border: Border.all()),
      child: Column(children: [
        Expanded(
          flex: 4,
          child: _PartTop(
            cate: widget.cate,
            turn: widget.turn,
          ),
        ),
        Expanded(
          flex: 5,
          child: QuestionsBox(
              questions: widget.questions,
              turn: widget.turn,
              onTapReLoad: widget.onTapReLoad,
              nextTurn: onTapNextTurn),
        )
      ]),
    );
  }

  void onTapNextTurn(QuestionModel question) {
    setState(() {
      widget.nextTurn(question);
    });
  }
}

class _PartTop extends StatelessWidget {
  final String cate;
  final int turn;
  const _PartTop({Key? key, required this.cate, required this.turn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //카테고리 표시 영역
        Expanded(
            flex: 1,
            child: Center(
                child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.black, width: 2))),
                    child: Text(
                      CategoryCardModel.parstCateToString(cate),
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    )))),
        //캐릭터박스 표시영역
        Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  user.length,
                  (index) => Padding(
                        padding: index == 0
                            ? EdgeInsets.only(
                                right: MediaQuery.of(context).size.width * 0.1)
                            : EdgeInsets.zero,
                        child: UserCard(
                            user: user[index], isAsker: turn % 2 != index % 2),
                      )),
            )),
      ],
    );
  }
}
