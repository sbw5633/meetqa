import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meetqa/common/component/will_pop_scope.dart';
import 'package:meetqa/common/const/ad_id.dart';
import 'package:meetqa/common/const/user_info.dart';
import 'package:meetqa/question/model/question_model.dart';
import 'package:meetqa/common/util/data_utils.dart';
import 'package:meetqa/z_not_use/firebase_manager.dart';
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
      fontSize: 36,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    );
    TextStyle descTs = TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 24,
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
                                          Text("?????? ??????", style: timeTs),
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
                              const SizedBox(
                                height: 16,
                              ),
                              Expanded(
                                flex: 6,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(children: [
                                    Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          Text(
                                            DataUtils.getStringFromThemeCode(
                                                question.theme),
                                            style: titleTs,
                                          ),
                                          const SizedBox(
                                            height: 16,
                                          ),
                                          DataUtils().changeDeepToIcon(
                                            question.deep,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 5,
                                      child: Text(
                                        question.asking,
                                        style: descTs,
                                      ),
                                    )
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// ?????? ?????? ????????? (???????????? ?????????)
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
      await Future.delayed(const Duration(seconds: 1));

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

  final box = Hive.box("UserData");

  int passTicket = 0;

  @override
  void initState() {
    super.initState();
    _createRewardedAd();
  }

  void refleshTicket() {
    if (nowUser != null) {
      setState(() {
        passTicket = box.get("passTicket");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    refleshTicket();

    return AlertDialog(
      scrollable: true,
      title: Text(
        nowUser == null ? "guest??????????????????." : "???????????? ?????????: $passTicket???",
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
        textAlign: TextAlign.center,
      ),
      content: nowUser == null
          ? Column(
              children: [
                contentText(
                  text: "????????? ???????????? ???????????? ????????????????",
                ),
                const SizedBox(
                  height: 8,
                ),
                contentText(text: "????????? ??? ???????????? ????????? ??? ????????????.", fontSize: 14),
              ],
            )
          : contentText(text: "???????????? ????????????????"),
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
                Text("???????????? ??????"),
              ],
            )),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          nowUser == null
              ? TextButton(
                  onPressed: () async {
                    await SignManager().signIn();
                    setState(() {});
                  },
                  child: const Text("?????????"))
              : TextButton(
                  onPressed: () {
                    if (passTicket <= 0) {
                      flutterToast("???????????? ???????????? ????????????.");
                    } else {
                      passTicket--;
                      updatePassTicket(ticket: passTicket);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text("??????")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("??????")),
        ])
      ],
    );
  }

  //Load Rewarded Ads
  void _createRewardedAd() {
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
          debugPrint('RewardedAd failed to load: $error');
          flutterToast("?????? ??????????????? ??????????????????. ???????????? ????????? ??????????????????.");
          return;
        },
      ),
    );
  }

  void showRewardedAd() {
    if (rewardedAd != null) {
      rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          debugPrint("01. $ad onAdShowFullScreenContent");
        },
        onAdDismissedFullScreenContent: (ad) {
          debugPrint("02. $ad onAdDismissedFulkScreenContent");
          ad.dispose();

          _createRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          debugPrint("03. $ad onAdFailedToShowFullScreenContent: $error");
          ad.dispose();
          flutterToast("????????? ???????????? ????????????. ?????? ??????????????????.");

          _createRewardedAd();
        },
        onAdImpression: (ad) {
          debugPrint("04. $ad impression occurred");
        },
      );
      rewardedAd!.setImmersiveMode(true);
      rewardedAd!.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        if (nowUser != null && nowUser!.passTicket < 10) {
          passTicket++;

          updatePassTicket(ticket: passTicket);

          flutterToast("Pass Ticket??? ?????????????????????.");
        }
        Navigator.pop(context);
        Navigator.pop(context);
      });
      rewardedAd = null;
    } else {
      flutterToast("????????? ???????????? ????????????. ?????? ??????????????????.");
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

  void updatePassTicket({required int ticket}) {
    box.put("passTicket", ticket);
  }
}
