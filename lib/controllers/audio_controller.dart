import 'dart:math';

import 'package:animate_icons/animate_icons.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../models/radio_audioplayer.dart';

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
    if (this.url != url) {
      await stopPlaying();
    }

    if (!isPlaying) {
      var result = await audioPlayer.play(url);
      if (result == 1) {
        isPlaying = true;
        this.url = url;
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

  Future<void> stopPlaying() async {
    if (isPlaying) {
      var result = await audioPlayer.stop();
      if (result == 1) {
        isPlaying = false;
        url = null;
      }
    }
    notifyListeners();
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

  void skipTrack() {
    final randomIndex = Random().nextInt(listInfo.length);

    // Get the audio URL for the new track
    var audioUrl = listInfo[randomIndex].audioUrl;

    // Stop the currently playing track and start the new one
    stopPlaying();
    playSound(audioUrl);
  }
}
