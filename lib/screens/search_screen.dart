import 'package:avrod/colors/colors.dart';
import 'package:avrod/data/book_model.dart';
import 'package:avrod/screens/text_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CoustomSearch extends SearchDelegate {
  final int index;

  CoustomSearch({required this.index, });
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
    var chapters = books[index].chapters;
    List<String> matchQuery = [];

    for (var chapter in chapters!) {
      if (chapter.name!.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(chapter.name!);
      }
    }

    for (var chapter in chapters) {
      if (chapter.name!.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(chapter.name!);
      }
    }

    return AnimationLimiter(
      child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
                color: textColor,
              ),
          scrollDirection: Axis.vertical,
          padding:
              const EdgeInsets.only(top: 16, left: 5, right: 5, bottom: 60),
          physics: const BouncingScrollPhysics(),
          itemCount: matchQuery.length,
          itemBuilder: (context, index) {
            var result = matchQuery[index];
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 500),
              columnCount: matchQuery.length,
              child: ScaleAnimation(
                child: ListTile(
                  title: Text(
                    result,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: iconColor),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (homecontext) {
                          return TextScreen(
                            texts: chapters
                                .firstWhere(
                                  (chapter) => chapter.name == result,
                                )
                                .texts,
                            chapter: chapters.firstWhere(
                              (chapter) => chapter.name == result,
                            ),
                            index: chapters.indexWhere(
                              (chapter) => chapter.name == result,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          }),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }
}







// class SearcScreen extends StatefulWidget {
//   final int? bookIndex;

//   const SearcScreen({
//     Key? key,
//     this.bookIndex,
//   }) : super(key: key);

//   @override
//   State<SearcScreen> createState() => _SearcScreenState();
// }

// class _SearcScreenState extends State<SearcScreen> {
//   late Future<List<Book>> _booksFuture;

 

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _updateBooksFuture();
//   }

//   void _updateBooksFuture() {
//     setState(() {
//       _booksFuture = BookFunctions.getBookLocally(context);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           LocaleKeys.search.tr(),
//           style: TextStyle(color: textColor),
//         ),
//         centerTitle: true,
//         elevation: 3.0,
//         backgroundColor: bgColor,
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: const Icon(
//               Icons.arrow_back_ios,
//               color: iconColor,
//             )),
//       ),
//       floatingActionButton: FloatingActionButton(
//           backgroundColor: bgColor,
//           onPressed: () {
//             showSearch(
//                 context: context,
//                 delegate: CoustomSearch(
//                   index: widget.bookIndex!,
//                 ));
//           },
//           child: const Icon(
//             Icons.search,
//             color: iconColor,
//             size: 25,
//           )),
//     );
//   }
// }


 // ignore: avoid_unnecessary_containers
     
      //Container(
      //   decoration: mainScreenGradient,
      //   child: FutureBuilder<List<Chapters>>(
      //     future: getChaptersLocally(context, widget.bookIndex ?? 0),
      //     builder: (context, snapshot) {
      //       if (snapshot.hasData) {
      //         return buildBook(context, snapshot.data!);
      //       } else if (snapshot.hasError) {
      //         return const Center(
      //           child: Text('Some error occurred'),
      //         );
      //       } else {
      //         return const CircularProgressIndicator();
      //       }
      //     },
      //   ),
      // ),


      // Widget buildBook(BuildContext context, List<Chapters> chapters) {
//   return AnimationLimiter(
//     child: ListView.separated(
//       separatorBuilder: (context, index) => Divider(
//         color: dividerColor,
//       ),
//       scrollDirection: Axis.vertical,
//       padding: const EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 40),
//       physics: const BouncingScrollPhysics(),
//       itemCount: chapters.length,
//       itemBuilder: (context, index) {
//         return AnimationConfiguration.staggeredGrid(
//           position: index,
//           duration: const Duration(milliseconds: 500),
//           columnCount: chapters.length,
//           child: ScaleAnimation(
//             child: ListTile(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) {
//                       return TextScreen(
//                         texts: chapters[index].texts,
//                         chapter: chapters[index],
//                         index: index,
//                       );
//                     },
//                   ),
//                 );
//               },
//               title: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     chapters[index].name ?? "",
//                     maxLines: 3,
//                     textAlign: TextAlign.start,
//                     style: TextStyle(
//                       fontSize: 12.sp,
//                       overflow: TextOverflow.ellipsis,
//                       fontWeight: FontWeight.w600,
//                       color: textColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     ),
//   );
// }
