import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:share_plus/share_plus.dart';

import 'package:sizer/sizer.dart';

import 'package:avrod/models/book_model.dart';
import 'package:avrod/generated/locale_keys.g.dart';
import 'package:avrod/widgets/font_settings.dart';
import 'package:avrod/widgets/popup_menu_btutton.dart';

class AudioPlayerBottomSheet extends StatefulWidget {
  final void Function(double) onArabicFontSizeChanged;
  final void Function(double) onFontSizeChanged;

  final double fontSize;
  final double arabicFontSize;
  final AudioPlayer audioPlayer;
  final Chapters chapter;
  final List<Texts> texts;
  final int currentIndex;

  final Stream<PositioneData> positioneDataStream;
  const AudioPlayerBottomSheet({
    Key? key,
    required this.onArabicFontSizeChanged,
    required this.onFontSizeChanged,
    required this.fontSize,
    required this.arabicFontSize,
    required this.audioPlayer,
    required this.chapter,
    required this.texts,
    required this.currentIndex,
    required this.positioneDataStream,
  }) : super(key: key);

  @override
  State<AudioPlayerBottomSheet> createState() => _AudioPlayerBottomSheetState();
}

class _AudioPlayerBottomSheetState extends State<AudioPlayerBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      height: 15.5.h,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.blueGrey.withOpacity(0.7),
      ),
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
                        '*${widget.chapter.name}\n\n${widget.texts[widget.currentIndex].text!}\n\n❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃\n\n${widget.texts[widget.currentIndex].arabic!}\n\n${widget.texts[widget.currentIndex].translation!}\n\nAudio 🎵\n\n${widget.texts[widget.currentIndex].url!}\n\n❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃\n\n${LocaleKeys.downloadText.tr()}\n\n👇👇👇👇\n\nhttps://play.google.com/store/apps/details?id=com.darulasar.Azkar');
                  },
                  icon: const Icon(Icons.share,
                      size: 30.0, color: Colors.white),
                ),
                StreamBuilder<PlayerState>(
                  stream: widget.audioPlayer.playerStateStream,
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
                          color: Colors.white,
                        ),
                        iconSize: 40,
                        onPressed: widget.audioPlayer.stop,
                      );
                    } else if (playing != true || completed) {
                      return IconButton(
                        color: Colors.white,
                        disabledColor: Colors.grey,
                        icon: const Icon(Icons.play_circle_outline),
                        iconSize: 40,
                        onPressed: widget.audioPlayer.play,
                      );
                    } else {
                      return IconButton(
                        color: Colors.white,
                        disabledColor: Colors.grey,
                        icon: const Icon(Icons.pause_circle_outline),
                        iconSize: 40,
                        onPressed: widget.audioPlayer.pause,
                      );
                    }
                  },
                ),
                StreamBuilder<double>(
                  stream: widget.audioPlayer.speedStream,
                  builder: (context, snapshot) => PopupMenuButtonWidget(
                    speedStream: widget.audioPlayer.speedStream,
                    onSpeedSelected: (double newwidget) {
                      widget.audioPlayer.setSpeed(newwidget);
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
                      showModalBottomSheet(
                        context: context,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8 + 1)),
                        builder: (context) {
                          return FontsSettings(
                            fontSize: widget.fontSize,
                            arabicFontSize: widget.arabicFontSize,
                            onArabicFontSizeChanged:
                                widget.onArabicFontSizeChanged,
                            onFontSizeChanged: widget.onFontSizeChanged,
                          );
                        },
                      );
                    },
                    icon: Image.asset(
                      'icons/textsize.png',
                      color: Colors.white,
                      height: 25,
                    ),
                  ),
                ),
                const Spacer(),
                StreamBuilder<PositioneData>(
                  stream: widget.positioneDataStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;

                    return SizedBox(
                      width: 220,
                      child: ProgressBar(
                        barHeight: 4,
                        baseBarColor: Colors.grey.shade400,
                        bufferedBarColor: Colors.white,
                        progressBarColor: Colors.indigo.shade700,
                        thumbColor: Colors.indigo.shade700,
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
                        onSeek: widget.audioPlayer.seek,
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
