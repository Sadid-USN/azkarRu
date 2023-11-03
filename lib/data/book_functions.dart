import 'dart:convert';
import 'package:avrod/models/book_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class BookFunctions {
  static Future<List<BookModel>> getBookLocally(BuildContext context) async {
    String path = '';

    // Check the current language and update the path accordingly
    if (context.locale.languageCode == 'en') {
      path = 'lib/data/bookEn.json';
    }else if(context.locale.languageCode == "ru"){
      path = 'lib/data/book.json';
    }else if(context.locale.languageCode == "fr"){
      path = 'lib/data/bookTj.json';
    }

    await Future.delayed(const Duration(seconds: 2));
    final data = await rootBundle.loadString(path);

    final List<dynamic> body = json.decode(data);
    return body.map((e) => BookModel.fromJson(e)).toList();
  }
}

//  context.setLocale(const Locale('ru'));

Future<List<Chapters>> getChaptersLocally(
  BuildContext context,
  int index,
) async {
  final List<BookModel> books = await BookFunctions.getBookLocally(context);
  return books[index].chapters!;
}



  // static Future<List<Texts>> getTextsLocally(
  //   BuildContext context,
  //   int book,
  //   int chapter,
  // ) async {
  //   List<Chapter> chapters = await getChaptersLocally(context, book);
  //   return chapters[chapter].texts!;
  // }

