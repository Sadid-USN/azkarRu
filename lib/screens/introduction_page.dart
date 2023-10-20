import 'package:avrod/models/lib_book_model.dart';
import 'package:flutter/material.dart';

import 'package:avrod/colors/colors.dart';
import 'package:avrod/screens/booksScreen/reading_books_labrary_screen.dart';
import 'package:avrod/widgets/costom_button.dart';

class IntroductionPage extends StatelessWidget {
  final LibBookModel book;

  final String image;
  final String title;
  const IntroductionPage({
    Key? key,
    required this.image,
    required this.title,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height / 2 * 1.3,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(4.0, 4.0),
                            blurRadius: 6.0)
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          28.0,
                        ),
                        topRight: Radius.circular(
                          28.0,
                        ),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Spacer(
                            flex: 2,
                          ),
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18),
                          ),
                          const Divider(),
                          const Text(
                            "Long text should be here Long text  should be here Long text should be here Long text should be here Long text  should be here Long text should be here",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 14),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CostomButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Icon(Icons.arrow_back_ios),
                              ),
                              CostomButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: ((context) {
                                        return BookReading(
                                          book: book,
                                        );
                                      }),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Читать",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.blueGrey.shade700),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          )
                        ]),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 90,
            child: Hero(
              tag: image,
              child: Container(
                padding: const EdgeInsets.only(bottom: 20),
                height: 270.0,
                width: 180.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    image: DecorationImage(
                        image: NetworkImage(image), fit: BoxFit.cover)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
