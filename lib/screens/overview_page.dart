import 'package:avrod/colors/colors.dart';
import 'package:avrod/generated/locale_keys.g.dart';
import 'package:avrod/screens/booksScreen/selected_books.dart';
import 'package:avrod/screens/chapter_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:avrod/models/lib_book_model.dart';
import 'package:avrod/screens/booksScreen/reading_books_labrary_screen.dart';
import 'package:avrod/widgets/costom_button.dart';

class OverviewPage extends StatelessWidget {
  final LibBookModel? book;
  final int? numberOfPages;
  // final String image;
  final String? title;
  const OverviewPage({
    Key? key,
    this.book,
    this.numberOfPages,
    //   required this.image,
    this.title,
  }) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    final hieght = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;


    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                alignment: Alignment.center,
                height: hieght * 0.5,
                decoration: const BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(50.0),
                  ),
                ),
              ),
              ColoredBox(
                color: bgColor,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  height: hieght * 0.5,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShortInfo(
                        data: getCategoryLanguage(book?.category ?? "null"),
                        title: LocaleKeys.language.tr(),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ShortInfo(
                        data: book?.category ?? "",
                        title: LocaleKeys.category.tr(),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      ShortInfo(
                        data: numberOfPages.toString(),
                        title: LocaleKeys.pages.tr(),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      const Divider(),
                      Text(
                        book?.overview ?? "null",
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 14),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
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
                                      book: book!,
                                    );
                                  }),
                                ),
                              );
                            },
                            child: Text(
                              LocaleKeys.read.tr(),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blueGrey.shade700),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: hieght * 0.5 - (width * 0.7),
            left: width * 0.3,
            child: Hero(
              tag: book?.image ?? "_",
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                height: width * 0.6,
                width: width * 0.4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(3.0, 3.0),
                        blurRadius: 5.0)
                  ],
                  image: DecorationImage(
                    image: NetworkImage(book?.image ?? "_"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Text(
                  title ?? "_",
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: Colors.blueGrey.shade700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShortInfo extends StatelessWidget {
  final String title;
  final String data;

  const ShortInfo({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            height: 30,
            decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(6.0)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "✺ $title",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
                Text(
                  data,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
