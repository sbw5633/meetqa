import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:meetqa/common/component/flutter_toast.dart';
import 'package:meetqa/common/const/ad_id.dart';

class AdButton extends StatefulWidget {
  final offerReward;
  const AdButton({
    Key? key,
    required this.offerReward,
  }) : super(key: key);

  @override
  State<AdButton> createState() => _AdButtonState();
}

class _AdButtonState extends State<AdButton> {
  RewardedAd? rewardedAd;

  @override
  void initState() {
    super.initState();

    _createRewardedAd();
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: rewardedAd != null
            ? () {
                showRewardedAd();
              }
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.video_collection),
            SizedBox(
              width: 4,
            ),
            Text("광고보고 스킵"),
          ],
        ));
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
        widget.offerReward();
      });
      rewardedAd = null;
    } else {
      flutterToast("광고를 불러오는 중입니다. 다시 시도해주세요.");
      _createRewardedAd();
    }
  }
}
