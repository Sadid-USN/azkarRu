import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AddMobController extends ChangeNotifier {
  AddMobController() {
    initBannerAd();
  }
  late BannerAd bannerAd;
  final String adUnitId = "ca-app-pub-7613540986721565/1251576374";
  bool isBannerAd = false;

  initBannerAd() {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          isBannerAd = true;
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print(error);
        },
      ),
      request: const AdRequest(),
    );

    bannerAd.load();
    notifyListeners();
  }
}
