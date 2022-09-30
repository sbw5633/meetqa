import 'package:flutter/material.dart';
import 'package:meetqa/question/component/unit/diary_concept/body_parts/component/post_it.dart';
import 'package:meetqa/question/model/question_model.dart';

class BodyRight extends StatelessWidget {
  final String asker;
  final List<QuestionModel> questions;
  final List<LinearGradient> colors;
  final nextTurn;
  const BodyRight({
    Key? key,
    required this.asker,
    required this.questions,
    required this.colors,
    required this.nextTurn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int i = 0;
    return Container(
      color: Colors.blue.withOpacity(0.1),
      child: Column(
        children: questions.map((question) {
          return Column(
            children: [
              SizedBox(
                height: i == 0 ? 32.0 : 0,
              ),
              PostIt(
                question: question,
                color: colors[i++],
                asker: asker,
                nextTurn: nextTurn,
              ),
              SizedBox(
                height: i == questions.length ? 0 : 8.0,
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
