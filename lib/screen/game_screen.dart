import 'package:flutter/material.dart';
import 'package:flutter_keyboard_size/flutter_keyboard_size.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meetqa/common/component/unit/app_bar_bg.dart';
import 'package:meetqa/common/component/will_pop_scope.dart';
import 'package:meetqa/common/const/path.dart';
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
import 'package:meetqa/screen/component/game_screen/appbar_widgets.dart';
import 'package:meetqa/screen/component/game_screen/part_body.dart';

class GameScreen extends StatefulWidget {
  final String category;
  final List<QuestionModel> questions;

  const GameScreen({
    Key? key,
    required this.category,
    required this.questions,
  }) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  // late AnimationController _controller;
  late List<QuestionModel> questions = widget.questions;
  late List<LinearGradient> colors = [];
  static int turn = 1;

  DateTime? currentBackPressTime;

  int reloadLimit = 1;

  @override
  initState() {
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
    debugPrint("nowUser? $nowUser");
    debugPrint("question갯수: ${questions.length}");

    // bool isTagSecret = true;

    int defaultSelNo = 5;
    int nextSelNo =
        questions.length >= defaultSelNo ? defaultSelNo : questions.length;

    // 다음 선택지로 나올 question({nextSelNo} 개)
    List<QuestionModel> nextQuestions =
        questions.getRange(0, nextSelNo).toList();

    return WillPopScope(
      onWillPop: OnWillPopController(wantExit: false).backCtlChange,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0, left: 2, right: 2),
                  child: CustomAppBar(),
                )),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 4, left: 2, right: 2),
                    child: Game_Body(
                      questions: nextQuestions,
                      cate: widget.category,
                      turn: turn,
                      onTapReLoad: onTapReLoad,
                      nextTurn: nextTurn,
                    ),
                  ),
                  // goDiaryConcept(questions: nextQuestions),
                  // goBallConcept(),
                ),
                const _BottomContainer(),
              ],
            )),
      ),
    );
  }

  void onTapReLoad() {
    if (reloadLimit <= 0) {
      flutterToast("이번 턴에는 더 이상 다시 불러올 수 없습니다.");
      return;
    }
    reloadLimit--;
    setState(() {
      // _controller.forward();
      shuffleData();
    });
  }

  void onTapBall() {
    // _controller.reset();
    // _controller.stop();
    shuffleData();

    setState(() {});
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
    turn++;

    reloadLimit = initReloadTimes;

    // _controller.forward();
    setState(() {});
  }

  // Widget goBallConcept() {
  //   return BallBottleConcept(
  //     questionTime: questionTime,
  //     category: widget.category,
  //     questions: questions,
  //     colors: colors,
  //     onTapBall: onTapBall,
  //     onTapReLoad: onTapReLoad,
  //     reloadLimit: reloadLimit,
  //     asker: asker,
  //     respondent: respondent,
  //     nextTurn: nextTurn,
  //   );
  // }

  // Widget goDiaryConcept({required List<QuestionModel> questions}) {
  //   return DiaryConcept(
  //     asker: asker,
  //     reply: respondent,
  //     questions: questions,
  //     colors: colors,
  //     nextTurn: nextTurn,
  //   );
  // }
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
