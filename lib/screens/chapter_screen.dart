// @dart=2.9
import 'package:avrod/colors/colors.dart';
import 'package:avrod/colors/gradient_class.dart';
import 'package:avrod/data/book_functions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive/hive.dart';
import 'package:avrod/data/book_map.dart';
import 'package:avrod/screens/text_screen.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:sizer/sizer.dart';
import '../main.dart';
import '../utility/glowing_progress.dart';

class ChapterScreen extends StatefulWidget {
  const ChapterScreen({
    Key key,
    this.bookIndex,
    this.title,
  }) : super(key: key);
  final int bookIndex;
  final String title;

  //final List<Book> books;

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  Box likesBox;

  @override
  void initState() {
    initHive();

    super.initState();
  }

  void initHive() async {
    likesBox = await Hive.openBox(FAVORITES_BOX);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF2DFC7),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: iconColor,
            )),
        elevation: 3.0,
        title: Text(
          widget.title.tr(),
          style: TextStyle(
              fontSize: 14.sp, color: textColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      // ignore: avoid_unnecessary_containers
      body: FutureBuilder<List<Book>>(
          future: BookFunctions.getBookLocally(context),
          builder: (context, snapshot) {
            final books = snapshot.data;
            if (snapshot.hasData) {
              return Container(
                decoration: mainScreenGradient,
                child: buildBook(books[widget.bookIndex]),
              );
            }
            return const GlowingProgress();
          }),
    );
  }

  Widget buildBook(Book book) {
    return AnimationLimiter(
      child: ListView.separated(
          separatorBuilder: (context, index) {
            return Divider(
              color: dividerColor,
            );
          },
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.only(top: 5, bottom: 25),
          physics: const BouncingScrollPhysics(),
          itemCount: book.chapters?.length ?? 0,
          itemBuilder: (context, index) {
            final List<Chapters> chapter = book.chapters;

            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 500),
              columnCount: chapter[index].listimage.length ?? 0,
              child: ScaleAnimation(
                child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return TextScreen(
                            texts: chapter[index].texts,
                            chapter: chapter[index],
                            index: index,
                          );
                        }));
                      },
                      trailing: CircleAvatar(
                        backgroundColor: const Color(0xffF3EEE2),
                        child: LikeButton(
                          isLiked: isChapterLiked(chapter[index].id),
                          onTap: (isLiked) async {
                            return setLike(chapter[index].id ?? 0, isLiked);
                          },
                          size: 20.sp,
                          circleColor: const CircleColor(
                              start: Color(0xffFF0000), end: Color(0xffFF0000)),
                          bubblesColor: const BubblesColor(
                            dotPrimaryColor: Color(0xffffffff),
                            dotSecondaryColor: Color(0xffBF40BF),
                          ),
                        ),
                      ),
                      leading: Text(
                        "${chapter[index].id + 1}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 10.sp,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w600,
                            color: textColor),
                      ),

                      // CircleAvatar(
                      //   maxRadius: 25,
                      //   backgroundImage: imageProvider,
                      // ),
                      title: Text(
                        chapter[index].name ?? '',
                        maxLines: 3,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 10.sp,
                            overflow: TextOverflow.ellipsis,
                            fontWeight: FontWeight.w600,
                            color: textColor),
                      ),
                    )),
              ),
            );
          }),
    );
  }

  Future<bool> setLike(int chapterID, bool isLiked) async {
    if (!isLiked) {
      await likesBox.put(chapterID, (false).toString());
    } else {
      await likesBox.delete(chapterID);
    }

    return !isLiked;
  }

  bool isChapterLiked(int chapterID) {
    bool isLiked = likesBox?.containsKey(chapterID) ?? 0;
    return isLiked;
  }
}
