import 'package:avrod/screens/%D1%81alendars/calendar_tabbar.dart';
import 'package:avrod/screens/booksScreen/list_of_all_books.dart';
import 'package:avrod/screens/favorite_chapter_screen.dart';
import 'package:avrod/screens/home_page.dart';
import 'package:avrod/screens/languages_screen.dart';
import 'package:avrod/screens/onboarding_screen.dart';
import 'package:avrod/screens/radioplyeer_screen.dart';
import 'package:flutter/material.dart';


// Define the routes using a Map
final Map<String, WidgetBuilder> appRoutes = {
  "/" : (context) => const OnBoardingScreen(),
  HomePage.HOME : (context) => const HomePage(),

  "/favorite": (context) => const FavoriteChaptersSceen(),
  "/library": (context) => const ListOfAllBooks(),
  "/languges": (context) => const LangugesScreen(),
  "/calendar": (context) => const CalendarTabBarView(),
  "/radio": (context) => const RadioPlayerScreen(),
 
};