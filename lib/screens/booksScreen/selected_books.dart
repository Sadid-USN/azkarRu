import 'package:avrod/colors/colors.dart';
import 'package:avrod/controllers/audio_controller.dart';
import 'package:avrod/core/scelton.dart';
import 'package:avrod/models/lib_book_model.dart';
import 'package:avrod/screens/overview_page.dart';
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
                final hieght = MediaQuery.sizeOf(context).height;
                final width = MediaQuery.sizeOf(context).width;
                final chapters = booksList[index].chapters;
                final name = booksList[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: ((context) {
                      return OverviewPage(
                        index: index,
                        numberOfPages: chapters!.length,
                        book: booksList[index],
                        title: booksList[index].title ?? "null",
                        // image: booksList[index].image ?? "null",
                      );

                      // BookReading(
                      //   title: booksList[index].title ?? "null",
                      //   image: booksList[index].image ?? "null",
                      //   chapters: booksList[index].chapters ?? [],
                      //    bookId: booksList[index].id ?? ""
                      // );
                    })));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: 12.0, left: 10.0, right: 10.0, bottom: 12.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(booksList[index].image ?? "_"),
                          fit: BoxFit.cover),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(4.0, 4.0),
                            blurRadius: 6.0)
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8, left: 8),
                              child: Text(
                                name.author ?? "_",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(
                                  top: 4, left: 6, right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Text(
                                "${name.category!} ${name.lang}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 4, left: 6, right: 8),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  color: Colors.black45,
                                  borderRadius: BorderRadius.circular(2)),
                              child: Text(
                                name.title ?? "_",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 8),
                              ),
                            ),
                          ],
                        ),
                        //  top: hieght * 0.4 - (width * 0.4),
                        //  left: width * 0.2 * 1.1,
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
