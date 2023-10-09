import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:avrod/colors/colors.dart';
import 'package:avrod/controllers/audio_controller.dart';
import 'package:avrod/core/notify_helper.dart';
import 'package:avrod/data/book_map.dart';
import 'package:avrod/screens/booksScreen/prayer_time_screen.dart';
import 'package:avrod/screens/body_home_page.dart';
import 'package:avrod/screens/favorite_chapter_screen.dart';
import 'package:avrod/screens/radioplyeer_screen.dart';
import 'package:avrod/core/notification.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../widgets/drawer_widget.dart';

import 'booksScreen/selected_books.dart';
import 'languages_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class HomePage extends StatefulWidget {
  static const HOME = '/home';
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Chapters? chapter;
  final NotificationHelper _notificationHelper = NotificationHelper();

  Random random = Random();
  @override
  void initState() {
    super.initState();

    _notificationHelper.initNotification();
  }

  List<Widget> pages = [
    const BodyHomePage(),
    const SelectedBooks(),
    const FavoriteChaptersSceen(),
    const PrayerTimeScreen(),
    const RadioPlayerScreen()
  ];

  final colorizeTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w900,
    color: textColor,
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const DrawerModel(),
        // extendBodyBehindAppBar: true,
        appBar: AppBar(
          iconTheme: Theme.of(context).iconTheme,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Consumer<AudioController>(
                builder: (context, value, child) => FadeInLeft(
                  duration: const Duration(milliseconds: 1000),
                  child: Text(
                    value.getTitle(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const LangugesScreen();
                    }));
                  },
                  icon: Image.asset(
                    "icons/language.png",
                    height: 20,
                  )),
            ],
          ),
          centerTitle: true,
          elevation: 3.0,
          backgroundColor: const Color(0xffF8E4CF),
        ),

        body: Consumer<AudioController>(
            builder: (context, controller, child) =>
                pages[controller.selectedIndex]),

        bottomNavigationBar: Consumer<AudioController>(
          builder: (context, controller, child) => CurvedNavigationBar(
              animationDuration: const Duration(milliseconds: 500),
              color: const Color(0xffF6DEC4),
              buttonBackgroundColor: const Color(0xffF2DFC7),
              // height: 7.h,
              index: controller.selectedIndex,
              backgroundColor: const Color(0xffF3EEE2),
              items: controller.navItems,
              onTap: (index) {
                controller.onTapBar(index);
              }),
        ),
      ),
    );
  }
}
