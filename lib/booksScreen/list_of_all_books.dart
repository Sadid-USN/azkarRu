import 'dart:io';
import 'package:avrod/booksScreen/selected_books.dart';
import 'package:avrod/colors/gradient_class.dart';

import 'package:avrod/booksScreen/pdf_api_class.dart';
import 'package:avrod/booksScreen/all_book.dart';
import 'package:avrod/booksScreen/books_ditails.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:sizer/sizer.dart';
import 'reading_books_labrary_screen.dart';

class ListOfAllBooks extends StatefulWidget {
  final int? bookIndex;

  const ListOfAllBooks({
    Key? key,
    this.bookIndex,
  }) : super(key: key);

  @override
  _ListOfAllBooksState createState() => _ListOfAllBooksState();
}

class _ListOfAllBooksState extends State<ListOfAllBooks> {
  

  @override
  Widget build(BuildContext context) {
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
        title: Text('Книги', style: TextStyle(fontSize: 15.sp)),
        centerTitle: true,
      ),
      body: Container(
        decoration: favoriteGradient,
        child: AnimationLimiter(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 2 / 1,
                crossAxisSpacing: 1,
                mainAxisSpacing: 5,
                crossAxisCount: 2),
            itemCount: allBooks.allBooks.length,
            itemBuilder: (context, index) {
            
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 500),
                child: ScaleAnimation(
                  child: InkWell(
                    onTap: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return    SelectedBooks(
                       
                        );
                      }));
                    },
                    child: ListTile(

                        // ignore: avoid_unnecessary_containers
                        title: CachedNetworkImage(
                      imageUrl: images[index],
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16.0)),
                          ),
                          height: 14.h,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                allBooks.allBooks[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        );
                      },
                    )),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

void openPDF(BuildContext context, File file) =>
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ReadingBooksOnline(
              file: file,
            )));
 




// Container(
//         decoration: favoriteGradient,
//         child: FutureBuilder<List<LibraryBooks>>(
//           future: LibraryBookFunction.getLibBook(context),
//           builder: (contex, snapshot) {
//             final books = snapshot.data;
//             if (snapshot.hasData) {
//               return builLibraryBook(books![widget.bookIndex ?? 0]);
//             } else if (snapshot.hasError) {
//               return const Center(
//                 child: Text(
//                   'Some erro occured',
//                   style: TextStyle(color: Colors.red, fontSize: 18.0),
//                 ),
//               );
//             } else {
//               return const CircularProgressIndicator();
//             }
//           },
//         ),
//       ),