import 'package:animate_icons/animate_icons.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioController extends ChangeNotifier {
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  final AnimateIconController copyController = AnimateIconController();
  final AnimateIconController controller = AnimateIconController();
  final AnimateIconController buttonController = AnimateIconController();
  Duration duration = const Duration();
  Duration position = const Duration();
  bool isPlaying = false;
  String? url;

  void playSound(String url) async {
    // ignore: unrelated_type_equality_checks
    if (!isPlaying) {
      var result = await audioPlayer.play(url);
      if (result == 1) {
        isPlaying = true;
      }
    }
    audioPlayer.onDurationChanged.listen((event) {
      duration = event;
    });

    audioPlayer.onAudioPositionChanged.listen((event) {
      position = event;
    });
    notifyListeners();
  }

  void stopPlaying() async {
    if (isPlaying) {
      var reslult = await audioPlayer.stop();
      if (reslult == 1) {
        isPlaying = false;
      }
      notifyListeners();
    }
  }

  void seekAudio(Duration durationToSeek) {
    audioPlayer.seek(durationToSeek);
    notifyListeners();
  }

  void pauseSound() async {
    if (isPlaying) {
      var result = await audioPlayer.pause();

      if (result == 1) {
        isPlaying = false;
      }
    }
    notifyListeners();
  }
}
