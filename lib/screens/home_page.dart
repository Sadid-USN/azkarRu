// @dart=2.9
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:avrod/colors/colors.dart';
import 'package:avrod/colors/gradient_class.dart';
import 'package:avrod/data/book_map.dart';
import 'package:avrod/models/bottom_nav_bar.dart';
import 'package:avrod/style/my_text_style.dart';
import 'package:avrod/widgets/notification.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../widgets/drawer_widget.dart';
import 'chapter_screen.dart';
import 'package:timezone/data/latest.dart' as tz;

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Chapter chapter;

  @override
  void initState() {
    super.initState();
    // var bottomNavBar = Provider.of<BottomAppBar>(context);
    tz.initializeTimeZones();
    NotificationService().dailyAtNotification(
        1,
        "Молитва защита верующего",
        "Ваш Господь сказал: «Взывайте ко Мне, и Я отвечу вам» (Аль-Гафир 60)",
        1);
  }

  // final controller = PageController(viewportFraction: 12.0, keepPage: true);

  final navItems = [
    Icon(FontAwesomeIcons.search, color: textColor, size: 22.sp),
    Icon(
      FontAwesomeIcons.book,
      color: textColor,
      size: 22.sp,
    ),
    Icon(Icons.favorite, color: Colors.red, size: 22.sp),
    Icon(FontAwesomeIcons.calendarAlt, color: textColor, size: 22.sp),
    Icon(Icons.star, color: textColor, size: 22.sp),
  ];

  final colorizeColors = [
    titleAbbBar,
    Colors.orange,
    Colors.blue,
    Colors.indigo,
    Colors.blueGrey,
    Colors.deepOrange,
  ];

  final colorizeTextStyle =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w900);

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    final books = Provider.of<List<Book>>(context);
    return ChangeNotifierProvider(
      create: (context) => BottomNavBar(),
      child: Scaffold(

          // backgroundColor: currentWidth < 400 ? Colors.deepOrange: Colors.greenAccent[400],
          drawer: const DrawerModel(),
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: ListTile(
              title: AnimatedTextKit(
                totalRepeatCount: 2,
                animatedTexts: [
                  ColorizeAnimatedText('Утренние и вечерние азкары',
                      textStyle: colorizeTextStyle, colors: colorizeColors),
                ],
              ),
            ),
            centerTitle: true,
            elevation: 0.0,
            backgroundColor: const Color(0xffF2DFC7),
          ),
          body: Container(
            height: currentHeight,
            width: currentWidth,
            decoration: mainScreenGradient,
            child: ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 32, top: 60),
                      height: 70.h,
                      child: Swiper(
                        duration: 300,
                        curve: Curves.linearToEaseOut,
                        scrollDirection: Axis.horizontal,
                        autoplayDisableOnInteraction: false,
                        itemCount: books.length,
                        itemWidth: 64.w,
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
                              // Get.toNamed('/chapterscreen');
                              Navigator.push(context, PageRouteBuilder(
                                  pageBuilder: (context, a, b) {
                                return ChapterScreen(
                                  index,
                                  chapter,
                                );
                              }));
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
                                    // ignore: sized_box_for_whitespace
                                    Container(
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: Text(
                                                  books[index].name,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 19.sp,
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
                                                        'Узнать больше',
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
                                Lottie.network(
                                  'https://assets7.lottiefiles.com/private_files/lf30_yeszgfau.json',
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          bottomNavigationBar: Consumer<BottomNavBar>(
            builder: (context, bottomBar, child) => CurvedNavigationBar(
                color: const Color(0xffF2DFC7),
                buttonBackgroundColor: Colors.white,
                height: 50.sp,
                index: bottomBar.selectedIndex,
                backgroundColor: const Color(0xffF3EEE2),
                items: navItems,
                onTap: (index) {
                  bottomBar.onTapBar(context, index);
                }),
          )),
    );
  }
}
