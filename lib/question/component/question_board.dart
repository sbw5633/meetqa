import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:meetqa/common/component/will_pop_scope.dart';
import 'package:meetqa/common/const/ad_id.dart';
import 'package:meetqa/common/const/user_id.dart';
import 'package:meetqa/question/model/question_model.dart';
import 'package:meetqa/common/util/data_utils.dart';
import 'package:meetqa/common/manager/firebase_manager.dart';
import 'package:meetqa/common/component/flutter_toast.dart';
import 'package:meetqa/common/manager/sign_manager.dart';

class QuestionBoard extends StatelessWidget {
  final QuestionModel question;

  QuestionBoard({
    Key? key,
    required this.question,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle titleTs = TextStyle(
        fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white);
    TextStyle descTs = TextStyle(
      fontFamily: 'SingleDay',
      fontSize: 30,
      color: Colors.amber[50],
    );
    TextStyle timeTs = TextStyle(
      fontSize: 20,
      color: Colors.teal.shade50,
    );

    int initLimitTime = 100;

    return WillPopScope(
      onWillPop: OnWillPopController(wantExit: true).backCtlChange,
      child: StreamBuilder<int>(
          stream: disCountLimitTime(initLimitTime),
          builder: (context, snapshot) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.all(10),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: <Widget>[
                        Opacity(
                          opacity: 0.9,
                          child: DataUtils.getBgImage(
                            theme: question.theme,
                            height: double.infinity,
                            width: double.infinity,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                          ),
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                          child: Column(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Expanded(child: Container()),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("답변 시간", style: timeTs),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            snapshot.hasData
                                                ? "${snapshot.data}"
                                                : "$initLimitTime",
                                            textAlign: TextAlign.center,
                                            style: timeTs,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        child: snapshot.connectionState !=
                                                ConnectionState.done
                                            ? skipButton(context)
                                            : nextButton(context))
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    Text(
                                      DataUtils.getStringFromThemeCode(
                                          question.theme),
                                      style: titleTs,
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    DataUtils.changeDeepToIcon(
                                      question.deep,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                  flex: 3,
                                  child: Text(question.asking, style: descTs)),
                            ],
                          ),
                        ),

                        /// 문제 하단 아이콘 (카테고리 표시용)
                        // Positioned(
                        //     top: 320,
                        //     bottom: 0,
                        //     right: 0,
                        //     left: 0,
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         Icon(
                        //           Icons.ice_skating,
                        //           size: 120,
                        //         ),
                        //         Icon(
                        //           Icons.wind_power,
                        //           size: 120,
                        //         ),
                        //       ],
                        //     )),
                      ]),
                ),
              ),
            );
          }),
    );
  }

  Widget skipButton(BuildContext context) {
    return OutlinedButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: ((context) {
                return const _SkipButtonAlert();
              }));
        },
        style: OutlinedButton.styleFrom(side: BorderSide.none),
        child: Image.asset(
          'assets/images/icon/skip_button.png',
          scale: 7,
          fit: BoxFit.cover,
        ));
  }

  Widget nextButton(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text("next"));
  }

  Stream<int> disCountLimitTime(int limitTime) async* {
    int leftTime = limitTime;

    for (int i = 0; i < limitTime; i++) {
      debugPrint("leftTime($i): $leftTime");
      await Future.delayed(Duration(seconds: 1));

      yield --leftTime;
    }
  }
}

class _SkipButtonAlert extends StatefulWidget {
  const _SkipButtonAlert({Key? key}) : super(key: key);

  @override
  State<_SkipButtonAlert> createState() => __SkipButtonAlertState();
}

class __SkipButtonAlertState extends State<_SkipButtonAlert> {
  RewardedAd? rewardedAd;

  @override
  void initState() {
    super.initState();
    // loadRewardAd();
    _createRewardedAd();
  }

  @override
  Widget build(BuildContext context) {
    int pass = nowUser == null ? 0 : nowUser!.passTicket;
    return AlertDialog(
      scrollable: true,
      title: Text(
        nowUser == null ? "guest사용자입니다." : "보유중인 패스권: $pass개",
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        textAlign: TextAlign.center,
      ),
      content: nowUser == null
          ? Column(
              children: [
                contentText(
                  text: "광고를 시청하고 다음으로 넘어갈까요?",
                ),
                const SizedBox(
                  height: 8,
                ),
                contentText(text: "로그인 시 패스권을 획득할 수 있습니다.", fontSize: 14),
              ],
            )
          : contentText(text: "패스권을 사용할까요?"),
      actions: [
        _inSkipActionButton(),
      ],
    );
  }

  Widget _inSkipActionButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlinedButton(
            onPressed: rewardedAd != null
                ? () {
                    showRewardedAd();
                  }
                : null,
            child: Row(
              children: const [
                Icon(Icons.video_collection),
                Text("광고보고 스킵"),
              ],
            )),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          nowUser == null
              ? TextButton(
                  onPressed: () async {
                    await SignManager.signIn();
                    setState(() {});
                  },
                  child: const Text("로그인"))
              : TextButton(
                  onPressed: () {
                    if (nowUser!.passTicket <= 0) {
                      flutterToast("보유중인 패스권이 없습니다.");
                    } else {
                      nowUser!.passTicket--;
                      FirebaseManager().updateUserDB(nowUser!);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("사용")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("취소")),
        ])
      ],
    );
  }

  //Load Rewarded Ads
  void _createRewardedAd() {
    // RewardedAd? _rewardedAd;

    RewardedAd.load(
      adUnitId: rewardAdID,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          setState(() {
            rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
          flutterToast("광고 불러오기에 실패했습니다. 네트워크 상태를 확인해주세요.");
          return;
        },
      ),
    );
  }

  void showRewardedAd() {
    if (rewardedAd != null) {
      rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          print("01. $ad onAdShowFullScreenContent");
        },
        onAdDismissedFullScreenContent: (ad) {
          print("02. $ad onAdDismissedFulkScreenContent");
          ad.dispose();

          _createRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print("03. $ad onAdFailedToShowFullScreenContent: $error");
          ad.dispose();
          flutterToast("광고를 불러오는 중입니다. 다시 시도해주세요.");

          _createRewardedAd();
        },
        onAdImpression: (ad) {
          print("04. $ad impression occurred");
        },
      );
      rewardedAd!.setImmersiveMode(true);
      rewardedAd!.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
        if (nowUser != null && nowUser!.passTicket < 10) {
          nowUser!.passTicket++;
          FirebaseManager().updateUserDB(nowUser!);
        }
        Navigator.pop(context);
        Navigator.pop(context);
      });
      rewardedAd = null;
    } else {
      flutterToast("광고를 불러오는 중입니다. 다시 시도해주세요.");
      _createRewardedAd();
    }
  }

  Text contentText({required String text, double fontSize = 16}) {
    return Text(
      text,
      style: TextStyle(fontSize: fontSize),
      textAlign: TextAlign.center,
    );
  }
}