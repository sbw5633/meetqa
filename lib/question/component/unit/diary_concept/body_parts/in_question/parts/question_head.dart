import 'package:flutter/material.dart';
import 'package:meetqa/question/component/unit/diary_concept/body_parts/in_question/component/aleart_skip_button.dart';

class QuestionHead extends StatefulWidget {
  const QuestionHead({Key? key}) : super(key: key);

  @override
  State<QuestionHead> createState() => _QuestionHeadState();
}

class _QuestionHeadState extends State<QuestionHead> {
  TextStyle timeTs = TextStyle(
    fontSize: 20,
    color: Colors.black,
  );

  int initLimitTime = 10;

  Stream<int> questionTimer(int limitTime) async* {
    int leftTime = limitTime;

    for (int i = 0; i < limitTime; i++) {
      await Future.delayed(const Duration(seconds: 1));

      yield --leftTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.shade100,
      child: StreamBuilder<int>(
          stream: questionTimer(initLimitTime),
          builder: (context, snapshot) {
            return Row(
              children: [
                Expanded(flex: 1, child: _partLeft()),
                Expanded(
                  flex: 2,
                  child: _partTimer(snapshot: snapshot),
                ),
                Expanded(
                    flex: 1,
                    child: snapshot.connectionState != ConnectionState.done
                        ? skipButton()
                        : nextButton())
              ],
            );
          }),
    );
  }

  Widget _partLeft() {
    return Container();
  }

  Widget _partTimer({required AsyncSnapshot snapshot}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "답변 시간",
          style: timeTs,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 5,
        ),
        Text(
          snapshot.hasData ? "${snapshot.data}" : "$initLimitTime",
          textAlign: TextAlign.center,
          style: timeTs,
        ),
      ],
    );
  }

  Widget skipButton() {
    return OutlinedButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: ((context) {
                return const AlertSkipButton();
              }));
        },
        style: OutlinedButton.styleFrom(side: BorderSide.none),
        child: Image.asset(
          'assets/images/icon/skip_button.png',
          scale: 7,
          fit: BoxFit.cover,
        ));
  }

  Widget nextButton() {
    return ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text("next"));
  }
}
