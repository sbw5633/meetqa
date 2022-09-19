import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:meetqa/common/const/ad_id.dart';

class AdManager {
  //Load Rewarded Ads
  void showRewardedAd(RewardedAd? _rewardedAd, int waitTime) {
    if (_rewardedAd != null) {
      _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (ad) {
          print("01. $ad onAdShowFullScreenContent");
        },
        onAdDismissedFullScreenContent: (ad) {
          print("02. $ad onAdDismissedFulkScreenContent");
          ad.dispose();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print("03. $ad onAdFailedToShowFullScreenContent: $error");
          ad.dispose();
        },
        onAdImpression: (ad) {
          print("04. $ad impression occurred");
        },
      );
      _rewardedAd.setImmersiveMode(true);
      _rewardedAd.show(
          onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
      });
    }
  }

  Future<BannerAd?> createBanner(BuildContext context) async {
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.of(context).size.width.truncate(),
    );
    print("createBanner-size : $size");
    if (size == null) {
      print('Unable to get height of anchored banner.');
      return null;
    }

    BannerAd? _ad;

    _ad = BannerAd(
        size: size,
        adUnitId: bannerAdID,
        request: AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            print("$BannerAd loaded");
            _ad = ad as BannerAd;
          },
          onAdFailedToLoad: (ad, error) {
            print("$BannerAd failedToLoad: $error");
            ad.dispose();
            return;
          },
          onAdOpened: ((ad) {
            print("$BannerAd onAdOpened");
          }),
          onAdClosed: (ad) {
            print("$BannerAd onAdClosed.");
          },
        ));
    return _ad;
  }
}
