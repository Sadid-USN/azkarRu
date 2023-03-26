import 'package:avrod/screens/booksScreen/selected_books.dart';
import 'package:avrod/screens/favorite_chapter_screen.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../colors/colors.dart';
import '../generated/locale_keys.g.dart';
import '../screens/radioplyeer_screen.dart';
import '../screens/search_screen.dart';
import '../screens/сalendars/calendar_tabbar.dart';

class GlobalController extends ChangeNotifier {
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

  final navItems = [
    Icon(FontAwesomeIcons.search, color: textColor, size: 18.sp),
    Icon(
      FontAwesomeIcons.book,
      color: textColor,
      size: 18.sp,
    ),
    Icon(Icons.favorite, color: Colors.red, size: 18.sp),
    Icon(FontAwesomeIcons.calendarAlt, color: textColor, size: 18.sp),
    Icon(Icons.radio, color: textColor, size: 18.sp),
  ];

  void onTapBar(context, int index) {
    selectedIndex = index;
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const SearcScreen();
          },
        ),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const SelectedBooks();
          },
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const FavoriteChaptersSceen();
          },
        ),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const CalendarTabBarView();
          },
        ),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return const RadioPlayerScreen();
          },
        ),
      );
    }
    notifyListeners();
  }

  String setRussianLang(BuildContext context) {
    var ruTitle = LocaleKeys.avrod.tr();
    notifyListeners();
    return ruTitle;
  }
}
