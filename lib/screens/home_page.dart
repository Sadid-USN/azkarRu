// @dart=2.9
import 'dart:math';

import 'package:avrod/colors/colors.dart';
import 'package:avrod/data/book_map.dart';
import 'package:avrod/controllers/global_controller.dart';
import 'package:avrod/screens/%D1%81alendars/calendar_tabbar.dart';
import 'package:avrod/screens/body_home_page.dart';
import 'package:avrod/screens/favorite_chapter_screen.dart';
import 'package:avrod/screens/radioplyeer_screen.dart';
import 'package:avrod/widgets/notification.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../generated/locale_keys.g.dart';
import '../widgets/drawer_widget.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'booksScreen/selected_books.dart';
import 'languages_screen.dart';

class HomePage extends StatefulWidget {
  static const HOME = '/';
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Chapters chapter;
  PageController _pageConroller;

  NotificationService notificationService = NotificationService();
  Random random = Random();
  @override
  void initState() {
    super.initState();
    // var bottomNavBar = Provider.of<BottomAppBar>(context);

    _pageConroller = PageController(initialPage: 0, viewportFraction: 0.8);

    tz.initializeTimeZones();

    final randomIndex = random.nextInt(10) + 1;
    final title = titleList[randomIndex].tr();
    final body = bodyList[randomIndex].tr();

    notificationService.dailyAtNotification(1, title, body, 1);
  }

  // final controller = PageController(viewportFraction: 12.0, keepPage: true);

  final colorizeColors = [
    textColor,
    Colors.orange,
    Colors.blue,
    Colors.indigo,
    Colors.blueGrey,
    Colors.deepOrange,
  ];


  List<Widget> pages = [
    const BodyHomePage(),
    const SelectedBooks(),
    const FavoriteChaptersSceen(),
    const CalendarTabBarView(),
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
              Text(
                LocaleKeys.avrod.tr(),
                style: colorizeTextStyle,
              ),
              const Spacer(),
              IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const LangugesPage();
                    }));
                  },
                  icon: Icon(
                    Icons.language,
                    color: textColor,
                  )),
            ],
          ),
          centerTitle: true,
          elevation: 3.0,
          backgroundColor: const Color(0xffF6DEC4),
        ),

        body: Consumer<GlobalController>(
            builder: (context, controller, child) =>
                pages[controller.selectedIndex]),

        bottomNavigationBar: Consumer<GlobalController>(
          builder: (context, controller, child) => CurvedNavigationBar(
              color: const Color(0xffF2DFC7),
              buttonBackgroundColor: const Color(0xffF2DFC7),
              height: 7.h,
              index: controller.selectedIndex,
              backgroundColor: const Color(0xffF3EEE2),
              items: controller.navItems,
              onTap: (index) {
                setState(() {
                  controller.selectedIndex = index;
                });
              }),
        ),
      ),
    );
  }
}
