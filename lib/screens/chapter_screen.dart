// @dart=2.9
import 'package:avrod/colors/colors.dart';
import 'package:avrod/colors/gradient_class.dart';
import 'package:avrod/data/book_functions.dart';
import 'package:avrod/style/my_text_style.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive/hive.dart';
import 'package:avrod/data/book_map.dart';
import 'package:avrod/screens/text_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:sizer/sizer.dart';
import '../main.dart';

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
            icon: const Icon(
              Icons.arrow_back_ios,
              color: iconColor,
            )),
        elevation: 0.0,
        title: Text(
          'Список глав',
          style: TextStyle(
              fontSize: 18.sp, color: titleAbbBar, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: mainScreenGradient,
        ),
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
      child: ListView.separated(
          separatorBuilder: (context, index) {
            return Divider(
              color: dividerColor,
            );
          },
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
                        return ListTile(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return TextScreen(
                                texts: chapter.texts,
                                chapter: chapter,
                                index: index,
                              );
                            }));
                          },
                          trailing: CircleAvatar(
                            backgroundColor: const Color(0xffF3EEE2),
                            child: LikeButton(
                              isLiked: isChapterLiked(chapter.id),
                              onTap: (isLiked) async {
                                return setLike(chapter.id ?? 0, isLiked);
                              },
                              size: 20.sp,
                              circleColor: const CircleColor(
                                  start: Color(0xffFF0000),
                                  end: Color(0xffFF0000)),
                              bubblesColor: const BubblesColor(
                                dotPrimaryColor: Color(0xffffffff),
                                dotSecondaryColor: Color(0xffBF40BF),
                              ),
                            ),
                          ),
                          leading: CircleAvatar(
                            maxRadius: 25,
                            backgroundImage: imageProvider,
                          ),
                          title: Text(
                            chapter.name,
                            maxLines: 3,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 12.sp,
                                overflow: TextOverflow.ellipsis,
                                fontWeight: FontWeight.w600,
                                color: titleAbbBar),
                          ),
                        );
                      }),
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
