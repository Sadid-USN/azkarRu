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
          actions: []),

      // ignore: avoid_unnecessary_containers
      // body: Container(
      //   decoration: mainScreenGradient,
      // child: FutureBuilder<List<Book>>(
      //   future: BookFunctions.getBookLocally(context),
      //   builder: (contex, snapshot) {
      //     final book = snapshot.data;
      //     if (snapshot.hasData) {
      //       return buildBook(contex, books);
      //     } else if (snapshot.hasError) {
      //       return const Center(
      //         child: Text('Some erro occured'),
      //       );
      //     } else {
      //       return const CircularProgressIndicator();
      //     }
      //   },
      // ),
      // ),
      body: Container(
        color: const Color(0xffF3EEE2),
        // alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: IconButton(
          onPressed: () {
            showSearch(
                context: context,
                delegate: CoustomSearch(),
                useRootNavigator: true);
          },
          icon: const Icon(
            Icons.search,
            color: iconColor,
            size: 100,
          ),
        ),
      ),
    );
  }
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
    final books = Provider.of<List<Book>>(context);
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

Widget buildBook(BuildContext context, List<Book> book) {
  final books = Provider.of<List<Book>>(context);
  return AnimationLimiter(
    child: ListView.separated(
        separatorBuilder: (contex, index) => Divider(
              color: dividerColor,
            ),
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
        physics: const BouncingScrollPhysics(),
        itemCount: books.length,
        itemBuilder: (context, index) {
          final Chapter chapter = books[index].chapters![index];

          // ignore: sized_box_for_whitespace
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 500),
            columnCount: books[index].chapters!.length,
            child: ScaleAnimation(
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return TextScreen(
                        texts: chapter.texts,
                        chapter: chapter,
                        index: index,
                      );
                    },
                  ));
                },
                title: Text(
                  books[index].name!,
                  maxLines: 3,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 12.sp,
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.w600,
                      color: textColor),
                ),
              ),
            ),
          );
        }),
  );
}
