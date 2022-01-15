// @dart=2.9
// ignore_for_file: sized_box_for_whitespace

import 'package:avrod/colors/colors.dart';
import 'package:avrod/colors/gradient_class.dart';
import 'package:avrod/data/book_functions.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive/hive.dart';
import 'package:avrod/data/book_map.dart';
import 'package:avrod/screens/text_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../main.dart';

// ignore: constant_identifier_names

class ChapterScreen extends StatefulWidget {
  const ChapterScreen(this.bookIndex, this.chapter, {Key key})
      : super(key: key);
  final int bookIndex;
  final Chapter chapter;
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
    // final books = Provider.of<List<Book>>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
        elevation: 0.0,
        title: Text(
          'Список глав',
          style: TextStyle(fontSize: 18.sp),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: favoriteGradient,
        ),
      ),

      // ignore: avoid_unnecessary_containers
      body: FutureBuilder<List<Book>>(
          future: BookFunctions.getBookLocally(context),
          builder: (context, snapshot) {
            final books = snapshot.data;
            if (snapshot.hasData) {
              return Container(
                decoration: favoriteGradient,
                child: buildBook(books[widget.bookIndex]),
              );
            }
            return Center(
                child: JumpingText(
              '...',
              style: const TextStyle(fontSize: 40, color: Colors.green),
            ));
          }),
    );
  }

  Widget buildBook(Book book) {
    return AnimationLimiter(
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 2 / 0.4.h,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
            crossAxisCount: 2,
          ),
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.only(top: 5),
          physics: const BouncingScrollPhysics(),
          itemCount: book.chapters?.length ?? 0,
          itemBuilder: (context, index) {
            final Chapter chapter = book.chapters[index];

            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 500),
              columnCount: chapter.listimage.length,
              child: ScaleAnimation(
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return TextScreen(
                          texts: chapter.texts,
                          chapter: chapter,
                        );
                      }));
                    },
                    child: CachedNetworkImage(
                        imageUrl: chapter.listimage ?? '',
                        placeholder: (context, imageProvider) {
                          return Center(
                            child: JumpingText(
                              '...',
                              end: const Offset(0.0, -0.5),
                              style: const TextStyle(
                                  fontSize: 40, color: Colors.white),
                            ),
                          );
                        },
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.black38,
                                    BlendMode.srcOver,
                                  ),
                                ),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black38,
                                      offset: Offset(0.0, 2.0),
                                      blurRadius: 6.0)
                                ],
                                gradient: const LinearGradient(
                                    colors: [
                                      Colors.white54,
                                      secondaryTextColor
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0))),
                            child: Stack(
                              children: [
                                ListTile(
                                  title: Center(
                                    child: Text(
                                      chapter.name,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: titleTextColor),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 15,
                                  right: 10,
                                  child: LikeButton(
                                    isLiked: isChapterLiked(chapter.id),
                                    onTap: (isLiked) async {
                                      return setLike(chapter.id ?? 0, isLiked);
                                    },
                                    size: 30.sp,
                                    circleColor: const CircleColor(
                                        start: Color(0xffFF0000),
                                        end: Color(0xffFF0000)),
                                    bubblesColor: const BubblesColor(
                                      dotPrimaryColor: Color(0xffffffff),
                                      dotSecondaryColor: Color(0xffBF40BF),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                ),
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
