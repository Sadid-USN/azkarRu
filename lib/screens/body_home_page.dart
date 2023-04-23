import 'package:avatar_glow/avatar_glow.dart';
import 'package:avrod/screens/search_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../colors/colors.dart';
import '../colors/gradient_class.dart';
import '../data/book_map.dart';
import '../data/titles.dart';
import '../generated/locale_keys.g.dart';
import 'chapter_screen.dart';

class BodyHomePage extends StatelessWidget {
const BodyHomePage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
     final currentWidth = MediaQuery.of(context).size.width;
    final currentHeight = MediaQuery.of(context).size.height;
    final books = Provider.of<List<Book>>(context);
    return Container(
            height: currentHeight,
            width: currentWidth,
            decoration: mainScreenGradient,
            child: ListView(
              children: [
                Column(
                  //  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Lottie.asset(
                      'assets/lotties/stars.json',
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
                        itemCount: books.length,
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
                                      books[index].image?? '',
                                      height: 35.h,
                                      width: 80.w,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 80,
                                  right: 40,
                                  child: Text(
                                    "${books[index].id! + 1}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 25.sp,
                                        color: textColor,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                                 Positioned(
                                  bottom: 80,
                                  left: 40,
                                  child:  IconButton(
                                      onPressed: () {
                                        showSearch(
                                            context: context,
                                            delegate: CoustomSearch(
                                              index: index,
                                            ));
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.search,
                                        color: textColor,
                                      ),
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
          );
         
  }
}