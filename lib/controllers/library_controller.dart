import 'package:avrod/models/lib_book_model.dart';
import 'package:avrod/screens/booksScreen/selected_books.dart';
import 'package:avrod/screens/text_screen.dart';
import 'package:avrod/widgets/audio_palayer_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

class LibraryController extends ChangeNotifier {
  late final AudioPlayer _audioPlayer = AudioPlayer();

  LibraryController() {
    currentPage = 0;
    pageController = PageController(initialPage: currentPage);
  }

  AudioPlayer get audioPlayer => _audioPlayer;
  late int currentPage;
  late PageController pageController;
  late Box savePageBox;
  late int? lastReadedPage;
  late int? getCurrentIndexAudio;
  late LibBookModel book;
  void getLastReadedPage() {
    lastReadedPage = savePageBox.get(
      book.id,
    );
    if (lastReadedPage != null) {
      currentPage = lastReadedPage!;
      pageController = PageController(initialPage: lastReadedPage ?? 0);
    } else {
      currentPage = 0;
      pageController = PageController(initialPage: currentPage);
    }
  }

  void initHive() {
    savePageBox = Hive.box('pageBox');
  }

  Stream<PositioneData> get positioneDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositioneData>(
          _audioPlayer.positionStream,
          _audioPlayer.bufferedPositionStream,
          _audioPlayer.durationStream,
          (positione, bufferedPosition, duration) => PositioneData(
                positione,
                bufferedPosition,
                duration ?? Duration.zero,
              ));

  void _onPlayerCompletion(PlayerState playerState) {
    if (playerState.processingState == ProcessingState.completed) {
      _audioPlayer.seek(Duration.zero);
      _audioPlayer.pause();
    }
  }

  void playAudio() {
    int getCurrentIndexAudio = savePageBox.get(book.id) ?? 0;
    final audioSource = AudioSource.uri(
      Uri.parse(book.chapters?[getCurrentIndexAudio].url ?? "_"),
      tag: MediaItem(
        id: book.id.toString(),
        album: book.title,
        title: book.title ?? "",
        artUri: Uri.parse(book.image ?? noImage),
      ),
    );

    print("THIS IS CURRENT SAVED INDEX AUDIO ====>>>> $getCurrentIndexAudio");

    _audioPlayer.setAudioSource(audioSource);
    _audioPlayer.playerStateStream.listen((playerState) {
      _onPlayerCompletion(playerState);
    });
  }

  void onPageChanged(index) {
    currentPage = index;
    savePageBox.put(book.id, currentPage);
    playAudio();
  }

  void onNextPagePressed() {
    if (currentPage < book.chapters!.length - 1) {
      currentPage++;
      playAudio(); // Play the audio for the new page
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      currentPage = 0;
      playAudio();
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }

    savePageBox.put(book.id, currentPage);
  }

  void previousPagePressed() {
    if (currentPage > 0) {
      currentPage--;
      playAudio();
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      savePageBox.put(book.id, currentPage);
    }
  }
}
