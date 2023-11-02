import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

import 'package:avrod/data/book_model.dart';
import 'package:avrod/generated/locale_keys.g.dart';
import 'package:avrod/widgets/popup_menu_btutton.dart';

class AudioPlayerBottomSheet extends StatelessWidget {
  final void Function()? increaseSize;
  final void Function()? decreaseSize;

  final AudioPlayer audioPlayer;
  final Chapters chapter;
  final List<Texts> texts;
  final int currentIndex;
  final Stream<PositioneData> positioneDataStream;
  const AudioPlayerBottomSheet({
    Key? key,
    required this.increaseSize,
    required this.decreaseSize,
    required this.audioPlayer,
    required this.chapter,
    required this.texts,
    required this.currentIndex,
    required this.positioneDataStream,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      height: 15.5.h,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Color.fromARGB(255, 55, 100, 4),
      ),
      child: Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Share.share(
                          '*${chapter.name}\n\n${texts[currentIndex].text!}\n\n❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃\n\n${texts[currentIndex].arabic!}\n\n${texts[currentIndex].translation!}\n\n${texts[currentIndex].url!}\n\n❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃\n\n${LocaleKeys.downloadText.tr()}\n\n👇👇👇👇\n\nhttps://play.google.com/store/apps/details?id=com.darulasar.Azkar');
                    },
                    icon: const Icon(Icons.share,
                        size: 30.0, color: Colors.white),
                  ),
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
                          iconSize: 40,
                          onPressed: audioPlayer.stop,
                        );
                      } else if (playing != true || completed) {
                        return IconButton(
                          color: Colors.white,
                          disabledColor: Colors.grey,
                          icon: const Icon(Icons.play_circle_outline),
                          iconSize: 40,
                          onPressed: audioPlayer.play,
                        );
                      } else {
                        return IconButton(
                          color: Colors.white,
                          disabledColor: Colors.grey,
                          icon: const Icon(Icons.pause_circle_outline),
                          iconSize: 40,
                          onPressed: audioPlayer.pause,
                        );
                      }
                    },
                  ),
                  StreamBuilder<double>(
                    stream: audioPlayer.speedStream,
                    builder: (context, snapshot) => PopupMenuButtonWidget(
                      speedStream: audioPlayer.speedStream,
                      onSpeedSelected: (double newwidget) {
                        audioPlayer.setSpeed(newwidget);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 8),
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text("Enlarge text"),
                                    IconButton(
                                      onPressed: decreaseSize,
                                      icon: const Icon(Icons.remove),
                                    ),
                                    IconButton(
                                      onPressed: increaseSize,
                                      icon: const Icon(Icons.add),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.white,
                        ),
                      )),
                  const Spacer(),
                  StreamBuilder<PositioneData>(
                    stream: positioneDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;

                      return SizedBox(
                        width: 220,
                        child: ProgressBar(
                          barHeight: 4,
                          baseBarColor: Colors.grey.shade400,
                          bufferedBarColor: Colors.white,
                          progressBarColor: Colors.cyanAccent,
                          thumbColor: Colors.cyanAccent,
                          thumbRadius: 6,
                          timeLabelTextStyle: const TextStyle(
                              height: 1.2,
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                          progress: positionData?.positione ?? Duration.zero,
                          buffered:
                              positionData?.bufferedPosition ?? Duration.zero,
                          total: positionData?.duration ?? Duration.zero,
                          onSeek: audioPlayer.seek,
                        ),
                      );
                    },
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PositioneData {
  final Duration positione;
  final Duration bufferedPosition;
  final Duration duration;
  PositioneData(
    this.positione,
    this.bufferedPosition,
    this.duration,
  );
}
