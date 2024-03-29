import 'package:avrod/screens/booksScreen/contents_page.dart';
import 'package:avrod/screens/favorite_chapter_screen.dart';
import 'package:avrod/screens/home_page.dart';
import 'package:avrod/screens/languages_screen.dart';
import 'package:avrod/screens/onboarding_screen.dart';
import 'package:avrod/screens/overview_page.dart';
import 'package:avrod/screens/radioplyeer_screen.dart';
import 'package:avrod/screens/uploder_screen.dart';
import 'package:flutter/material.dart';

// Define the routes using a Map
final Map<String, WidgetBuilder> appRoutes = {
 "/": (context) => const OnBoardingScreen(),
  "/home": (context) => const HomePage(),
  "/favorite": (context) => const FavoriteChaptersSceen(),
  "/languges": (context) => const LangugesScreen(),
  "/radio": (context) => const RadioPlayerScreen(),
  "/uploader": (context) =>  const DataUploadedScreen(),
  "/overview": (context) =>    const OverviewPage(),
  "/contentspage": (context) =>     const ContentsPage(),
};
