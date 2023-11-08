
import 'package:animate_icons/animate_icons.dart';
import 'package:avrod/data/reciters_data_list.dart';
import 'package:avrod/widgets/radio_audioplayer.dart';
import 'package:avrod/widgets/audio_palayer_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

class RadioController extends ChangeNotifier {
  late final AudioPlayer _radioAaudioPlayer = AudioPlayer();
  final AnimateIconController refreshController = AnimateIconController();
  late int selectedChapter;
  late int currentPage;
  RadioController() {
    currentPage = 0;
    selectedChapter = 1;
    pageController = PageController(initialPage: currentPage);
  }

  List<InfoData> newListInfo = [];
  List<String> reciterNames = [
    'siddiq_minshawi',
    'khalil_al_husary',
    'abdul_baset',
    'mishari_al_afasy',
    'abu_bakr_shatri',
    'khalifah_taniji',
    'hani_ar_rifai',
  ];

  AudioPlayer get audioPlayer => _radioAaudioPlayer;
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
      _radioAaudioPlayer.pause();
    }
  }

  void playAudio() {
    final audioSource = AudioSource.uri(
      Uri.parse(newListInfo[currentPage].audioUrl ?? ""),
      tag: MediaItem(
        id: newListInfo[currentPage].id,
        album: newListInfo[currentPage].name,
        title: newListInfo[currentPage].subtitle,
        artUri: Uri.parse(newListInfo[currentPage].image),
      ),
    );
    refreshAudioUrls(reciterNames, selectedChapter);
    _radioAaudioPlayer.setAudioSource(audioSource);
    _radioAaudioPlayer.playerStateStream.listen((playerState) {
      _onPlayerCompletion(playerState);
    });
  }

  void refreshAudioUrls(List<String> reciterNames, int indexChapter) {
    _radioAaudioPlayer.playerStateStream.listen((PlayerState playerState) {
      if (playerState.processingState == ProcessingState.loading ||
          playerState.processingState == ProcessingState.ready) {
        for (int i = 1; i < reciters.length; i++) {
          final reciterName = reciterNames[i - 1];
          //  final chapterNumber = indexChapter;
          final audioUrl =
              'https://download.quranicaudio.com/qdc/$reciterName/murattal/$indexChapter.mp3';

          reciters[i].audioUrl = audioUrl;
          reciters[i].name = reciterName;
        }
        notifyListeners();
      }
    });
  }

  void onPageChanged(index) {
    currentPage = index;

    playAudio();
    notifyListeners();
  }

  void onNextPagePressed() {
    if (currentPage < newListInfo.length) {
      currentPage++;
      refreshAudioUrls(reciterNames, selectedChapter);
  
      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    } else {
      // currentPage = 0; // Return to the first page
      // refreshAudioUrls();
      // playAudio(); // Play the audio for the first page
      // pageController.animateToPage(
      //   currentPage,
      //   duration: const Duration(milliseconds: 300),
      //   curve: Curves.ease,
      // );
      // notifyListeners();
    }
  }

  void previousPagePressed() {
    if (currentPage < newListInfo.length) {
      currentPage--;
      refreshAudioUrls(reciterNames, selectedChapter);
      // playAudio();

      pageController.animateToPage(
        currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }
}
