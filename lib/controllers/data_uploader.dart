import 'dart:convert';

import 'package:avrod/firebase/refrences.dart';
import 'package:avrod/models/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum LoadingStatus { loading, completed, error }

class DataUploaderController extends ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.loading;

  Future<void> uploadData(BuildContext context) async {
    loadingStatus = LoadingStatus.loading;
    notifyListeners();

    final firebaseStore = FirebaseFirestore.instance;
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final booksInAssets = manifestMap.keys
        .where(
            (path) => path.startsWith('assets/DB/') && path.contains('.json'))
        .toList();

    List<BookModel> bookModels = [];

    for (var bookPath in booksInAssets) {
      String stringBookContent = await rootBundle.loadString(bookPath);
      bookModels.add(BookModel.fromJson(json.decode(stringBookContent)));
    }

    try {
      var batch = firebaseStore.batch();

      for (var book in bookModels) {
        batch.set(booksCollection.doc(book.id.toString()), {
          "author": book.author,
          "name": book.name,
          "preface": book.preface,
          "image": book.image,
          // Add other fields specific to your Books class
        });
      }
    } catch (error) {
      print('Error uploading data: $error');
      loadingStatus = LoadingStatus.error;
      notifyListeners();
    }
  }
}
