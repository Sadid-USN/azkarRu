import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'package:avrod/colors/colors.dart';
import 'package:avrod/controllers/audio_controller.dart';
import 'package:avrod/core/scelton.dart';
import 'package:avrod/generated/locale_keys.g.dart';
import 'package:avrod/models/lib_book_model.dart';
import 'package:avrod/screens/overview_page.dart';

const String noImage =
    "https://st4.depositphotos.com/14953852/24787/v/450/depositphotos_247872612-stock-illustration-no-image-available-icon-vector.jpg";

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  static String routName = '/libraryScreen';

  @override
  Widget build(BuildContext context) {
    var controller = Provider.of<AudioController>(context);

    return Scaffold(
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.books,
        builder:
            ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
            // GridView.builder(
            //     itemCount: 4,
            //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 3,
            //       childAspectRatio: 2 / 2.7,
            //     ),
            //     itemBuilder: ((context, index) {
            //       return const Skelton();
            //     }));
          }

          final data = snapshot.requireData;

          List<LibBookModel> booksList = data.docs.map((DocumentSnapshot doc) {
            Map<String, dynamic> bookData = doc.data() as Map<String, dynamic>;
            bookData['id'] = doc.id;
            return LibBookModel.fromJson(bookData);
          }).toList();

          return ListView.builder(
              itemCount: booksList.length,
              itemBuilder: ((context, index) {
                final chapters = booksList[index].chapters;
                final book = booksList[index];

                return Padding(
                  padding: const EdgeInsets.only(
                      bottom: 5, top: 10, left: 10, right: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2.0,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: ((context) {
                        return OverviewPage(
                          index: index,
                          numberOfPages: chapters!.length,
                          book: booksList[index],
                          title: booksList[index].title ?? "null",
                        );
                      })));
                    },
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _BookCard(
                          index: index,
                          image: booksList[index].image ?? noImage,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _BuildRow(
                                label: LocaleKeys.libTitle.tr(),
                                data: book.title ?? "_",
                              ),
                              _BuildRow(
                                label: LocaleKeys.category.tr(),
                                data: book.category ?? "_",
                              ),
                              _BuildRow(
                                label: LocaleKeys.language.tr(),
                                data: book.lang ?? "_",
                              ),
                              _BuildRow(
                                label: LocaleKeys.pages.tr(),
                                data: book.chapters?.length.toString() ?? "_",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }));
        }),
      ),
    );
  }
}

class _BuildRow extends StatelessWidget {
  final String label;
  final String data;
  const _BuildRow({
    Key? key,
    required this.label,
    required this.data,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.ptSerif(
              height: 2,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Text(
            data,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: GoogleFonts.ptSerif(
              height: 2,
              color: Colors.blueGrey.shade400,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _BookCard extends StatelessWidget {
  final String image;

  final int index;
  const _BookCard({
    Key? key,
    required this.image,
    required this.index,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final hieght = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    return Container(
      height: hieght / 2 * 0.3,
      width: width / 2 * 0.4,
      margin: const EdgeInsets.only(top: 16.0, right: 16.0, bottom: 16.0),
      decoration: BoxDecoration(
        image: DecorationImage(
            onError: (exception, stackTrace) {
              print(exception);
            },
            image: NetworkImage(image),
            fit: BoxFit.cover),
        borderRadius: const BorderRadius.all(
          Radius.circular(10.0),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(4.0, 4.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Stack(children: [
        Positioned(
          bottom: 8,
          right: 8,
          child: CircleAvatar(
            backgroundColor: Colors.black38,
            radius: 10,
            child: Text(
              "${index + 1}",
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10),
            ),
          ),
        ),
      ]),
    );
  }
}

  // Stack(
  //                     alignment: Alignment.bottomRight,
  //                     children: [
  //                       Column(
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Padding(
  //                             padding: const EdgeInsets.only(top: 8, left: 8),
  //                             child: Text(
  //                               name.author ?? "_",
  //                               style: const TextStyle(
  //                                   color: Colors.white,
  //                                   fontWeight: FontWeight.bold,
  //                                   fontSize: 10),
  //                             ),
  //                           ),
  //                           Container(
  //                             width: double.infinity,
  //                             margin: const EdgeInsets.only(
  //                                 top: 4, left: 6, right: 8),
  //                             padding: const EdgeInsets.symmetric(
  //                                 horizontal: 6, vertical: 2),
  //                             decoration: BoxDecoration(
  //                               color: Colors.black,
  //                               borderRadius: BorderRadius.circular(2),
  //                             ),
  //                             child: Text(
  //                               "${name.category!} ${name.lang}",
  //                               style: const TextStyle(
  //                                   color: Colors.white,
  //                                   fontWeight: FontWeight.bold,
  //                                   fontSize: 10),
  //                             ),
  //                           ),
  //                           Container(
  //                             margin: const EdgeInsets.only(
  //                                 top: 4, left: 6, right: 8),
  //                             padding: const EdgeInsets.all(4),
  //                             decoration: BoxDecoration(
  //                                 color: Colors.black45,
  //                                 borderRadius: BorderRadius.circular(2)),
  //                             child: Text(
  //                               name.title ?? "_",
  //                               style: const TextStyle(
  //                                   color: Colors.white,
  //                                   fontWeight: FontWeight.bold,
  //                                   fontSize: 8),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       //  top: hieght * 0.4 - (width * 0.4),
  //                       //  left: width * 0.2 * 1.1,
  //                       Positioned(
  //                         bottom: 8,
  //                         right: 8,
  //                         child: 
  //                         CircleAvatar(
  //                           backgroundColor: Colors.black38,
  //                           radius: 10,
  //                           child: Text(
  //                             "${index + 1}",
  //                             style: const TextStyle(
  //                                 color: Colors.white,
  //                                 fontWeight: FontWeight.bold,
  //                                 fontSize: 10),
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
                 
                 
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
