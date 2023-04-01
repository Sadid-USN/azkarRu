import 'package:avrod/colors/colors.dart';
import 'package:avrod/colors/gradient_class.dart';
import 'package:avrod/data/book_map.dart';
import 'package:avrod/data/book_functions.dart';
import 'package:avrod/screens/text_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SearcScreen extends StatefulWidget {
  final int? bookIndex;

  const SearcScreen({
    Key? key,
    this.bookIndex,
  }) : super(key: key);

  @override
  State<SearcScreen> createState() => _SearcScreenState();
}

class _SearcScreenState extends State<SearcScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3EEE2),
      appBar: AppBar(
          elevation: 0.0,
          flexibleSpace: Container(
            decoration: mainScreenGradient,
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: iconColor,
              )),
          actions: const []),

      // ignore: avoid_unnecessary_containers
      body: Container(
        decoration: mainScreenGradient,
        child: FutureBuilder<List<Chapters>>(
          future: getChaptersLocally(context, widget.bookIndex ?? 0),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return buildBook(context, snapshot.data!);
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Some error occurred'),
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

Widget buildBook(BuildContext context, List<Chapters> chapters) {
  return AnimationLimiter(
    child: ListView.separated(
      separatorBuilder: (context, index) => Divider(
        color: dividerColor,
      ),
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
      physics: const BouncingScrollPhysics(),
      itemCount: chapters.length,
      itemBuilder: (context, index) {
        final Chapters chapter = chapters[index];

        return AnimationConfiguration.staggeredGrid(
          position: index,
          duration: const Duration(milliseconds: 500),
          columnCount: chapters.length,
          child: ScaleAnimation(
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return TextScreen(
                        texts: chapter.texts,
                        chapter: chapter,
                        index: index,
                      );
                    },
                  ),
                );
              },
              title: Text(
                chapters[index].name ?? '0',
                maxLines: 3,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 12.sp,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
          ),
        );
      },
    ),
  );
}

class CoustomSearch extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(
            Icons.clear,
            color: iconColor,
          ))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back_ios));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final books = Provider.of<List<Chapters>>(context);
    List<String> matchQuery = [];
    for (var item in books) {
      if (item.name!.toLowerCase().contains(
            query.toLowerCase(),
          )) {
        matchQuery.add(item.name!);
      }
    }

    return ListView.builder(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
        physics: const BouncingScrollPhysics(),
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return Padding(
            padding: const EdgeInsets.all(5),
            child: InkWell(
              onTap: () {},
              child:

                  // ignore: sized_box_for_whitespace
                  Container(
                      decoration: mainScreenGradient,
                      height: 12.h,
                      child: Center(
                        child: ListTile(
                          title: Center(
                            child: Text(
                              result,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: iconColor),
                            ),
                          ),
                          // leading: Padding(
                          //   padding: const EdgeInsets.only(right: 15),
                          //   child: Text(chapter.id.toString(),
                          //       style: const TextStyle(color: Colors.white)),
                          // ),
                        ),
                      )),
            ),
          );
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    final books = Provider.of<List<Book>>(context);
    List<String> matchQuery = [];
    for (var item in books) {
      if (item.name!.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item.name!);
      }
    }

    return ListView.builder(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
        physics: const BouncingScrollPhysics(),
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return Padding(
            padding: const EdgeInsets.all(5),
            child: InkWell(
              onTap: () {},
              child:

                  // ignore: sized_box_for_whitespace
                  Container(
                      decoration: mainScreenGradient,
                      height: 12.h,
                      child: Center(
                        child: ListTile(
                          title: Center(
                            child: Text(
                              result,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: iconColor),
                            ),
                          ),
                        ),
                      )),
            ),
          );
        });
  }
}
