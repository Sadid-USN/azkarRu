import 'dart:math';
import 'package:animate_icons/animate_icons.dart';
import 'package:avrod/models/radio_audioplayer.dart';
import 'package:avrod/screens/text_screen.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

class RadioController extends ChangeNotifier {
  late final AudioPlayer _radioAaudioPlayer = AudioPlayer();
  final AnimateIconController refreshController = AnimateIconController();

  RadioController() {
    
    currentPage = 0;
    pageController = PageController(initialPage: currentPage);
  }

  
 

  

  List<InfoData> newListInfo = [];

  AudioPlayer get audioPlayer => _radioAaudioPlayer;
  late int currentPage;
  late PageController pageController;

  late int? lastReadedPage;

  Stream<PositioneData> get radioPositioneDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositioneData>(
          _radioAaudioPlayer.positionStream,
          _radioAaudioPlayer.bufferedPositionStream,
          _radioAaudioPlayer.durationStream,
          (positione, bufferedPosition, duration) => PositioneData(
                positione,
                bufferedPosition,
                duration ?? Duration.zero,
              ));

  void _onPlayerCompletion(PlayerState playerState) {
    if (playerState.processingState == ProcessingState.completed) {
      _radioAaudioPlayer
          .seek(Duration.zero); // Reset to the beginning of the audio
      _radioAaudioPlayer.pause(); // Pause the audio when it completes
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

    _radioAaudioPlayer.setAudioSource(audioSource);
    _radioAaudioPlayer.playerStateStream.listen((playerState) {
      _onPlayerCompletion(playerState);
      
    });
  }

  void refreshAudioUrls() {
  _radioAaudioPlayer.playerStateStream.listen((playerState) {
    if (playerState.processingState == ProcessingState.loading) {
      for (int i = 0; i < newListInfo.length; i++) {
        if (i != 0) {
          newListInfo[i].audioUrl =
              'https://download.quranicaudio.com/qdc/siddiq_minshawi/murattal/${Random().nextInt(114) + 1}.mp3';
        }
         notifyListeners(); 
      }
      notifyListeners(); // Notify listeners to rebuild the UI with updated audio URLs
    }
  });
}

  void onPageChanged(index) {
    currentPage = index;

    playAudio();
  }

  void onNextPagePressed() {
    if (currentPage < newListInfo.length - 1) {
      currentPage++;
       refreshAudioUrls();
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
      refreshAudioUrls();
      playAudio(); // Play the audio for the new page
      
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }
}
