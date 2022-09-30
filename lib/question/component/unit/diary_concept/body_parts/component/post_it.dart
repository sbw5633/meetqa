import 'package:flutter/material.dart';
import 'package:meetqa/common/util/data_utils.dart';
import 'package:meetqa/question/component/question_board.dart';
import 'package:meetqa/question/component/unit/diary_concept/body_parts/in_question/question_frame.dart';
import 'package:meetqa/question/model/question_model.dart';

class PostIt extends StatefulWidget {
  final String asker;
  final QuestionModel question;
  final LinearGradient color;
  final nextTurn;
  const PostIt({
    Key? key,
    required this.question,
    required this.color,
    required this.asker,
    required this.nextTurn,
  }) : super(key: key);

  @override
  State<PostIt> createState() => _PostItState();
}

class _PostItState extends State<PostIt> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // showDialog(
        //     context: context,
        //     builder: (_) => QuestionBoard(question: widget.question));
        showQuestPage();
      },
      child: Container(
        width: double.infinity,
        margin:
            EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.02),
        height: 50,
        decoration: BoxDecoration(gradient: widget.color),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DataUtils().changeDeepToIcon(widget.question.deep),
                  DataUtils().changeThemeToIcon(widget.question.theme),
                ]),
            Text(
              widget.question.tag.join(', '),
            ),
          ],
        ),
      ),
    );
  }

  void showQuestPage() async {
    await showDialog(
        barrierDismissible: true,
        context: context,
        builder: ((context) {
          return Dialog(
            backgroundColor: Colors.pink.shade100,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.7,
              child: QuestionFrame(
                asker: widget.asker,
                question: widget.question,
              ),
            ),
          );
        }));

    widget.nextTurn(widget.question);
  }
}
