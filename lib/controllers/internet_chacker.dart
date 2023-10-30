import 'dart:async';

import 'package:avrod/core/custom_banner.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';


import '../generated/locale_keys.g.dart'; 

class InternetConnectionController extends ChangeNotifier { 

  late final Connectivity _connectivity;
  InternetConnectionController(this._connectivity);


  StreamSubscription? streamSubscription;
  bool isConnected = true;

  void listenTonetworkChacges(BuildContext context) {
    streamSubscription = _connectivity.onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
        isConnected = true;
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
     
      } else {
        isConnected = false;
        CustomBanner.showBanner(
          context,
         LocaleKeys.noInternetConnection.tr(),
          Colors.grey.shade800,
          const Duration(days: 100),
        );
     
      }
      // Instead of `update()`, use `notifyListeners()` to notify listeners of the change.
      notifyListeners();
    });
  }

  @override
  void dispose() {
    streamSubscription?.cancel(); // Use safe null-aware cancellation
    super.dispose();
  }
}
