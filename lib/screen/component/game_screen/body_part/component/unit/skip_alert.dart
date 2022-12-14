import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meetqa/common/component/flutter_toast.dart';
import 'package:meetqa/common/const/ad_id.dart';
import 'package:meetqa/common/const/user_info.dart';
import 'package:meetqa/common/manager/sign_manager.dart';
import 'package:meetqa/screen/component/game_screen/appbar_widgets.dart';
import 'package:meetqa/screen/component/game_screen/body_part/component/unit/ad_btn.dart';
import 'package:meetqa/screen/component/game_screen/body_part/component/unit/login_pass_btn.dart';

class SkipButtonAlert extends StatefulWidget {
  final int leftTime;
  const SkipButtonAlert({
    Key? key,
    required this.leftTime,
  }) : super(key: key);

  @override
  State<SkipButtonAlert> createState() => _SkipButtonAlertState();
}

class _SkipButtonAlertState extends State<SkipButtonAlert> {
  final box = Hive.box("UserData");

  int passTicket = 0;

  @override
  void initState() {
    super.initState();

    _leftTime = widget.leftTime;
  }

  void refleshTicket() {
    if (nowUser != null) {
      setState(() {
        passTicket = box.get("passTicket");
      });
    }
  }

  static late int _leftTime;
  Stream<int> turnCountDown(int count) async* {
    // _leftTime = leftTime;
    for (int i = 0; i < count; i++) {
      await Future.delayed(const Duration(seconds: 1));
      if (--_leftTime <= 0) _leftTime = 0;
      yield _leftTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    refleshTicket();

    return StreamBuilder<int>(
        stream: turnCountDown(_leftTime),
        builder: (context, snapshot) {
          int _t = snapshot.data == null ? widget.leftTime : snapshot.data!;
          return AlertDialog(
            scrollable: true,
            title: Text(
              nowUser == null ? "guest사용자입니다." : "보유중인 패스권: $passTicket개",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            content: snapshot.hasData && snapshot.data! <= 0
                ? contentText(
                    text: "다음 턴으로 넘어갈 수 있습니다. \n진행하시려면 Next버튼을 눌러주세요.")
                : nowUser == null
                    ? Column(
                        children: [
                          contentText(
                            text: "$_t초 뒤 턴이 종료됩니다.",
                          ),
                          contentText(
                            text: "광고를 시청하고 즉시 턴을 넘길까요?",
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          contentText(
                              text: "로그인 시 패스권을 획득할 수 있습니다.", fontSize: 14),
                        ],
                      )
                    : Column(
                        children: [
                          contentText(
                            text: "$_t초 뒤 턴이 종료됩니다.",
                          ),
                          contentText(text: "패스권을 사용할까요?"),
                        ],
                      ),
            actions: [
              //남은시간 경과되면 다음 넘어갈수있게 버튼 변경

              _inSkipActionButton(
                  snapshot.hasData && snapshot.data! <= 0 ? true : false),
            ],
          );
        });
  }

  Widget _inSkipActionButton(bool isDone) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        isDone
            ? Container()
            : AdButton(
                offerReward: offerReward,
              ), //광고 보기 버튼
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          LoginOrPassButton(
            isDone: isDone,
            isOverTurn: isOverTurn,
            onTapUseTicket: onTapUseTicket,
            passTicket: passTicket,
            onPressed: isLogined,
          ), //로그인 / 패스 버튼
          TextButton(
              onPressed: () {
                // CustomAppBar.of(context)!.isReflesh();

                Navigator.of(context).pop(false);
                // isLogined();
              },
              child: const Text("취소")), //취소버튼
        ])
      ],
    );
  }

  void isLogined() {
    CustomAppBar.of(context)?.isReflesh();
    print(CustomAppBar.of(context));

    setState(() {});
  }

  Text contentText({required String text, double fontSize = 16}) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize),
      textAlign: TextAlign.center,
    );
  }

  void updatePassTicket({required int ticket}) {
    box.put("passTicket", ticket);
  }

  void isOverTurn() {
    Navigator.of(context).pop(true);
  }

  void offerReward() {
    if (nowUser != null && nowUser!.passTicket < 10) {
      passTicket++;

      updatePassTicket(ticket: passTicket);

      flutterToast("Pass Ticket이 지급되었습니다.");
    }
    isOverTurn();
  }

  void onTapUseTicket() {
    if (passTicket <= 0) {
      flutterToast("보유중인 패스권이 없습니다.");
    } else {
      passTicket--;
      updatePassTicket(ticket: passTicket);
      isOverTurn();
    }
  }
}
