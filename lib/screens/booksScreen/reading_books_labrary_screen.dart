import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:avrod/colors/colors.dart';
import 'package:avrod/models/lib_book_model.dart';

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

  onPageChanged(index) {
    currentPage = index;
    savePageBox.put(widget.book.id, currentPage);
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
      backgroundColor:  bgColor,
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
                    image: widget.book.image ?? "_",
                    scrollController: scrollController,
                    page: index + 1,
                    chapters: widget.book.chapters![index],
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
  final ScrollController scrollController;
  final int page;
  final LibChapters chapters;
  final String image;
  const BookContent({
    Key? key,
    required this.scrollController,
    required this.page,
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
