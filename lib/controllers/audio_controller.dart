import 'package:animate_icons/animate_icons.dart';
import 'package:avrod/controllers/radio_conteroller.dart';

import 'package:avrod/data/book_map.dart';
import 'package:avrod/generated/locale_keys.g.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sizer/sizer.dart';

class AudioController extends ChangeNotifier {
  int selectedIndex = 0;
  int currentIndex = 0;

  List<Texts> texts = [];
  Chapters? chapter;
  late TabController _tabController;
  TabController? get tabController => _tabController;
  late RadioController radioController;

  // set tabController(TabController? tabController) {
  //   _tabController = tabController!;

  // }

  // AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
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
