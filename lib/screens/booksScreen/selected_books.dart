import 'package:avrod/colors/colors.dart';
import 'package:avrod/controllers/audio_controller.dart';
import 'package:avrod/core/addbunner_helper.dart';
import 'package:avrod/core/scelton.dart';
import 'package:avrod/screens/booksScreen/books_ditails.dart';
import 'package:avrod/screens/booksScreen/pdf_api_class.dart';
import 'package:avrod/screens/booksScreen/reading_books_labrary_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({
    Key? key,
  }) : super(key: key);

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
            return const Center(child: Text('Somthing went wrong'));
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
          return GridView.builder(
              itemCount: data.size,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2 / 2.8,
              ),
              itemBuilder: ((context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: ((context) {
                        return BookReading(
                       
                          title: data.docs[index]['title'],
                        
                          image: data.docs[index]['image'], 
                          chapters: data.docs[index]['chapters'],

                          //source: data.docs[index]['source'],
                        );
                      })));
                    },
                    child: Container(
                      margin:
                          const EdgeInsets.only(left: 16, top: 10, right: 10),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(data.docs[index]['image']),
                            fit: BoxFit.cover),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(16.0),
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
