import 'package:flutter/material.dart';
import 'package:meetqa/common/util/data_utils.dart';
import 'package:meetqa/question/model/question_model.dart';

class QuestionCard extends StatelessWidget {
  final QuestionModel question;
  final onTapCard;
  const QuestionCard({
    Key? key,
    required this.question,
    required this.onTapCard,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTapCard(question),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        height: 80,
        decoration: BoxDecoration(color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(DataUtils.getStringFromThemeCode(question.theme)),
              DataUtils().changeDeepToIcon(question.deep),
            ],
          ),
        ),
      ),
    );
  }
}
