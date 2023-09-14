import 'dart:math';

import 'package:avrod/colors/colors.dart';
import 'package:avrod/controllers/audio_controller.dart';
import 'package:avrod/data/book_map.dart';
import 'package:avrod/screens/%D1%81alendars/gregorian_calendar.dart';
import 'package:avrod/screens/body_home_page.dart';
import 'package:avrod/screens/favorite_chapter_screen.dart';
import 'package:avrod/screens/radioplyeer_screen.dart';
import 'package:avrod/widgets/notification.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import '../generated/locale_keys.g.dart';
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

  Random random = Random();
  @override
  void initState() {
    super.initState();
    // var bottomNavBar = Provider.of<BottomAppBar>(context);

    final randomIndex = random.nextInt(10) + 1;
    final title = titleList[randomIndex].tr();
    final body = bodyList[randomIndex].tr();

    LocalNotificationSV().scheduleNotification(
      title: title,
      body: body,
      scheduledNotificationDateTime: DateTime.now().add(const Duration(days: 1)).subtract(Duration(minutes: DateTime.now().minute)));
  }

 

  List<Widget> pages = [
    const BodyHomePage(),
    const SelectedBooks(),
    const FavoriteChaptersSceen(),
    const GregorianCalendar(),
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
                builder: (context, value, child) => Text(
                  value.getTitle(),
                  style: Theme.of(context).textTheme.titleMedium,
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
                  icon: const Icon(
                    Icons.language,
                
                    
                  )),
            ],
          ),
          centerTitle: true,
          elevation: 3.0,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        ),

        body: 
        
        Consumer<AudioController>(
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
