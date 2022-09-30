import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:meetqa/common/component/flutter_toast.dart';
import 'package:meetqa/common/const/ad_id.dart';
import 'package:meetqa/common/const/user_info.dart';
import 'package:meetqa/common/manager/sign_manager.dart';

class AlertSkipButton extends StatefulWidget {
  const AlertSkipButton({Key? key}) : super(key: key);

  @override
  State<AlertSkipButton> createState() => _AlertSkipButtonState();
}

class _AlertSkipButtonState extends State<AlertSkipButton> {
  RewardedAd? rewardedAd;

  final box = Hive.box("UserData");

  int passTicket = 0;

  @override
  void initState() {
    super.initState();
    _createRewardedAd();
  }

  void refleshTicket() {
    if (currentUser != null) {
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
        currentUser == null ? "guest사용자입니다." : "보유중인 패스권: $passTicket개",
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
          currentUser == null
              ? TextButton(
                  onPressed: () async {
                    await SignManager().signIn();
                    setState(() {});
                  },
                  child: const Text("로그인"))
              : TextButton(
                  onPressed: () {
                    if (passTicket <= 0) {
                      flutterToast("보유중인 패스권이 없습니다.");
                    } else {
                      passTicket--;
                      updatePassTicket(ticket: passTicket);
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
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: []);

          debugPrint("01. $ad onAdShowFullScreenContent");
        },
        onAdDismissedFullScreenContent: (ad) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
          debugPrint("02. $ad onAdDismissedFulkScreenContent");
          ad.dispose();

          _createRewardedAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          debugPrint("03. $ad onAdFailedToShowFullScreenContent: $error");
          ad.dispose();
          flutterToast("광고를 불러오는 중입니다. 다시 시도해주세요.");

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

          flutterToast("Pass Ticket이 지급되었습니다.");
        }
        Navigator.pop(context);
        Navigator.of(context).pop();
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

  void updatePassTicket({required int ticket}) {
    box.put("passTicket", ticket);
  }
}
