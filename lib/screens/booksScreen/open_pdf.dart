import 'dart:io';

import 'package:avrod/screens/booksScreen/book_reading_screen.dart';
import 'package:flutter/material.dart';

// void openPDF(BuildContext context, File file) =>
//     Navigator.of(context).push(MaterialPageRoute(
//         builder: (context) => ReadingBooksOnline(
//               file: file,
//             )));


// import 'dart:io';
// import 'package:avrod/colors/gradient_class.dart';

// import 'package:avrod/screens/booksScreen/library_screen.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

// import 'package:sizer/sizer.dart';
// import 'all_book.dart';
// import 'book_reading_screen.dart';

// class ListOfAllBooks extends StatefulWidget {
//   final int? bookIndex;

//   const ListOfAllBooks({
//     Key? key,
//     this.bookIndex,
//   }) : super(key: key);

//   @override
//   _ListOfAllBooksState createState() => _ListOfAllBooksState();
// }

// class _ListOfAllBooksState extends State<ListOfAllBooks> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: const Icon(Icons.arrow_back_ios)),
//         elevation: 0.0,
//         flexibleSpace: Container(
//           decoration: mainScreenGradient,
//         ),
//         title: Text('Книги', style: TextStyle(fontSize: 15.sp)),
//         centerTitle: true,
//       ),
//       body: Column(
//         children: [
//           Container(
//             decoration: mainScreenGradient,
//             child: AnimationLimiter(
//               child: GridView.builder(
//                 gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     childAspectRatio: 2 / 1,
//                     crossAxisSpacing: 1,
//                     mainAxisSpacing: 5,
//                     crossAxisCount: 2),
//                 itemCount: allBooks.allBooks.length,
//                 itemBuilder: (context, index) {
//                   return AnimationConfiguration.staggeredList(
//                     position: index,
//                     duration: const Duration(milliseconds: 500),
//                     child: ScaleAnimation(
//                       child: InkWell(
//                         onTap: () async {
//                           Navigator.push(context,
//                               MaterialPageRoute(builder: (context) {
//                             return const SelectedBooks();
//                           }));
//                         },
//                         child: ListTile(

//                             // ignore: avoid_unnecessary_containers
//                             title: CachedNetworkImage(
//                           imageUrl: images[index],
//                           imageBuilder: (context, imageProvider) {
//                             return Container(
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                     image: imageProvider, fit: BoxFit.cover),
//                                 borderRadius: const BorderRadius.all(
//                                     Radius.circular(16.0)),
//                               ),
//                               height: 14.h,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(10.0),
//                                 child: Center(
//                                   child: Text(
//                                     allBooks.allBooks[index],
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                         fontSize: 16.sp,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.white),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         )),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }