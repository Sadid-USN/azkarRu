import 'dart:convert';

import 'package:avrod/firebase/refrences.dart';

import 'package:avrod/models/lib_book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum LoadingStatus { loading, completed, error }

class DataUploaderController extends ChangeNotifier {
  LoadingStatus loadingStatus = LoadingStatus.loading;
  
   DataUploaderController(BuildContext context) {
    uploadData(context);
  }

  Future<void> uploadData( context) async {
    try {
      loadingStatus = LoadingStatus.loading;

      final firebaseStore = FirebaseFirestore.instance;
      final manifestContent =
          await DefaultAssetBundle.of(context).loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      final booksInAssets = manifestMap.keys
          .where(
              (path) => path.startsWith('assets/DB/') && path.contains('.json'))
          .toList();

      List<LibBookModel> bookModels = [];

      for (var bookPath in booksInAssets) {
        String stringBookContent = await rootBundle.loadString(bookPath);
        bookModels.add(LibBookModel.fromJson(json.decode(stringBookContent)));
      }

      var batch = firebaseStore.batch();

      for (var book in bookModels) {
        batch.set(booksCollection.doc(book.id), {
          "author": book.author,
          "title": book.title,
          "image": book.image,
          "chapters": book.chapters?.map((c) => c.toJson()).toList(),
          // Add other fields specific to your LibBookModel
        });
      }

      await batch.commit();
      loadingStatus = LoadingStatus.completed;
      notifyListeners();
    } catch (error) {
      print('Error uploading data: $error');
      loadingStatus = LoadingStatus.error;
       notifyListeners();
    
    }
  }
}
