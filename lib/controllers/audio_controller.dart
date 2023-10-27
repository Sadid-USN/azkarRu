import 'dart:math';

import 'package:animate_icons/animate_icons.dart';
import 'package:avrod/data/book_map.dart';
import 'package:avrod/generated/locale_keys.g.dart';
import 'package:avrod/screens/booksScreen/selected_books.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sizer/sizer.dart';

import '../screens/text_screen.dart';

class AudioController extends ChangeNotifier {
  int selectedIndex = 0;
  late int currentIndex;

  List<Texts> texts = [];
  Chapters? chapter;
  late TabController _tabController;
  TabController? get tabController => _tabController;

  AudioController() {
    currentIndex = 0;
  }

  set tabController(TabController? tabController) {
    _tabController = tabController!;
  }

  // AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  final AnimateIconController copyController = AnimateIconController();
  final AnimateIconController controller = AnimateIconController();
  final AnimateIconController buttonController = AnimateIconController();

  late final List<AudioPlayer> _audioPlayers;

  getAudioPlayers(int trackCount) {
    _audioPlayers = List.generate(trackCount, (_) => AudioPlayer());
  }

  bool isPlaying = false;
  String? currentUrl;

  late final AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayer get audioPlayer => _audioPlayer;

  List<AudioPlayer> get audioPlayers => _audioPlayers;

  int randomNumber = Random().nextInt(114) + 1;

  final Stream<QuerySnapshot> books = FirebaseFirestore.instance
      .collection('books')
      .orderBy(
        'author',
      )
      .snapshots();

  void playAudioForTab(int index) {
    if (currentIndex != index) {
      currentIndex = index;
      _audioPlayer.pause();
      playAudio();
    }
  }

  void goToNextTab() {
    final nextIndex = _tabController.index + 1;
    if (nextIndex < texts.length) {
      _tabController.animateTo(nextIndex);
      playAudioForTab(nextIndex);
    }
  }

  void goToPreviousTab() {
    final previousIndex = _tabController.index - 1;
    if (previousIndex >= 0) {
      _tabController.animateTo(previousIndex);
      playAudioForTab(previousIndex);
    }
  }

  Stream<PositioneData> get positioneDataStream {
    return Rx.combineLatest3<Duration, Duration, Duration?, PositioneData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (positione, bufferedPosition, duration) => PositioneData(
              positione,
              bufferedPosition,
              duration ?? Duration.zero,
            ));
  }

  void playAudio() {
    _audioPlayer.setAudioSource(
      AudioSource.uri(
        Uri.parse(texts[currentIndex].url ?? "_"),
        tag: MediaItem(
          id: texts[currentIndex].id ?? "_",
          album: chapter?.name ?? "_",
          title: chapter?.name ?? "",
          artUri: Uri.parse(chapter?.listimage ?? noImage),
        ),
      ),
    );

    _audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.stop();
      }
    });
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
