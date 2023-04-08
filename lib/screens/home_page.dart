// @dart=2.9
import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:avrod/colors/colors.dart';
import 'package:avrod/colors/gradient_class.dart';
import 'package:avrod/data/book_map.dart';
import 'package:avrod/controllers/global_controller.dart';
import 'package:avrod/widgets/notification.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../data/titles.dart';
import '../generated/locale_keys.g.dart';
import '../widgets/drawer_widget.dart';
import 'chapter_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'languages_screen.dart';

class HomePage extends StatefulWidget {
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

  final colorizeTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w900,
    color: textColor,
  );

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    final books = Provider.of<List<Book>>(context);
    return ChangeNotifierProvider(
      create: (context) => GlobalController(),
      child: SafeArea(
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
            backgroundColor: const Color(0xffF2DFC7),
          ),

          body: Container(
            height: currentHeight,
            width: currentWidth,
            decoration: mainScreenGradient,
            child: ListView(
              children: [
                Column(
                  //  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Lottie.network(
                      'https://assets7.lottiefiles.com/private_files/lf30_yeszgfau.json',
                      fit: BoxFit.cover,
                      height: 10,
                      width: currentWidth,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 32, top: 60),
                      height: 70.h,
                      child: Swiper(
                        duration: 200,
                        curve: Curves.linearToEaseOut,
                        scrollDirection: Axis.horizontal,
                        autoplayDisableOnInteraction: false,
                        itemCount: books?.length ?? 0,
                        itemWidth: 67.w,
                        layout: SwiperLayout.STACK,
                        pagination: const SwiperPagination(
                          margin: EdgeInsets.only(top: 20),
                          builder: DotSwiperPaginationBuilder(
                              activeColor: Colors.deepOrange,
                              activeSize: 14,
                              space: 5),
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, a, b) {
                                    return ChapterScreen(
                                      bookIndex: index,
                                      title: titles[index],
                                    );
                                  },
                                ),
                              );
                            },
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 100,
                                    ),
                                    SizedBox(
                                      height: 40.h,
                                      width: 40.h,
                                      child: Card(
                                        elevation: 8,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(25.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: Text(
                                                  titles[index].tr(),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 14.sp,
                                                      color: textColor,
                                                      fontWeight:
                                                          FontWeight.w900),
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  const SizedBox(
                                                    height: 30,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        LocaleKeys.learnMore
                                                            .tr(),
                                                        style: TextStyle(
                                                            color:
                                                                primaryTextColor,
                                                            fontSize: 10.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                      SizedBox(
                                                        width: 2.w,
                                                      ),
                                                      // ignore: sized_box_for_whitespace
                                                      Icon(
                                                        FontAwesomeIcons
                                                            .handPointer,
                                                        size: 14.sp,
                                                        color: Colors.blueGrey,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                  ),
                                  child: AvatarGlow(
                                    shape: BoxShape.circle,
                                    glowColor: Colors.green,
                                    endRadius: 90.sp,
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    repeat: true,
                                    showTwoGlows: true,
                                    repeatPauseDuration:
                                        const Duration(milliseconds: 1000),
                                    child: Image.asset(
                                      books[index].image,
                                      height: 35.h,
                                      width: 80.w,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 80,
                                  right: 40,
                                  child: Text(
                                    "${books[index].id + 1}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 25.sp,
                                        color: textColor,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height,
                    // ),
                  ],
                )
              ],
            ),
          ),
          bottomSheet: Consumer<GlobalController>(
            builder: (context, bottomBar, child) => CurvedNavigationBar(
                color: const Color(0xffF2DFC7),
                buttonBackgroundColor: const Color(0xffF2DFC7),
                height: 7.h,
                index: bottomBar.selectedIndex,
                backgroundColor: const Color(0xffF3EEE2),
                items: bottomBar.navItems,
                onTap: (index) {
                  bottomBar.onTapBar(context, index);
                }),
          ),
        ),
      ),
    );
  }
}
