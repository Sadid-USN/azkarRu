import 'package:avrod/screens/booksScreen/book_reading_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:avrod/colors/colors.dart';
import 'package:avrod/controllers/audio_controller.dart';
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
    var controller = Provider.of<AudioController>(
      context,
    );

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
          }

          final data = snapshot.requireData;

          List<LibBookModel> booksList = data.docs.map((DocumentSnapshot doc) {
            Map<String, dynamic> bookData = doc.data() as Map<String, dynamic>;
            bookData['id'] = doc.id;
            return LibBookModel.fromJson(bookData);
          }).toList();

          List<LibBookModel> filteredBooksList = booksList.where((book) {
            return controller.selectedCategories.contains(book.category);
          }).toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: ListView(
                    padding:
                        const EdgeInsets.only(right: 5.0, left: 5.0, top: 8),
                    scrollDirection: Axis.horizontal,
                    children: controller.categories.keys
                        .map(
                          (category) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: FilterChip(
                              selected: controller.selectedCategories
                                  .contains(category),
                              label: Text(
                                controller.getTranslatedCategory(category.tr()),
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              onSelected: (vaSelected) {
                                controller.toggleCategory(category);
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2 * 1.4,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredBooksList.length,
                      itemBuilder: ((context, index) {
                        final book = filteredBooksList[index];
                        final chapters = filteredBooksList[index].chapters;

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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) {
                                    return BookReading(
                                      index: index,
                                      book: filteredBooksList[index],
                                      onPageChanged: (pageIndex) {
                                        pageIndex = index;
                                      },
                                    );
                                  }),
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                Hero(
                                  tag:
                                      filteredBooksList[index].image ?? noImage,
                                  child: _BookImageCard(
                                    id: filteredBooksList[index].id ?? "0.0",
                                    image: filteredBooksList[index].image ??
                                        noImage,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _BuildRow(
                                        label: LocaleKeys.libTitle.tr(),
                                        data: book.title ?? "_",
                                      ),
                                      _BuildRow(
                                        label: LocaleKeys.category.tr(),
                                        data: translateCategory(
                                            book.category ?? "_"),
                                      ),
                                      _BuildRow(
                                        label: LocaleKeys.language.tr(),
                                        data: book.lang ?? "_",
                                      ),
                                      _BuildRow(
                                        label: LocaleKeys.pages.tr(),
                                        data:
                                            book.chapters?.length.toString() ??
                                                "_",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })),
                ),
              ],
            ),
          );
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
              color: Colors.blueGrey.shade700,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}

class _BookImageCard extends StatelessWidget {
  final String image;
  final String id;

  const _BookImageCard({
    Key? key,
    required this.image,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hieght = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Container(
      height: hieght / 2 * 0.3,
      width: width / 2 * 0.4,
      margin: const EdgeInsets.only(top: 16.0, right: 16.0, bottom: 16.0),
      child: CachedNetworkImage(
        imageUrl: image,
        placeholder: (context, url) => const Center(
            child:
                CircularProgressIndicator()), // Placeholder widget while loading
        errorWidget: (context, url, error) =>
            const Icon(Icons.error), // Widget to display when an error occurs
        imageBuilder: (context, imageProvider) {
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
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
            child: Stack(
              children: [
                Positioned(
                  bottom: 8,
                  right: 8,
                  child: CircleAvatar(
                    backgroundColor: Colors.black38,
                    radius: 10,
                    child: Text(
                      id,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
