
import 'package:avrod/data/book_map.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class GlobalController extends ChangeNotifier {
  double fontSize = 16.0;
  final textStorage = GetStorage();
  final List<Chapters> books = [];


  void reorderIndex(int oldIndex, int newIndex){

   


  }

  void intFontSize() {
    fontSize = textStorage.read('fontSize') ?? 16.0;
        notifyListeners();
  }


  void increaseSize() {
    if (fontSize < 25.0) {
      fontSize++;
      textStorage.write('fontSize', fontSize);
    }
    notifyListeners();
  }

  void decreaseSize() {
    if (fontSize > 16.0) {
      fontSize--;
      textStorage.write('fontSize', fontSize);
    }
    notifyListeners();
  }
}



