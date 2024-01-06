import 'package:avrod/colors/colors.dart';
import 'package:avrod/generated/locale_keys.g.dart';
import 'package:avrod/models/lib_book_model.dart';
import 'package:avrod/screens/booksScreen/reading_books_labrary_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContentsPage extends StatelessWidget {
  final LibBookModel? bookModel;
  final int? index;

  const ContentsPage({
    this.bookModel,
    this.index,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        title:  Text(LocaleKeys.contents.tr()),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.blueGrey.shade700,
          ),
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: bookModel?.chapters?.length ?? 0,
        itemBuilder: (context, index) {
          final chapter = bookModel?.chapters?[index];
          return Align(
            alignment: Alignment.topLeft,
            child: ListTile(
              title: Text(
                chapter?.subtitle ?? "",
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.ptSerif(
                  fontSize: 14.0,
                  color: primaryTextColor,
                ),
              ),
              trailing: Text(
                " ・・・  ${index + 1}",
                style: GoogleFonts.ptSerif(
                  fontSize: 14.0,
                  color: primaryTextColor,
                ),
              ),
              onTap: () {
               
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return BookReading(
                    book: bookModel!,
                    index: index,
                  );
                }));
              },
            ),
          );
        },
      ),
    );
  }
}
