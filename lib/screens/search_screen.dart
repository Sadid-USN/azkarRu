import 'package:avrod/colors/colors.dart';
import 'package:avrod/colors/gradient_class.dart';
import 'package:avrod/data/book_map.dart';
import 'package:avrod/data/book_functions.dart';
import 'package:avrod/screens/text_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;

class SearcScreen extends StatefulWidget {
  final int? bookIndex;
  final List<Book>? books;

  const SearcScreen({
    Key? key,
    this.bookIndex,
    this.books,
  }) : super(key: key);

  @override
  State<SearcScreen> createState() => _SearcScreenState();
}

class _SearcScreenState extends State<SearcScreen> {
  // var listSearch = [];
  // Future getData() async {
  //   var url = 'https://jsonplaceholder.typicode.com/users';
  //   var response = await http.get(Uri.parse(url));
  //   var responseBody = jsonDecode(response.body);
  //   for (int i = 0; i < responseBody.length; i++) {
  //     listSearch.add(responseBody[i]);
  //   }

  //   print(listSearch.toList());
  // }

  // @override
  // void initState() {
  //   getData();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final books = Provider.of<List<Book>>(context);
    return Scaffold(
        backgroundColor: gradientStartColor,
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
            actions: [
              IconButton(
                  onPressed: () {
                    showSearch(context: context, delegate: CoustomSearch());
                  },
                  icon: const Icon(
                    Icons.search,
                    color: iconColor,
                  )),
            ]),

        // ignore: avoid_unnecessary_containers
        body: Container(
          decoration: mainScreenGradient,
          child: FutureBuilder<List<Book>>(
            future: BookFunctions.getBookLocally(context),
            builder: (contex, snapshot) {
              final book = snapshot.data;
              if (snapshot.hasData) {
                return buildBook(book![widget.bookIndex ?? 0]);
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Some erro occured'),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ));
  }
}

class CoustomSearch extends SearchDelegate {
  List<String> allData = [
    'Дуа при пробуждении от сна',
    'Дуа при одевании',
    'Дуа при облачении в новую одежду',
    'Дуа за того, кто надел новую одежду',
    'Что следует сказать снявшему с себя одежду',
    'Дуа перед тем, как войти в туалет',
  ];
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
    List<String> matchQuery = [];
    for (var item in allData) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
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
    List<String> matchQuery = [];
    for (var item in allData) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
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

Widget buildBook(Book book) {
  return AnimationLimiter(
    child: ListView.builder(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
        physics: const BouncingScrollPhysics(),
        itemCount: book.chapters?.length ?? 0,
        itemBuilder: (context, index) {
          final Chapter chapter = book.chapters![index];

          // ignore: sized_box_for_whitespace
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 600),
            columnCount: book.chapters!.length,
            child: ScaleAnimation(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return TextScreen(
                        texts: chapter.texts,
                        chapter: chapter,
                        index: [index].length,
                      );
                    }));
                  },
                  child:

                      // ignore: sized_box_for_whitespace
                      Container(
                    decoration: searchScreenGradient,
                    height: 12.h,
                    child: ListTile(
                      title: Center(
                        child: InkWell(
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
                          child: Text(
                            book.chapters![index].name!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: iconColor),
                          ),
                        ),
                      ),
                      // leading: Padding(
                      //   padding: const EdgeInsets.only(right: 15),
                      //   child: Text(chapter.id.toString(),
                      //       style: const TextStyle(color: Colors.white)),
                      // ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
  );
}
