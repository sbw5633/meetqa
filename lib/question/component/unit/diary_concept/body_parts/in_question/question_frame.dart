import 'package:flutter/material.dart';
import 'package:meetqa/common/component/will_pop_scope.dart';
import 'package:meetqa/question/component/unit/diary_concept/body_parts/in_question/parts/question_body.dart';
import 'package:meetqa/question/component/unit/diary_concept/body_parts/in_question/parts/question_bottom.dart';
import 'package:meetqa/question/component/unit/diary_concept/body_parts/in_question/parts/question_head.dart';
import 'package:meetqa/question/model/question_model.dart';

class QuestionFrame extends StatelessWidget {
  final String asker;
  final QuestionModel question;
  const QuestionFrame({
    Key? key,
    required this.asker,
    required this.question,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: OnWillPopController(wantExit: true).backCtlChange,
        child: Column(
          children: [
            Expanded(flex: 1, child: QuestionHead()),
            Expanded(
                flex: 2,
                child: QuestionBody(
                  asker: asker,
                  question: question,
                )),
            Expanded(flex: 1, child: QuestionBottom()),
          ],
        ));
  }
}
