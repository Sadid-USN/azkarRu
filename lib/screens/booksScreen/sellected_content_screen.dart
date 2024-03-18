import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:avrod/colors/colors.dart';
import 'package:avrod/controllers/library_controller.dart';
import 'package:avrod/generated/locale_keys.g.dart';
import 'package:avrod/models/lib_book_model.dart';
import 'package:avrod/screens/booksScreen/book_reading_screen.dart';
import 'package:avrod/widgets/audio_palayer_bottom_sheet.dart';
import 'package:avrod/widgets/popup_menu_btutton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class SellectedContentScreen extends StatelessWidget {
  final LibChapters chapter;
  final int page;

  const SellectedContentScreen({
    Key? key,
    required this.chapter,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String sourceText =
        chapter.sources!.map((source) => source.source).join('\n');
    return Consumer<LibraryController>(
      builder: (context, value, child) => Scaffold(
          backgroundColor: bgColor,
          extendBodyBehindAppBar: true,
          body: PopScope(
            canPop: true,
            onPopInvoked: (bool didPop) async {
              if (didPop) {
                value.audioPlayer.stop();
                Navigator.of(context).pop();
              }
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: SafeArea(
                  child: Column(
                    children: [
                      Center(
                        child: Image.asset(
                          "icons/pattern.png",
                          height: 60,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SelectableText(
                        chapter.subtitle ?? "_",
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: SelectableText(
                          chapter.text ?? '',
                          style: TextStyle(
                            color: Colors.grey.shade800,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SelectableText(
                        sourceText,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          letterSpacing: 1.2,
                          color: Colors.blueGrey[900],
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Center(
                        child: Image.asset(
                          "icons/pattern.png",
                          height: 60,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Center(
                          child: Text(
                            page.toString(),
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            final subtitle = chapter.subtitle;
                            final text = chapter.text;
                            final audioUrl = chapter.url;
                            final sentByAzkar = LocaleKeys.sentByAzkarApp.tr();
                            Share.share(
                                "$subtitle\n$text\n\nAudio 🔊\n\n👇👇👇\n$audioUrl\n\n👇👇👇\n$sentByAzkar\n$appLink");
                          },
                          child: Image.asset(
                            "icons/shared.png",
                            height: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottomNavigationBar: chapter.isAudioUrl == true
              ? Consumer<LibraryController>(
                  builder: (context, value, child) =>
                      SellectedContentAudioPlayer(
                    audioUrl: chapter.url ??
                        'https://download.quranicaudio.com/qdc/hani_ar_rifai/murattal/1.mp3',
                    audioPlayer: value.audioPlayer,
                    positioneDataStream: value.positioneDataStream,
                  ),
                )
              : const SizedBox.shrink()),
    );
  }
}

class SellectedContentAudioPlayer extends StatelessWidget {
  final AudioPlayer audioPlayer;
  final Stream<PositioneData> positioneDataStream;
  final String audioUrl;

  const SellectedContentAudioPlayer({
    Key? key,
    required this.audioPlayer,
    required this.positioneDataStream,
    required this.audioUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(audioUrl)));

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 12.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StreamBuilder<PlayerState>(
                  stream: audioPlayer.playerStateStream,
                  builder: (context, snapshot) {
                    final playerState = snapshot.data;
                    final processingState = playerState?.processingState;
                    final playing = playerState?.playing;
                    final completed =
                        processingState == ProcessingState.completed;

                    if (processingState == ProcessingState.loading ||
                        processingState == ProcessingState.buffering) {
                      return IconButton(
                        icon: const CircularProgressIndicator(
                          strokeWidth: 3.0,
                          color: Colors.grey,
                        ),
                        iconSize: 35,
                        onPressed: audioPlayer.stop,
                      );
                    } else if (playing != true || completed) {
                      return IconButton(
                        color: Colors.blueGrey,
                        disabledColor: Colors.grey,
                        icon: const Icon(Icons.play_circle_outline),
                        iconSize: 50,
                        onPressed: audioPlayer.play,
                      );
                    } else {
                      return IconButton(
                        color: Colors.blueGrey,
                        disabledColor: Colors.grey,
                        icon: const Icon(Icons.pause_circle_outline),
                        iconSize: 50,
                        onPressed: audioPlayer.pause,
                      );
                    }
                  },
                ),
                StreamBuilder<PositioneData>(
                  stream: positioneDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;

                    return SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      child: ProgressBar(
                        barHeight: 4,
                        baseBarColor: Colors.grey.shade400,
                        bufferedBarColor: Colors.white,
                        progressBarColor: Colors.blueGrey,
                        thumbColor: Colors.green.shade800,
                        thumbRadius: 6,
                        timeLabelTextStyle: const TextStyle(
                          height: 1.2,
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        progress: positionData?.positione ?? Duration.zero,
                        buffered:
                            positionData?.bufferedPosition ?? Duration.zero,
                        total: positionData?.duration ?? Duration.zero,
                        onSeek: audioPlayer.seek,
                      ),
                    );
                  },
                ),
                StreamBuilder<double>(
                  stream: audioPlayer.speedStream,
                  builder: (context, snapshot) => PopupMenuButtonWidget(
                    speedStream: audioPlayer.speedStream,
                    onSpeedSelected: (double newValue) {
                      audioPlayer.setSpeed(newValue);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
