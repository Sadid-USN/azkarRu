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
              icon: const Icon(Icons.arrow_back_ios)),
          elevation: 0.0,
          flexibleSpace: Container(
            decoration: favoriteGradient,
          ),
          centerTitle: true,
          title: Text(
            'Фаслҳои маҳбуб',
            style: TextStyle(fontSize: 18.sp),
          ),
        ),
        // ignore: avoid_unnecessary_containers
        body: Container(
          decoration: favoriteGradient,
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
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: likedChapters.length,
                  itemBuilder: (context, position) {
                    return AnimationConfiguration.staggeredList(
                      position: position,
                      duration: const Duration(milliseconds: 500),
                      child: ScaleAnimation(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return TextScreen(
                                texts: likedChapters[position].texts,
                                chapter: likedChapters[position],
                              );
                            }));
                          },
                          child: ListTile(

                              // ignore: avoid_unnecessary_containers
                              title: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Container(
                                  height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12.0)),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(0.0, 2.0),
                                            blurRadius: 6.0)
                                      ],
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              likedChapters[position]
                                                  .listimage),
                                          fit: BoxFit.cover)),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(12.0)),
                                    ),
                                    height: 80,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Center(
                                        child: Text(
                                          likedChapters[position].name,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
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
