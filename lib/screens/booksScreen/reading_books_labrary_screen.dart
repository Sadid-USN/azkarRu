import 'package:animate_icons/animate_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:avrod/colors/colors.dart';


class BookReading extends StatefulWidget {
 final List<dynamic> chapters;
 final String title;
 final String image;
  // final String? source;
const  BookReading({
    Key? key,
    // this.source,
    required this.chapters,
    required this.title,
    required this.image,
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

  AnimateIconController controller = AnimateIconController();
  @override
  void initState() {
    initHive();

    int? lastReadedPage = savePageBox.get(
      'content',
    );
    if (lastReadedPage != null) {
      // print(lastReadedPage);
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
    savePageBox.put('content', currentPage);
    super.dispose();
  }

  nextPage() {
    currentPage++;
    if (currentPage > widget.chapters.length) {
    } else {
      pageController.animateToPage(currentPage,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  onPageChanged(index) {
    currentPage = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            widget.title,
            style: TextStyle(color: Colors.grey.shade800, fontSize: 16.0),
          ),
        ),
        centerTitle: true,
        elevation: 0.5,
        backgroundColor: const Color.fromARGB(255, 231, 208, 180),
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
        ),
        // actions: [
        //   AnimateIcons(
        //     startIcon: Icons.book_outlined,
        //     endIcon: Icons.book,
        //     controller: controller,
        //     size: 25.0,
        //     onStartIconPress: () {
        //       setState(() {});
        //       return true;
        //     },
        //     onEndIconPress: () {
        //       return true;
        //     },
        //     duration: const Duration(milliseconds: 250),
        //     startIconColor: Colors.black45,
        //     endIconColor: Colors.blueGrey,
        //     clockwise: false,
        //   ),
        // ],
      ),
      backgroundColor: bgColor,
      extendBodyBehindAppBar: true,
      body: PageView.builder(
        controller: pageController,
        onPageChanged: (index) {
          onPageChanged(index);
        },
        itemCount: widget.chapters.length,
        itemBuilder: (context, index) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BookInfo(
                    border: Border.all(),
                    subtitle: widget.chapters[index]["subtitle"],
                    title: widget.chapters[index]["title"],
                    sources: widget.chapters[index]["sources"],
                    text: widget.chapters[index]["text"],
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

class AuthorInfo extends StatelessWidget {
  final String? image;
  const AuthorInfo({
    Key? key,
    this.image,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 215, 198, 176),
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height / 2 * 1,
          width: MediaQuery.of(context).size.width / 2 * 1.5,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  color: Colors.black26,
                  offset: Offset(1.0, 1.0),
                  blurRadius: 6.0)
            ],
            borderRadius: BorderRadius.circular(12.0),
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6), BlendMode.dstATop),
                image: NetworkImage(image ?? ''),
                fit: BoxFit.cover),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SelectableText(
                //   title ?? '',
                //   textAlign: TextAlign.center,
                //   style: const TextStyle(
                //     letterSpacing: 1.5,
                //     color: Colors.white,
                //     fontSize: 18.0,
                //     fontWeight: FontWeight.bold,
                //     shadows: [
                //       Shadow(
                //         offset: Offset(2.0, 2.0),
                //         blurRadius: 3.0,
                //         color: Colors.black,
                //       ),
                //       Shadow(
                //         offset: Offset(2.0, 2.0),
                //         blurRadius: 8.0,
                //         color: Colors.black,
                //       ),
                //     ],
                //   ),
                // ),
                // const SizedBox(
                //   height: 10.0,
                // ),
                // SelectableText(
                //   author ?? '',
                //   textAlign: TextAlign.center,
                //   style: const TextStyle(
                //     shadows: [
                //       Shadow(
                //         offset: Offset(2.0, 2.0),
                //         blurRadius: 3.0,
                //         color: Colors.black,
                //       ),
                //       Shadow(
                //         offset: Offset(2.0, 2.0),
                //         blurRadius: 8.0,
                //         color: Colors.white,
                //       ),
                //     ],
                //     letterSpacing: 1.0,
                //     color: Colors.white,
                //     fontSize: 13.0,
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BookInfo extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? text;

  final List<dynamic>? sources;

  final Border? border;
  final double? height;

  const BookInfo({
    Key? key,
    this.title,
    this.border,
    this.height,
    this.subtitle,
    this.text,
    this.sources,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String sourceText =
        sources?.map((source) => source['source']).toString() ?? 'null';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                "icons/pattern.png",
                height: 70,
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            SelectableText(
              subtitle ?? '',
              textAlign: TextAlign.start,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  fontSize: 18.0),
            ),
            const SizedBox(
              height: 8.0,
            ),
            SelectableText(
              text ?? '',
              textAlign: TextAlign.start,
              style: GoogleFonts.ptSerif(
                  height: 1.6,
                  letterSpacing: 0.7,
                  color: Colors.blueGrey[900],
                  fontWeight: FontWeight.w400,
                  fontSize: 16),
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
