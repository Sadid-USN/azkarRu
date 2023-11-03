import 'package:avrod/core/addbunner_helper.dart';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


import 'package:provider/provider.dart';

import '../colors/colors.dart';
import '../models/book_model.dart';

import 'chapter_screen.dart';

class BodyHomePage extends StatefulWidget {
  const BodyHomePage({Key? key}) : super(key: key);

  @override
  State<BodyHomePage> createState() => _BodyHomePageState();
}

class _BodyHomePageState extends State<BodyHomePage> {
  BannerAdHelper bannerAdHelper = BannerAdHelper();
 
  @override
  void initState() {
    super.initState();

    bannerAdHelper.initializeAdMob(
      onAdLoaded: (ad) {
        setState(() {
          bannerAdHelper.isBannerAd = true;
        });
      },
    );
  }

  @override
  void dispose() {
    bannerAdHelper.bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final books = Provider.of<List<BookModel>>(context);

    return ListView(
      children: [
        Column(
          children: [
            const SizedBox(height: 5,),
            bannerAdHelper.isBannerAd
                ? SizedBox(
                    height: bannerAdHelper.bannerAd.size.height.toDouble(),
                    width: bannerAdHelper.bannerAd.size.width.toDouble(),
                    child: AdWidget(ad: bannerAdHelper.bannerAd),
                  )
                : const SizedBox(),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Set the number of columns as you want
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
                childAspectRatio:
                    1, // Adjust this value to control item aspect ratio
              ),
              itemCount: books.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, a, b) {
                         
                          return ChapterScreen(
                            bookIndex: index,
                            title: books[index].name,
                          );
                        },
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        books[index].image ?? "",
                        //  width: 30.w,
                        height: 100,
                      ),
                      SelectableText(
                        books[index].name ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 9,
                          color: textColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
