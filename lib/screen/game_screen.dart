import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:meetqa/common/component/unit/app_bar_bg.dart';
import 'package:meetqa/common/component/will_pop_scope.dart';
import 'package:meetqa/question/component/unit/ball_bottle.dart';
import 'package:meetqa/common/component/chance_card.dart';
import 'package:meetqa/question/component/unit/question_ball.dart';
import 'package:meetqa/question/component/question_board.dart';
import 'package:meetqa/common/const/colors.dart';
import 'package:meetqa/common/const/const_no.dart';
import 'package:meetqa/common/const/size.dart';
import 'package:meetqa/common/const/user_id.dart';
import 'package:meetqa/question/model/category_card_model.dart';
import 'package:meetqa/question/model/question_model.dart';
import 'package:meetqa/screen/home_screen.dart';
import 'package:meetqa/common/manager/ad_manager.dart';
import 'package:meetqa/common/component/flutter_toast.dart';
import 'package:meetqa/common/manager/sign_manager.dart';

class GameScreen extends StatefulWidget {
  final String me;
  final String you;
  final askCate category;
  final List<QuestionModel> questions;
  GameScreen({
    Key? key,
    required this.me,
    required this.you,
    required this.category,
    required this.questions,
  }) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  // late AnimationController _controller;
  bool isBallsOpen = false;
  int reloadLimit = initReloadTimes;
  late List<QuestionModel> questions = widget.questions;
  late List<RadialGradient> colors = [];
  late String asker;
  late String respondent;
  static int turn = 1;

  DateTime? currentBackPressTime;

  bool isAni = false;

  @override
  initState() {
    if (turn % 2 == 1) {
      asker = widget.me;
      respondent = widget.you;
    } else {
      asker = widget.you;
      respondent = widget.me;
    }

    // _controller =
    //     AnimationController(vsync: this, duration: Duration(seconds: 2));

    // _controller.forward();
    // _controller.addListener(() {
    //   if (_controller.value < 0.5) {
    //     _controller.forward();
    //   } else if (_controller.value >= 1) {
    //     _controller.reverse();
    //   }
    // });

    shuffleData();

    List.generate(questions.length, (index) {
      colors.add(RadialGradient(
          colors: [RandomColor().rdColor(), RandomColor().rdColor()],
          focal: Alignment.centerLeft,
          tileMode: TileMode.clamp));
    });

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

    bool isTagSecret = true;

    return WillPopScope(
      onWillPop:
          OnWillPopController(wantExit: false, isAni: isAni).backCtlChange,
      child: Scaffold(
          backgroundColor: PRIMARY_COLOR,
          appBar: AppBar(
              flexibleSpace: appBarBG(),
              automaticallyImplyLeading: false,
              leading: IconButton(
                  onPressed: () {
                    if (isAni) {
                      flutterToast("잠시 후 다시 시도해주세요.");
                      return;
                    }

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => HomeScreen()),
                        ((route) => false));
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
                            await SignManager.signIn();
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
                          await SignManager.signOut();
                          setState(() {});
                        },
                        child: Text(
                          "로그아웃",
                          style: TextStyle(color: Colors.white),
                        ))
              ]),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  flex: 2,
                  child: _TopContainer(asker: asker, respondent: respondent)),
              Expanded(
                flex: 8,
                child: Stack(
                  children: [
                    !isBallsOpen
                        ? BallBottle(
                            category: widget.category.toString(),
                            questions: questions,
                            colors: colors,
                            onTapBall: onTapBall,
                          )

                        // MainBall(
                        //     controller: _controller,
                        //     onTap: onTapBall,
                        //   )
                        : ReLoadButton(
                            onPressed: onTapReLoad,
                            limitNo: reloadLimit,
                          ),
                    isBallsOpen
                        ? Stack(
                            children: list(),
                          )
                        : Container(),
                  ],
                ),
              ),
              Expanded(flex: 3, child: _BottomContainer())
            ],
          )),
    );
  }

  void nextTurn() {
    String tempVal = asker;
    asker = respondent;
    respondent = tempVal;
    reloadLimit = initReloadTimes;

    isBallsOpen = false;
    // _controller.forward();
    setState(() {});
  }

  void onTapReLoad() {
    reloadLimit--;
    setState(() {
      // _controller.forward();
      isBallsOpen = false;
      shuffleData();
    });
  }

  void onTapBall() {
    // _controller.reset();
    // _controller.stop();
    shuffleData();

    isAni = true;

    setState(() {
      isBallsOpen = true;
    });
  }

  void shuffleData() {
    questions.shuffle();
  }

  List<int> data = List.generate(6, (index) => index);

  List<Widget> list() {
    isAni = true;
    final double firstItemAngle = pi;
    final double lastItemAngle = pi;
    final double angleDiff = (firstItemAngle + lastItemAngle) / 6; //한 써클 원 갯수
    double currentAngle = firstItemAngle;

    //애니메이션 진행동안 다른동작 막기
    Future.delayed(Duration(seconds: 2), () {
      isAni = false;
      print("isAni: false");
    });

    return data.map((int index) {
      currentAngle += angleDiff;

      return QuestionBall(
        angle: currentAngle,
        index: index,
        radius: 125,
        question: questions[index],
        onTapQuestionBall: onTapQuetionBall,
      );
    }).toList();
  }

  //질문지 출력
  onTapQuetionBall(QuestionModel question) async {
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: ((context) {
          return QuestionBoard(
            question: question,
          );
        }));
    questions.remove(question);
    nextTurn();
  }
}

///...............
/// 큰공 <-> 작은공 (MainBall class)
///...............
// class MainBall extends StatelessWidget {
//   final AnimationController controller;
//   final GestureTapCallback onTap;
//   const MainBall({
//     Key? key,
//     required this.controller,
//     required this.onTap,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: AnimatedBuilder(
//           animation: controller,
//           child: GestureDetector(
//             onTap: onTap,
//             child: Container(
//                 decoration:
//                     BoxDecoration(shape: BoxShape.circle, color: ballColor),
//                 width: initBallSize,
//                 height: initBallSize,
//                 child: Center(
//                   child: Text("click!"),
//                 )),
//           ),
//           builder: (context, child) {
//             return Transform.scale(
//               scale: controller.value * 2,
//               child: child,
//             );
//           }),
//     );
//   }
// }

class ReLoadButton extends StatelessWidget {
  final VoidCallback onPressed;
  final int limitNo;
  const ReLoadButton({
    Key? key,
    required this.onPressed,
    required this.limitNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: waitCreate(),
        builder: ((context, snapshot) => Center(
              child: snapshot.connectionState == ConnectionState.done
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: limitNo > 0 ? onPressed : null,
                          child: Text("다시 섞기"),
                        ),
                        Text("남은 횟수: $limitNo"),
                      ],
                    )
                  : Container(),
            )));
  }

  Future<void> waitCreate() async {
    await Future.delayed(Duration(milliseconds: 1200));
  }
}

class _TopContainer extends StatelessWidget {
  final String asker;
  final String respondent;
  const _TopContainer({Key? key, required this.asker, required this.respondent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.white, PRIMARY_COLOR],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.2, 0.7],
          )),
          alignment: Alignment.bottomCenter,
          child: Text(
              "$asker 님이 $respondent 님에게 질문할 차례입니다. \n$asker 님이 질문을 선택해주세요!")),
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
