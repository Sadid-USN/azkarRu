import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'book_map.dart';

class BookFunctions {
  static Future<List<Book>> getBookLocally(BuildContext context) async {
    String path = 'lib/data/book.json';

    // Check the current language and update the path accordingly
    if (context.locale.languageCode == 'en') {
      path = 'lib/data/bookEn.json';
    }

    // Load the file data from the updated path
    final data = await rootBundle.loadString(path);

    final List<dynamic> body = json.decode(data);
    return body.map((e) => Book.fromJson(e)).toList();
  }
}

  //  context.setLocale(const Locale('ru'));

  // static Future<List<Chapter>> getChaptersLocally(
  //   BuildContext context,
  //   int book,
  // ) async {
  //   final List<Book> books = await getBookLocally(context);
  //   return books[book].chapters!;
  // }

  // static Future<List<Texts>> getTextsLocally(
  //   BuildContext context,
  //   int book,
  //   int chapter,
  // ) async {
  //   List<Chapter> chapters = await getChaptersLocally(context, book);
  //   return chapters[chapter].texts!;
  // }

