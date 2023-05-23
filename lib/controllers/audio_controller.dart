import 'package:animate_icons/animate_icons.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sizer/sizer.dart';

import '../colors/colors.dart';
import '../screens/text_screen.dart';

class AudioController extends ChangeNotifier {
  int selectedIndex = 0;

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

  void playAudio({
    required String url,
    required String id,
    required String album,
    required String title,
    required imgUrl,
  }) {
    _audioPlayer.setAudioSource(
      AudioSource.uri(
        Uri.parse(url),
        tag: MediaItem(
          id: id,
          album: album,
          title: title,
          artUri: Uri.parse(imgUrl),
        ),
      ),
    );
    _audioPlayer.play();

    notifyListeners();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  final navItems = [
    Icon(FontAwesomeIcons.home, color: textColor, size: 17.sp),
    Icon(
      FontAwesomeIcons.book,
      color: textColor,
      size: 17.sp,
    ),
    Icon(Icons.favorite, color: Colors.red, size: 17.sp),
    Icon(FontAwesomeIcons.calendarAlt, color: textColor, size: 17.sp),
    Icon(Icons.radio, color: textColor, size: 17.sp),
  ];

  void onTapBar(int index) {
    selectedIndex = index;
    _audioPlayer.stop();

    notifyListeners();
  }
}
