import 'package:avrod/colors/colors.dart';
import 'package:avrod/models/lib_book_model.dart';
import 'package:avrod/screens/booksScreen/library_screen.dart';
import 'package:avrod/widgets/audio_palayer_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

class LibraryController extends ChangeNotifier {
  late final AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayer get audioPlayer => _audioPlayer;
  late int currentPage;
  late PageController pageController;
  late Box savePageBox;
  late int? lastReadedPage;
  late int? getCurrentIndexAudio;
  late LibBookModel book;
  GetStorage colorBox = GetStorage();
  Map<String, Set<String>> clickedChaptersMap = {};
  LibraryController() {
    book = const LibBookModel();
    _loadClickedChapters();
  }
  void _loadClickedChapters() {
    final bookId = book.id.toString();

    // Retrieve the clicked chapters from GetStorage
    final List<String>? storedChapters = colorBox.read<List<String>>(bookId);

    // Update the clicked chapters map
    clickedChaptersMap[bookId] = storedChapters?.toSet() ?? {};
  }

  Color getChapterTextColor(int index) {
    final chapter = book.chapters?[index];
    final chapterId = chapter?.id.toString();
    final bookId = book.id.toString();

    // Retrieve the set of clicked chapters for the current book
    Set<String> clickedChapters = clickedChaptersMap[bookId] ?? {};

    bool isCurrentChapterClicked = clickedChapters.contains(chapterId);

    return isCurrentChapterClicked ? Colors.purple : textColor;
  }

  void saveChapterTextColor(int index) {
    final chapter = book.chapters?[index];
    final chapterId = chapter?.id.toString();
    final bookId = book.id.toString();

    // Retrieve the set of clicked chapters for the current book
    Set<String> clickedChapters = clickedChaptersMap[bookId] ?? {};

    // Mark the chapter as clicked
    clickedChapters.add(chapterId!);

    // Save changes to clickedChaptersMap
    clickedChaptersMap[bookId] = clickedChapters;

    // Save changes to colorBox
    colorBox.write(bookId, clickedChapters.toList());

    // Notify listeners to update UI
    notifyListeners();
  }

  // void getLastReadedPage(int? lastReadedPage) {
  //   lastReadedPage = savePageBox.get(
  //     book.id,
  //   );
  //   if (lastReadedPage != null) {
  //     currentPage = lastReadedPage;
  //     pageController = PageController(initialPage: lastReadedPage ?? 0);
  //   } else {
  //     currentPage = 0;
  //     pageController = PageController(initialPage: currentPage);
  //   }
  // }

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
    // int getCurrentIndexAudio = savePageBox.get(book.id) ?? 0;
    final audioSource = AudioSource.uri(
      Uri.parse(book.chapters?[currentPage].url ?? "_"),
      tag: MediaItem(
        id: book.id.toString(),
        album: book.title,
        title: book.title ?? "",
        artUri: Uri.parse(book.image ?? noImage),
      ),
    );

    print("THIS IS CURRENT SAVED INDEX AUDIO ====>>>> $currentPage");

    _audioPlayer.setAudioSource(audioSource);
    _audioPlayer.playerStateStream.listen((playerState) {
      _onPlayerCompletion(playerState);
    });
  }

  void onPageChanged(int index) {
    currentPage = index;
    // savePageBox.put(book.id, currentPage);
    playAudio();
    notifyListeners();
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

    // savePageBox.put(book.id, currentPage);
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

  double imageSize = 1.0;
  double _startScale = 1.0;

  final double minImageSize = 0.6;
  final double maxImageSize = 2.0;

  void increaseImage() {
    if (imageSize == 1.0) {
      imageSize = 2.0;
    } else {
      imageSize = 1.0;
    }
    notifyListeners();
  }

  void startScale(double startScale) {
    _startScale = startScale;
    notifyListeners();
  }

  void updateScale(double newScale) {
    double scaledSize = _startScale * newScale;
    // Ограничиваем масштаб, чтобы он не превышал максимальное значение
    if (scaledSize > maxImageSize) {
      scaledSize = maxImageSize;
    }
    // Ограничиваем масштаб, чтобы он не был меньше минимального значения
    if (scaledSize * 0.6 < minImageSize) {
      scaledSize = minImageSize / 0.6;
    }
    imageSize = scaledSize;
    notifyListeners();
  }
}
