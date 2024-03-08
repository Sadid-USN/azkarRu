import 'package:animate_do/animate_do.dart';
import 'package:avrod/controllers/library_controller.dart';
import 'package:avrod/screens/booksScreen/contents_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:avrod/colors/colors.dart';
import 'package:avrod/generated/locale_keys.g.dart';
import 'package:avrod/models/lib_book_model.dart';
import 'package:avrod/screens/booksScreen/library_screen.dart';
import 'package:avrod/widgets/costom_button.dart';

class OverviewPage extends StatelessWidget {
  final int? index;
  final LibBookModel? book;

  // final String image;
  final String? title;

  const OverviewPage({
    Key? key,
    this.index,
    this.book,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: _BottomSheet(
        index: index ?? 0,
        book: book!,
        text: book?.chapters,
        overview: book?.published ?? "",
        id: book?.id ?? "0.0",
      ),
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.grey.shade100,
        // title: const Text("Back"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.blueGrey.shade700,
          ),
        ),
        actions: const [
          // IconButton(
          //     onPressed: () {},
          //     icon: const Icon(
          //       Icons.favorite_border,
          //       color: Colors.grey,
          //       size: 25,
          //     ))
        ],
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Hero(
            tag: book?.image ?? noImage,
            child: OverviewBookImage(
              image: book?.image ?? noImage,
              id: book?.id ?? "0.0",
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  title ?? "_",
                  maxLines: 5,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.blueGrey.shade700),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  book?.author ?? "_",
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Center(
                child: InkWell(
                  onTap: () async {
                    const url =
                        'https://play.google.com/store/apps/details?id=com.darulasar.Azkar&hl=en&gl=US';
          
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: FadeInLeft(
                    duration: const Duration(milliseconds: 1000),
                    child: const Text(
                      "⭐️  ⭐️  ⭐️  ⭐️  ⭐️",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _BuildColumn(
                      label: book!.chapters!.length.toString(),
                      data: LocaleKeys.pages.tr(),
                    ),
                    const SizedBox(
                      height: 50,
                      child: VerticalDivider(
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                    ),
                    _BuildColumn(
                      label: LocaleKeys.language.tr(),
                      data: lang(book?.lang ?? ""),
                    ),
                    const SizedBox(
                      height: 50,
                      child: VerticalDivider(
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                    ),
                    _BuildColumn(
                      label: book?.published ?? "_",
                      data: LocaleKeys.published.tr(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String lang(String languageCode) {
  switch (languageCode) {
    case "En":
      return LocaleKeys.english.tr();
    case "Ru":
      return LocaleKeys.russian.tr();
    case "Tj":
      return LocaleKeys.tajik.tr();
    default:
      return "Unknown Language";
  }
}

String translateCategory(String tlateCategory) {
  switch (tlateCategory) {
    case "Aqidah":
      return LocaleKeys.Aqidah.tr();
    case "Adab":
      return LocaleKeys.Adab.tr();
    case "Fiqh":
      return LocaleKeys.Fiqh.tr();
    case "Tafsir":
      return LocaleKeys.Tafsir.tr();
    case "Sirah":
      return LocaleKeys.Sirah.tr();
    default:
      return "Unknown";
  }
}

class _BuildColumn extends StatelessWidget {
  final String label;
  final String data;
  const _BuildColumn({
    Key? key,
    required this.label,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: GoogleFonts.ptSerif(
              color: Colors.blueGrey.shade800,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )),
        const SizedBox(
          height: 6,
        ),
        Text(
          data,
          style: GoogleFonts.ptSerif(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _BottomSheet extends StatelessWidget {
  final String overview;
  final String id;
  final int index;
  final LibBookModel book;
  final List<LibChapters?>? text;
  const _BottomSheet(
      {Key? key,
      required this.overview,
      required this.id,
      required this.index,
      required this.book,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      height: size.height * 0.30,
      width: size.width,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              35,
            ),
            topRight: Radius.circular(
              35,
            ),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LocaleKeys.overview.tr(),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: textColor,
            ),
          ),
          Text(
            text!.map((e) => e?.text).join(),
            maxLines: 6,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: textColor,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CostomButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6.0),
                    child: Icon(Icons.arrow_back_ios,
                        color: Colors.blueGrey.shade700),
                  ),
                ),
                CostomButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return ContentsPage(
                          bookModel: book,
                          indexPage: index,
                        );

                        // BookReading(
                        //   book: book,
                        //   index: index,
                        // );
                      }),
                    );
                  },
                  child: Text(
                    LocaleKeys.read.tr(),
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.blueGrey.shade700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OverviewBookImage extends StatelessWidget {
  final String id;
  final String image;

  const OverviewBookImage({
    Key? key,
    required this.id,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context).width;
    return Consumer<LibraryController>(
      builder: (context, libraryController, child) => GestureDetector(
        onDoubleTap: () {
          libraryController.increaseImage();
        },
        onScaleStart: (details) {
          libraryController.startScale(libraryController.imageSize);
        },
        onScaleUpdate: (details) {
          libraryController.updateScale(details.scale);
        },
        child: Container(
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          height: size * 0.6 * libraryController.imageSize,
          width: size * 0.4 * libraryController.imageSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.bounceIn,
            child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(), // Show a loading indicator
              ),
              errorWidget: (context, url, error) =>
                  const Center(child: Icon(Icons.error)),
              imageBuilder: (context, imageProvider) {
                return Container(
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(3.0, 3.0),
                        blurRadius: 5.0,
                      ),
                    ],
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom: 8,
                        right: 5,
                        child: CircleAvatar(
                          backgroundColor: Colors.black38,
                          radius: 12,
                          child: Text(
                            id,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
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
