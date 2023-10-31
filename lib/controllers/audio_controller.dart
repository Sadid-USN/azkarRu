import 'package:animate_icons/animate_icons.dart';


import 'package:avrod/data/book_map.dart';
import 'package:avrod/generated/locale_keys.g.dart';
import 'package:avrod/models/lib_book_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sizer/sizer.dart';

class AudioController extends ChangeNotifier {
  int selectedIndex = 0;
  int currentIndex = 0;
  late List<LibBookModel> categoryBooks;
  final List<String> selectedCategories = [];
bool get hasSelectedCategories => selectedCategories.isNotEmpty;
  List<Texts> texts = [];
  final String _boxName = 'selectedCategories';

  Chapters? chapter;
  late TabController _tabController;
  TabController? get tabController => _tabController;


  final AnimateIconController copyController = AnimateIconController();
  final AnimateIconController controller = AnimateIconController();
  final AnimateIconController buttonController = AnimateIconController();

  bool isPlaying = false;
  String? currentUrl;

  late final AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayer get audioPlayer => _audioPlayer;

  final Stream<QuerySnapshot> books = FirebaseFirestore.instance
      .collection('books')
      .orderBy(
        'author',
      )
      .snapshots();

  void toggleCategory(String category) async {
    if (selectedCategories.contains(category)) {
      selectedCategories.remove(category);
    } else {
      selectedCategories.add(category);
    }

    notifyListeners();

    final box = await Hive.openBox<List<String>>(_boxName);
    await box.put(_boxName, selectedCategories);
    print(box.values);
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
