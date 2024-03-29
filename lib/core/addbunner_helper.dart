import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdHelper {
  static final BannerAdHelper _instance = BannerAdHelper._internal();
  late BannerAd bannerAd;
  final String adUnitIdAndroid = "ca-app-pub-7613540986721565/1251576374";
  final String adUnitIdIOS = "ca-app-pub-7613540986721565/5492028111";
  bool isBannerAd = false;

  factory BannerAdHelper() {
    return _instance;
  }

  BannerAdHelper._internal();

  void initializeAdMob({required void Function(Ad)? onAdLoaded}) {
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: Platform.isAndroid ? adUnitIdAndroid : adUnitIdIOS,
      listener: BannerAdListener(
        onAdLoaded: onAdLoaded,
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print(error);
        },
      ),
      request: const AdRequest(),
    );

      
       bannerAd.load();
     
   
    
  }
}