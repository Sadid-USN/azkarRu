import 'package:avrod/screens/booksScreen/selected_books.dart';
import 'package:avrod/screens/favorite_chapter_screen.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../screens/search_screen.dart';
import '../screens/сalendars/calendar_tabbar.dart';

class BottomNavBar extends ChangeNotifier {
  int selectedIndex = 2;
  final String _lounchGooglePlay =
      'https://play.google.com/store/apps/details?id=com.darulasar.Azkar';
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url,
          forceSafariVC: false,
          forceWebView: false,
          headers: <String, String>{'header_key': 'header_value'});
    } else {
      throw 'Пайванд кушода нашуд $url';
    }
  }

  void onTapBar(context, int index) {
    selectedIndex = index;
    if (index == 0) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const SearcScreen();
      }));
    } else if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const SelectedBooks();
      }));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const FavoriteChaptersSceen();
      }));
    } else if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const CalendarTabBarView();
      }));
    } else if (index == 4) {
      // NotificationService().dailyAtNotification(
      //   1,
      //   'Дуо сипари мусалмон аст',
      //   "Парвардигоратон фармуд: «Маро бихонед, то [дуои] шуморо иҷобат кунам» (Ғофир 60)",
      //   1,
      // );

      _launchInBrowser(_lounchGooglePlay);
    }
    notifyListeners();
  }
}
