import 'package:animate_icons/animate_icons.dart';
import 'package:avrod/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:avrod/colors/colors.dart';
import 'package:avrod/models/lib_book_model.dart';
import 'package:share/share.dart';

const String appLink =
    "https://play.google.com/store/apps/details?id=com.darulasar.Azkar";

class BookReading extends StatefulWidget {
  final LibBookModel book;

  const BookReading({
    Key? key,
    // this.source,
    required this.book,
  }) : super(
          key: key,
        );

  @override
  State<BookReading> createState() => _BookReadingState();
}

class _BookReadingState extends State<BookReading> {
  late PageController pageController;
  late int currentPage;

  late Box savePageBox;

  void initHive() {
    savePageBox = Hive.box('pageBox');
  }

  bool isOntap = false;
  ScrollController scrollController = ScrollController();
  AnimateIconController controller = AnimateIconController();
  @override
  void initState() {
    initHive();

    int? lastReadedPage = savePageBox.get(
      widget.book.id,
    );
    if (lastReadedPage != null) {
      currentPage = lastReadedPage;
      pageController = PageController(initialPage: lastReadedPage);
    } else {
      currentPage = 0;
      pageController = PageController(initialPage: currentPage);
    }
    print(savePageBox);
    controller = AnimateIconController();
    super.initState();
  }

  @override
  void dispose() {
    controller;

    super.dispose();
  }

  nextPage() {
    currentPage++;
    if (currentPage > widget.book.chapters!.length) {
    } else {
      pageController.animateToPage(currentPage,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void onPageChanged(index) {
    currentPage = index;
    savePageBox.put(widget.book.id, currentPage);
  }

  void onNextPagePressed() {
    if (currentPage < widget.book.chapters!.length) {
      currentPage++;
    } else {
      currentPage = 0; // Return to the first page
    }

    // If we're at the last page, jump to the first page
    if (currentPage >= widget.book.chapters!.length) {
      currentPage = 0;
    }

    pageController.animateToPage(
      currentPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
    savePageBox.put(widget.book.id, currentPage);
  }

  void previousPagePressed() {
    if (currentPage > 0) {
      currentPage--;
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      savePageBox.put(widget.book.id, currentPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            widget.book.title ?? "_",
            style: TextStyle(color: Colors.grey.shade800, fontSize: 16.0),
          ),
        ),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: const Color.fromARGB(255, 245, 221, 192),
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
      ),
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      body: PageView.builder(
        controller: pageController,
        onPageChanged: (index) {
          onPageChanged(index);
        },
        itemCount: widget.book.chapters!.length,
        itemBuilder: (context, index) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BookContent(
                    onShareTap: () {
                      final text = widget.book.chapters![index].text;
                      final title = widget.book.title;
                      final sentByAzkar = LocaleKeys.sentByAzkarApp.tr();
                      Share.share(
                          "$title\n$text\n$sentByAzkar\n👇👇👇\n$appLink");
                    },
                    max: widget.book.chapters!.length.toDouble() - 1,
                    image: widget.book.image ?? "_",
                    scrollController: scrollController,
                    page: index + 1,
                    chapters: widget.book.chapters![index],
                    onNextPagePressed: onNextPagePressed,
                    onPreviousPagePressed: previousPagePressed,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BookContent extends StatelessWidget {
  final void Function()? onPreviousPagePressed;
  final void Function()? onNextPagePressed;
  final void Function()? onShareTap;
  final ScrollController scrollController;
  int? page;
  final double max;
  final LibChapters chapters;
  final String image;
  BookContent({
    Key? key,
    this.onPreviousPagePressed,
    this.onNextPagePressed,
    this.onShareTap,
    required this.scrollController,
    this.page,
    required this.max,
    required this.chapters,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String sourceText =
        chapters.sources!.map((source) => source.source).join('\n');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                "icons/pattern.png",
                height: 60,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MarkdownBody(
              selectable: true,
              data: chapters.subtitle ?? "_",
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 18.0),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            MarkdownBody(
              selectable: true,
              data: chapters.text ?? "_",
              styleSheet: MarkdownStyleSheet(
                p: GoogleFonts.ptSerif(
                    height: 1.6,
                    letterSpacing: 0.7,
                    color: Colors.blueGrey[900],
                    fontWeight: FontWeight.w400,
                    fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            SelectableText(
              sourceText,
              textAlign: TextAlign.start,
              style: TextStyle(
                letterSpacing: 1.0,
                color: Colors.blueGrey[900],
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Center(
              child: Image.asset(
                "icons/pattern.png",
                height: 70,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Center(
                  child: Text(
                page.toString(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )),
            ),
            const SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: onPreviousPagePressed,
                    style: ElevatedButton.styleFrom(
                      elevation: 1,
                      foregroundColor: Colors.blueGrey.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back_ios,
                    ),
                  ),
                  GestureDetector(
                    onTap: onShareTap,
                    child: Image.asset(
                      "icons/shared.png",
                      height: 30,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: onNextPagePressed,
                    style: ElevatedButton.styleFrom(
                      elevation: 1,
                      foregroundColor: Colors.blueGrey.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}




// class ReadingBooksOnline extends StatefulWidget {
//   final File? file;

//   const ReadingBooksOnline({
//     Key? key,
//     this.file,
//   }) : super(key: key);

//   @override
//   State<ReadingBooksOnline> createState() => _ReadingBooksOnlineState();
// }

// class _ReadingBooksOnlineState extends State<ReadingBooksOnline> {
//   @override
//   Widget build(BuildContext context) {
//     final name = basename(widget.file!.path);
//     return Scaffold(
      
//       appBar: AppBar(title:  Text(name),),
//       body: PDFView(
//         filePath: widget.file!.path ,
        
//       ),
//     );
//   }
// }
