import 'dart:math';
import 'package:animate_icons/animate_icons.dart';
import 'package:avrod/models/radio_audioplayer.dart';
import 'package:avrod/screens/text_screen.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

class RadioController extends ChangeNotifier {
  late final AudioPlayer _audioPlayer = AudioPlayer();
  final AnimateIconController refreshController = AnimateIconController();
  bool onRefresh = false;
  RadioController() {
    // Initialize the fields in the constructor.
    currentPage = 0;
    pageController = PageController(initialPage: currentPage);
  }

  List<InfoData> newListInfo = [];

  get audioPlayer => _audioPlayer;
  late int currentPage;
  late PageController pageController;

  late int? lastReadedPage;

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
      _audioPlayer.seek(Duration.zero); // Reset to the beginning of the audio
      _audioPlayer.pause(); // Pause the audio when it completes
    }
  }

  void playAudio() {
    final audioSource = AudioSource.uri(
      Uri.parse(newListInfo[currentPage].audioUrl),
      tag: MediaItem(
        id: newListInfo[currentPage].id,
        album: newListInfo[currentPage].name,
        title: newListInfo[currentPage].subtitle,
        artUri: Uri.parse(newListInfo[currentPage].image),
      ),
    );

    _audioPlayer.setAudioSource(audioSource);
    _audioPlayer.playerStateStream.listen((playerState) {
      _onPlayerCompletion(playerState);
    });
  }

  void refreshAudioUrls(PlayerState playerState) {
    if (playerState.processingState == ProcessingState.loading) {
      for (int i = 0; i < newListInfo.length; i++) {
        if (i != 0) {
          newListInfo[i].audioUrl =
              'https://download.quranicaudio.com/qdc/siddiq_minshawi/murattal/${Random().nextInt(114) + 1}.mp3';
        }
      }
      notifyListeners(); // Notify listeners to rebuild the UI with updated audio URLs
    }

    notifyListeners();
  }

  void onPageChanged(index) {
    currentPage = index;

    playAudio();
  }

  void onNextPagePressed() {
    if (currentPage < newListInfo.length - 1) {
      currentPage++;
      playAudio(); // Play the audio for the new page
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      // currentPage = 0; // Return to the first page
      // playAudio(); // Play the audio for the first page
      // pageController.animateToPage(
      //   currentPage,
      //   duration: const Duration(milliseconds: 300),
      //   curve: Curves.ease,
      // );
    }
  }

  void previousPagePressed() {
    if (currentPage > 0) {
      currentPage--;
      playAudio(); // Play the audio for the new page
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }
}
