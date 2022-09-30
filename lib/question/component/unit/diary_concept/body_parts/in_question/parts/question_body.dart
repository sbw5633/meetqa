import 'package:flutter/material.dart';
import 'package:meetqa/common/util/data_utils.dart';
import 'package:meetqa/question/model/question_model.dart';

class QuestionBody extends StatelessWidget {
  final String asker;
  final QuestionModel question;

  const QuestionBody({
    Key? key,
    required this.asker,
    required this.question,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.pinkAccent,
      child: Stack(children: [
        Opacity(
          opacity: 0.9,
          child: DataUtils.getBgImage(
            theme: question.theme,
            height: double.infinity,
            width: double.infinity,
          ),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          _partTheme(theme: question.theme),
          _partAsker(asker: asker),
          _partDeep(deep: question.deep),
          _partTag(tag: question.tag),
          _partAsk(ask: question.asking)
        ]),
      ]),
    );
  }

  Widget _partTheme({required QuestionTheme theme}) {
    return Row(
      children: [
        Text("테마: ${theme.name}"),
        DataUtils().changeThemeToIcon(theme),
      ],
    );
  }

  Widget _partAsker({required String asker}) {
    return Text("질문자 $asker");
  }

  Widget _partDeep({required int deep}) {
    return DataUtils().changeDeepToIcon(deep);
  }

  Widget _partAsk({required String ask}) {
    return Text(ask);
  }

  Widget _partTag({required List tag}) {
    return Text(tag.join(', '));
  }
}
