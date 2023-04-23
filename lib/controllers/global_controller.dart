import 'package:avrod/screens/booksScreen/selected_books.dart';
import 'package:avrod/screens/favorite_chapter_screen.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

import '../colors/colors.dart';
import '../screens/radioplyeer_screen.dart';
import '../screens/сalendars/calendar_tabbar.dart';

class GlobalController extends ChangeNotifier {
  int selectedIndex = 0;
  final String _lounchGooglePlay =
      'https://play.google.com/store/apps/details?id=com.darulasar.Azkar';
  

   

  final navItems = [
     Icon(FontAwesomeIcons.home, color: textColor, size: 18.sp),
    Icon(
      FontAwesomeIcons.book,
      color: textColor,
      size: 18.sp,
    ),
    Icon(Icons.favorite, color: Colors.red, size: 18.sp),
    Icon(FontAwesomeIcons.calendarAlt, color: textColor, size: 18.sp),
    Icon(Icons.radio, color: textColor, size: 18.sp),
  ];

   List pages = [
   
  
   const SelectedBooks(),
   const FavoriteChaptersSceen(),
   const CalendarTabBarView(),
   const RadioPlayerScreen(),
  ];

 
}
