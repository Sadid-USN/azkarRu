// @dart=2.9
import 'package:avrod/colors/colors.dart';
import 'package:avrod/colors/gradient_class.dart';
import 'package:avrod/data/book_map.dart';
import 'package:avrod/data/book_functions.dart';
import 'package:avrod/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'text_screen.dart';

class FavoriteChaptersSceen extends StatefulWidget {
  const FavoriteChaptersSceen({Key key, this.chapter}) : super(key: key);
  final Chapter chapter;

  @override
  State<FavoriteChaptersSceen> createState() => _FavoriteChaptersSceenState();
}

class _FavoriteChaptersSceenState extends State<FavoriteChaptersSceen> {
  Book book;
  @override
  Widget build(BuildContext context) {
    final books = Provider.of<List<Book>>(context);
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
          flexibleSpace: Container(
            decoration: mainScreenGradient,
          ),
          centerTitle: true,
          title: Text(
            'Избранные главы',
            style: TextStyle(
                fontSize: 15.sp,
                color: titleAbbBar,
                fontWeight: FontWeight.bold),
          ),
        ),
        // ignore: avoid_unnecessary_containers
        body: Container(
          decoration: mainScreenGradient,
          child: ValueListenableBuilder(
            valueListenable: Hive.box(FAVORITES_BOX).listenable(),
            builder: (context, Box box, child) {
              List<Chapter> chapters = [];
              for (Book book in books) {
                chapters.addAll(book.chapters);
              }
              final List<dynamic> likedChapterIds = box.keys.toList();

              final likedChapters = chapters
                  .where(
                      (Chapter chapter) => likedChapterIds.contains(chapter.id))
                  .toList();

              // ignore: avoid_unnecessary_containers
              return AnimationLimiter(
                child: ListView.separated(
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
                                MaterialPageRoute(builder: (context) {
                              return TextScreen(
                                texts: likedChapters[position].texts,
                                chapter: likedChapters[position],
                              );
                            }));
                          },
                          leading: CircleAvatar(
                            maxRadius: 25,
                            backgroundImage:
                                NetworkImage(likedChapters[position].listimage),
                          ),
                          title: Text(
                            likedChapters[position].name,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: titleAbbBar),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ));
  }
}
