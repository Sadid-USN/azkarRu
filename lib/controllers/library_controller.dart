import 'package:avrod/models/lib_book_model.dart';
import 'package:avrod/screens/booksScreen/selected_books.dart';
import 'package:avrod/screens/text_screen.dart';
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
  late Map<int, bool> tappedIndexes;

  LibraryController() {
    initialColorData();
  }

  void initialColorData() async {
    final colorBox = GetStorage();
    if (colorBox.hasData('tappedIndexes')) {
      final data = colorBox.read('tappedIndexes');
      tappedIndexes = Map<int, bool>.from(data);
    } else {
      tappedIndexes = {};
      await saveTappedIndexes(book); // Save initial empty tappedIndexes
    }
  }

  Future<void> saveTappedIndexes(LibBookModel bookModel) async {
    final box = GetStorage();
    await box.write(bookModel.id!, tappedIndexes);
  }

bool isFirstTap(String bookId, int index) {
  final box = GetStorage();
  final key = bookId;

  if (!box.hasData(key)) {
    return false;
  } else {
    final dynamic bookData = box.read(key);
    if (bookData != null && bookData is Map<String, dynamic> && bookData.containsKey(key)) {
      final tappedIndexes = _convertMapToIntKey(bookData[key]);
      return tappedIndexes.containsKey(index) ? tappedIndexes[index]! : false;
    } else {
      return false;
    }
  }
}

void markIndexAsTapped(String bookId, int index) {
  final box = GetStorage();
  final key = bookId;

  if (!box.hasData(key)) {
    final tappedIndexes = <int, bool>{};
    tappedIndexes[index] = true;
    final Map<String, dynamic> bookData = {key: tappedIndexes};
    box.write(key, bookData);
    notifyListeners();
    saveTappedIndexes(book);
    print('New data saved: $bookData'); // Вывод в консоль
  } else {
    final dynamic dynamicBookData = box.read(key);
    if (dynamicBookData is Map<String, dynamic> && dynamicBookData.containsKey(key)) {
      final tappedIndexes = _convertMapToIntKey(dynamicBookData[key]);
      
      if (!tappedIndexes.containsKey(index)) {
        tappedIndexes[index] = true;
        dynamicBookData[key] = _convertMapToStringKey(tappedIndexes);
        box.write(key, dynamicBookData);
        saveTappedIndexes(book);
        notifyListeners();
        print('Data updated: $dynamicBookData'); // Вывод в консоль
      }
    } else {
      final tappedIndexes = <int, bool>{};
      tappedIndexes[index] = true;
      final Map<String, dynamic> newBookData = {key: tappedIndexes};
      box.write(key, newBookData);
      saveTappedIndexes(book);
      notifyListeners();
      print('New data saved: $newBookData'); // Вывод в консоль
    }
  }
}

// Функция преобразования типов ключей и значений в карту
Map<String, dynamic> _convertMapToStringKey(Map<int, bool> map) {
  return map.map((key, value) => MapEntry(key.toString(), value));
}

Map<int, bool> _convertMapToIntKey(Map<String, dynamic> map) {
  return map.map((key, value) => MapEntry(int.parse(key), value));
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
}
