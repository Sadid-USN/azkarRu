import 'package:avrod/colors/colors.dart';
import 'package:avrod/controllers/audio_controller.dart';
import 'package:avrod/core/addbunner_helper.dart';
import 'package:avrod/core/scelton.dart';
import 'package:avrod/models/lib_book_model.dart';
import 'package:avrod/screens/booksScreen/books_ditails.dart';
import 'package:avrod/screens/booksScreen/pdf_api_class.dart';
import 'package:avrod/screens/booksScreen/reading_books_labrary_screen.dart';
import 'package:avrod/screens/introduction_page.dart';
import 'package:avrod/screens/onboarding_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  static String routName = '/libraryScreen';

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<AudioController>(context);

    return Scaffold(
      backgroundColor: const Color(0xffF6F1E8),
      extendBodyBehindAppBar: true,
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.books,
        builder:
            ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return GridView.builder(
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2 / 2.7,
                ),
                itemBuilder: ((context, index) {
                  return const Skelton();
                }));
          }

          final data = snapshot.requireData;

          List<LibBookModel> booksList = data.docs.map((DocumentSnapshot doc) {
            Map<String, dynamic> bookData = doc.data() as Map<String, dynamic>;
            bookData['id'] = doc.id;
            return LibBookModel.fromJson(bookData);
          }).toList();

          return GridView.builder(
              padding: const EdgeInsets.all(4.0),
              itemCount: booksList.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2 / 3,
                // crossAxisSpacing: 1
              ),
              itemBuilder: ((context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) {
                      return IntroductionPage(
                        book: booksList[index],
                        title: booksList[index].title ?? "null",
                        image: booksList[index].image ?? "null",
                      );

                      // BookReading(
                      //   title: booksList[index].title ?? "null",
                      //   image: booksList[index].image ?? "null",
                      //   chapters: booksList[index].chapters ?? [],
                      //    bookId: booksList[index].id ?? ""
                      // );
                    })));
                  },
                  child: Hero(
                    tag: booksList[index].image!,
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: 12.0, left: 12.0, right: 12.0, bottom: 12.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(booksList[index].image ?? "_"),
                            fit: BoxFit.cover),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(4.0, 4.0),
                              blurRadius: 6.0)
                        ],
                      ),
                    ),
                  ),
                );
              }));
        }),
      ),
    );
  }
}


  //  Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 20),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             Text(
  //               "Библиотека находится в процессе обработки и скоро будет доступна для пользователей. Благодарим за терпение.",
  //               style: TextStyle(fontSize: 18),
  //             ),
  //             SizedBox(
  //               height: 16,
  //             ),
  //             Text(
  //               "Китобхона дар ҳоли таҳия аст ва ба зудӣ дастраси шумо хоҳад шуд. Ташаккур зиёд барои сабратон.",
  //               style: TextStyle(fontSize: 18),
  //             ),
  //             SizedBox(
  //               height: 16,
  //             ),
  //             Text(
  //               "The library is under development and will be available to users soon. Thank you for your patience.",
  //               style: TextStyle(fontSize: 18),
  //             ),
  //           ],
  //         ),
  //       )
