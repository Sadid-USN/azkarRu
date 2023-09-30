import 'package:avrod/colors/colors.dart';
import 'package:avrod/colors/gradient_class.dart';
import 'package:avrod/core/addbunner_helper.dart';
import 'package:avrod/data/book_map.dart';
import 'package:avrod/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../controllers/audio_controller.dart';
import '../generated/locale_keys.g.dart';
import 'text_screen.dart';

class FavoriteChaptersSceen extends StatefulWidget {
  const FavoriteChaptersSceen({Key? key, this.chapter}) : super(key: key);
  final Chapters? chapter;

  @override
  State<FavoriteChaptersSceen> createState() => _FavoriteChaptersSceenState();
}

class _FavoriteChaptersSceenState extends State<FavoriteChaptersSceen>
    with TickerProviderStateMixin {
  Book? book;
     BannerAdHelper bannerAdHelper = BannerAdHelper();

  late AnimationController _slideAnimationController;
  late AnimationController _rotationAnimationController;

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

    _slideAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _rotationAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
  }

 
  @override
  void dispose() {
    _slideAnimationController.dispose();
    _rotationAnimationController.dispose();
     bannerAdHelper.bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final books = Provider.of<List<Book>>(context);
    return Scaffold(
      backgroundColor: const Color(0xffF3EEE2),
        body: Consumer<AudioController>(
      builder: (context, value, child) => RefreshIndicator(
        onRefresh: () async {
          if (value.selectedIndex == 2) {
            setState(() {
              print("REFRESHING");
            });
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
                bannerAdHelper.isBannerAd
                  ? SizedBox(

                      height: bannerAdHelper.bannerAd.size.height.toDouble(),
                      width: bannerAdHelper.bannerAd.size.width.toDouble(),
                      child: AdWidget(ad: bannerAdHelper.bannerAd),
                    )
                  : const SizedBox(),
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: MediaQuery.sizeOf(context).height,
                // Your container decoration
                decoration: mainScreenGradient,
                child: ValueListenableBuilder(
                  valueListenable: Hive.box(FAVORITES_BOX).listenable(),
                  builder: (context, Box box, child) {
                    List<Chapters> chapters = [];
                    for (Book book in books) {
                      chapters.addAll(book.chapters!);
                    }
                    final List<dynamic> likedChapterIds = box.keys.toList();

                    final likedChapters = chapters
                        .where((Chapters chapter) =>
                            likedChapterIds.contains(chapter.id))
                        .toList();

                    return likedChapters.isNotEmpty
                        ? AnimationLimiter(
                            child: ListView.separated(
                              padding: const EdgeInsets.only(top: 25),
                              separatorBuilder: (context, index) => Divider(
                                color: dividerColor,
                              ),
                              physics: const BouncingScrollPhysics(),
                              itemCount: likedChapters.length,
                              itemBuilder: (context, position) {
                                return AnimationConfiguration.staggeredList(
                                  position: position,
                                  duration: const Duration(milliseconds: 500),
                                  child: ScaleAnimation(
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return TextScreen(
                                            texts:
                                                likedChapters[position].texts,
                                            chapter: likedChapters[position],
                                          );
                                        }));
                                      },
                                      leading: Text(
                                        "${likedChapters[position].id! + 1}",
                                        maxLines: 2,
                                        textAlign: TextAlign.start,
                                        style: GoogleFonts.ptSerif(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500,
                                          color: titleAbbBar,
                                        ),
                                      ),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              likedChapters[position].name!,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.start,
                                              style: GoogleFonts.ptSerif(
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.w600,
                                                color: titleAbbBar,
                                              ),
                                            ),
                                          ),
                                          LikeButton(
                                            isLiked: _isChapterLiked(
                                                likedChapters[position]),
                                            onTap: (isLiked) async {
                                              return _onLikeButtonTap(isLiked,
                                                  likedChapters[position]);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : _HeartAnimation(
                            slideAnimationController: _slideAnimationController,
                            rotationAnimationController:
                                _rotationAnimationController,
                          );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  bool _isChapterLiked(Chapters? chapter) {
    if (chapter == null) return false;
    final box = Hive.box(FAVORITES_BOX);
    return box.containsKey(chapter.id);
  }

  Future<bool> _onLikeButtonTap(bool isLiked, Chapters chapter) async {
    final box = Hive.box(FAVORITES_BOX);
    if (isLiked) {
      await box.delete(chapter.id);
    } else {
      await box.put(chapter.id, true);
    }
    setState(() {});
    return !isLiked;
  }
}

class _HeartAnimation extends StatelessWidget {
  final AnimationController slideAnimationController;
  final AnimationController rotationAnimationController;
  const _HeartAnimation(
      {Key? key,
      required this.rotationAnimationController,
      required this.slideAnimationController})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              LocaleKeys.favoriteText.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, height: 1.6),
            ),
          ),
          ScaleTransition(
            scale: Tween<double>(
              begin: 0.8, // Zoom out scale factor
              end: 0.5, // Zoom in scale factor
            ).animate(slideAnimationController),
            child: const Text(
              "❤️",
              style: TextStyle(fontSize: 80),
            ),
          ),
        ],
      ),
    );
  }
}
