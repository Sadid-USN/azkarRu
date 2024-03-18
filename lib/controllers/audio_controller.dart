import 'package:animate_icons/animate_icons.dart';
import 'package:avrod/models/book_model.dart';
import 'package:avrod/generated/locale_keys.g.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sizer/sizer.dart';

class AudioController extends ChangeNotifier {
  int selectedIndex = 0;
  int currentIndex = 0;

  AudioController() {
    // _tabController = TabController();
    loadSelectedCategories();
    selectedCategories
        .addAll(categories.keys); // Добавьте все категории по умолчанию
  }

  final List<String> selectedCategories = [];

  final Map<String, String> categories = {
    "Aqidah": LocaleKeys.Aqidah,
    "Adab": LocaleKeys.Adab,
    "Fiqh": LocaleKeys.Fiqh,
    "Tafsir": LocaleKeys.Tafsir,
    "Sirah": LocaleKeys.Sirah,
  };

  String getTranslatedCategory(String categoryName) {
    return categories[categoryName] ?? categoryName;
  }

  bool get hasSelectedCategories => selectedCategories.isNotEmpty;
  List<Texts> texts = [];
  final String _boxName = 'selectedCategories';

  Chapters? chapter;


  final AnimateIconController copyController = AnimateIconController();
  final AnimateIconController controller = AnimateIconController();
  final AnimateIconController buttonController = AnimateIconController();

  bool isPlaying = false;
  String? currentUrl;

  final Stream<QuerySnapshot> books = FirebaseFirestore.instance
      .collection('books')
      // .orderBy(
      //   'author',
      // )
      .snapshots();

  Future<void> loadSelectedCategories() async {
    final box = await Hive.openBox<List<String>>(_boxName);
    if (box.containsKey(_boxName)) {
      final loadedCategories = box.get(_boxName);
      if (loadedCategories != null && loadedCategories.isNotEmpty) {
        selectedCategories.clear();
        selectedCategories.addAll(loadedCategories);
      }
    }
  }

  void toggleCategory(String category) async {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }
    notifyListeners(); // Notify listeners about the changes

    final box = await Hive.openBox<List<String>>(_boxName);
    await box.put(_boxName, selectedCategories);
  }

  final navItems = [
    Image.asset(
      "icons/house.png",
      height: 30,
    ),
    Image.asset(
      "icons/book.png",
      height: 30,
    ),
    Icon(Icons.favorite, color: Colors.red, size: 17.sp),
    Image.asset(
      "icons/masque.png",
      height: 30,
    ),
    Image.asset(
      "icons/radio.png",
      height: 27,
    ),
  ];

  void onTapBar(int index) {
    selectedIndex = index;

    notifyListeners();
  }

  double _progress = 0.0;

  double get progress => _progress;

  void updateProgress(double value) {
    _progress = value;
    notifyListeners();
  }

  String getTitle() {
    switch (selectedIndex) {
      case 0:
        return LocaleKeys.avrod.tr();
      case 1:
        return LocaleKeys.library.tr();
      case 2:
        return LocaleKeys.favorite.tr();
      case 3:
        return LocaleKeys.prayerTimes.tr();
      case 4:
        return LocaleKeys.radio.tr();
      default:
        return LocaleKeys.avrod.tr();
    }
  }
}

// Future<List<LibBookModel>> fetchBooks() async {
//   final QuerySnapshot snapshot = await FirebaseFirestore.instance
//       .collection('books')
//   // .orderBy('author',)
//       .get();
//
//   final booksList = snapshot.docs.map((DocumentSnapshot doc) {
//     final bookData = doc.data() as Map<String, dynamic>;
//     bookData['id'] = doc.id;
//     return LibBookModel.fromJson(bookData);
//   }).toList();
//
//   final filteredBooksList = booksList.where((book) {
//     return selectedCategories.contains(book.category);
//   }).toList();
//
//   // return the list of filtered books
//   return filteredBooksList;
// }
