import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:meetqa/common/component/unit/app_bar_bg.dart';
import 'package:meetqa/common/component/will_pop_scope.dart';
import 'package:meetqa/common/model/person_model.dart';
import 'package:meetqa/common/const/colors.dart';
import 'package:meetqa/common/const/const_no.dart';

import 'package:meetqa/common/const/user_info.dart';
import 'package:meetqa/question/component/game_body_concept/ball_bottle_concept.dart';
import 'package:meetqa/question/component/game_body_concept/diary_concept.dart';
import 'package:meetqa/question/model/question_model.dart';
import 'package:meetqa/common/manager/ad_manager.dart';
import 'package:meetqa/common/component/flutter_toast.dart';
import 'package:meetqa/common/manager/sign_manager.dart';

class GameScreen extends StatefulWidget {
  final String category;
  final List<QuestionModel> questions;

  const GameScreen({
    Key? key,
    required this.category,
    required this.questions,
  }) : super(key: key);

  @override
  State<GameScreen> createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  // late AnimationController _controller;
  bool questionTime = false;
  late List<QuestionModel> questions = widget.questions;
  late List<LinearGradient> colors = [];
  static int turn = 1;

  DateTime? currentBackPressTime;

  int reloadLimit = 1;

  late PersonModel asker;
  late PersonModel respondent;

  static bool isAni = false;

  @override
  initState() {
    asker = user[turn ~/ 2];
    respondent = user[turn ~/ 2 + 1];

    shuffleData();

    super.initState();
  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("currentUser? $currentUser");
    debugPrint("question갯수: ${questions.length}");

    // bool isTagSecret = true;

    int defaultSelNo = 5;
    int nextSelNo =
        questions.length >= defaultSelNo ? defaultSelNo : questions.length;

    // 다음 선택지로 나올 question({nextSelNo} 개)
    List<QuestionModel> nextQuestions = questions.getRange(0, 5).toList();

    return WillPopScope(
      onWillPop:
          OnWillPopController(wantExit: false, isAni: isAni).backCtlChange,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: PRIMARY_COLOR,
            appBar: _AppBar(),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  // flex: 10,
                  child: goDiaryConcept(questions: nextQuestions),
                  // goBallConcept(),
                ),
                const _BottomContainer(),
              ],
            )),
      ),
    );
  }

  void onTapReLoad() {
    reloadLimit--;
    setState(() {
      // _controller.forward();
      questionTime = false;
      shuffleData();
    });
  }

  void onTapBall() {
    // _controller.reset();
    // _controller.stop();
    shuffleData();

    isAni = true;

    setState(() {
      questionTime = true;
    });
  }

  void shuffleData() {
    // print("is shuffle");
    questions.shuffle();
    settingColors();
  }

  void settingColors() {
    colors.clear();
    List.generate(questions.length, (index) {
      colors.add(LinearGradient(
          colors: [RandomColor().rdColor(), RandomColor().rdColor()],
          tileMode: TileMode.clamp));
    });
  }

  void nextTurn(QuestionModel question) {
    // print("remove Question : ${question.asking}");

    questions.remove(question);
    shuffleData();
    PersonModel tempVal = asker;
    asker = respondent;
    respondent = tempVal;
    reloadLimit = initReloadTimes;

    questionTime = false;
    // _controller.forward();
    setState(() {});
  }

  AppBar _AppBar() {
    return AppBar(
      flexibleSpace: appBarBG(),
      automaticallyImplyLeading: false,
      leading: IconButton(
          onPressed: () {
            if (isAni) {
              flutterToast("잠시 후 다시 시도해주세요.");
              return;
            }

            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.home,
            size: 30,
          )),
      actions: [
        currentUser == null
            ? OutlinedButton(
                onPressed: () async {
                  try {
                    await SignManager().signIn();
                    if (currentUser != null) {
                      setState(() {});
                    } else {
                      flutterToast("로그인에 실패했습니다.");
                    }
                  } catch (e) {
                    flutterToast("로그인에 실패했습니다.");
                  }
                },
                child: Text(
                  "계정 연동",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : OutlinedButton(
                onPressed: () async {
                  await SignManager().signOut();
                  setState(() {});
                },
                child: Text(
                  "로그아웃",
                  style: TextStyle(color: Colors.white),
                ))
      ],
      title: Image.asset('assets/images/logo/logo_ho.png'),
    );
  }

  Widget goBallConcept() {
    return BallBottleConcept(
      questionTime: questionTime,
      category: widget.category,
      questions: questions,
      colors: colors,
      onTapBall: onTapBall,
      onTapReLoad: onTapReLoad,
      reloadLimit: reloadLimit,
      asker: asker,
      respondent: respondent,
      nextTurn: nextTurn,
    );
  }

  Widget goDiaryConcept({required List<QuestionModel> questions}) {
    return DiaryConcept(
      asker: asker,
      reply: respondent,
      questions: questions,
      colors: colors,
      nextTurn: nextTurn,
    );
  }
}

class _BottomContainer extends StatefulWidget {
  const _BottomContainer({Key? key}) : super(key: key);

  @override
  State<_BottomContainer> createState() => _BottomContainerState();
}

class _BottomContainerState extends State<_BottomContainer> {
  //........
  //광고 관련
  BannerAd? bannerAd;
  //........

  @override
  void dispose() {
    bannerAd?.dispose();
    super.dispose();
  }

  Future<dynamic> loadBannerAd() async {
    // //하단 배너 광고 호출
    bannerAd = await AdManager().createBanner(context);
    bannerAd!.load();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // ElevatedButton(
        //   onPressed: () async {
        //     // print("chance!");
        //     // await showDialog(
        //     //     context: context,
        //     //     builder: ((context) {
        //     //       return ChanceCard();
        //     //     }));
        //     // setState(() {
        //     //   print("ab");fedf
        //     // });
        //   },
        //   child: Text("질문자 찬스"),
        // ),
        FutureBuilder<dynamic>(
            future: loadBannerAd(),
            builder: (context, snapshot) {
              if (snapshot.data == false ||
                  snapshot.connectionState != ConnectionState.done) {
                return Container();
              } else {
                return SizedBox(
                  height: 80,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (snapshot.data == true && bannerAd != null)
                        Container(
                          color: Colors.black,
                          width: bannerAd!.size.width.toDouble(),
                          height: bannerAd!.size.height.toDouble(),
                          child: AdWidget(ad: bannerAd!),
                        )
                    ],
                  ),
                );
              }
            })
      ],
    );
  }
}
