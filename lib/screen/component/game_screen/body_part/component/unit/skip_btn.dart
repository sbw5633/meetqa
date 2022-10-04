import 'package:flutter/material.dart';
import 'package:meetqa/common/const/path.dart';
import 'package:meetqa/screen/component/game_screen/body_part/component/unit/skip_alert.dart';

class SkipBtn extends StatefulWidget {
  final turnOver;
  const SkipBtn({
    Key? key,
    required this.turnOver,
  }) : super(key: key);

  @override
  State<SkipBtn> createState() => _SkipBtnState();
}

class _SkipBtnState extends State<SkipBtn> {
  int initLimitTime = 10;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: disCountLimitTime(initLimitTime),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return skipButton(
              snapshot.data == null ? initLimitTime : snapshot.data!);
        } else {
          return nextButton();
        }
      },
    );
  }

  Widget skipButton(int _leftTime) {
    return OutlinedButton(
        onPressed: () async {
          final resp = await showDialog(
              context: context,
              builder: ((context) {
                return SkipButtonAlert(
                  leftTime: _leftTime,
                );
              }));
          //alert 결과 받아서 다음턴 넘길지 결정
          if (resp) {
            print("resp: $resp");
            widget.turnOver();
          }
        },
        style: OutlinedButton.styleFrom(side: BorderSide.none),
        child: Image.asset(
          SKIP_BTN,
          fit: BoxFit.cover,
        ));
  }

  Widget nextButton() {
    return ElevatedButton(
        onPressed: widget.turnOver, child: const Text("next"));
  }

  Stream<int> disCountLimitTime(int limitTime) async* {
    int leftTime = limitTime;

    for (int i = 0; i < limitTime; i++) {
      await Future.delayed(const Duration(seconds: 1));

      yield --leftTime;
    }
  }
}
