import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:avrod/widgets/audio_palayer_bottom_sheet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:avrod/controllers/radio_conteroller.dart';
import 'package:avrod/core/addbunner_helper.dart';
import 'package:avrod/data/reciters_data_list.dart';
import 'package:avrod/generated/locale_keys.g.dart';
import 'package:avrod/widgets/popup_menu_btutton.dart';

class RadioAudioPlayer extends StatefulWidget {
  // final int? index;
  const RadioAudioPlayer({
    Key? key,
    // this.index,
  }) : super(key: key);

  @override
  State<RadioAudioPlayer> createState() => _RadioAudioPlayerState();
}

class _RadioAudioPlayerState extends State<RadioAudioPlayer> {
  int currenIndex = 0;
  @override
  void initState() {
    final controller = Provider.of<RadioController>(context, listen: false);
    controller.newListInfo = reciters;
    controller.playAudio();

    super.initState();
  }

 
  @override
  Widget build(BuildContext context) {
    // final PageController pageController = PageController();
    return AnimationLimiter(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Consumer<RadioController>(
          builder: (context, audioController, child) => PageView.builder(
            controller: audioController.pageController,
            itemCount: audioController.newListInfo.length,
            onPageChanged: (index) {
              audioController.audioPlayer.stop();
              audioController.onPageChanged(index);
            },
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 400),
                columnCount: audioController.newListInfo.length,
                child: ScaleAnimation(
                  child: AudiPlyerCard(
                    index: index,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class AudiPlyerCard extends StatefulWidget {
  final int index;
  const AudiPlyerCard({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<AudiPlyerCard> createState() => _AudiPlyerCardState();
}

class _AudiPlyerCardState extends State<AudiPlyerCard> {
  late BannerAdHelper bannerAdHelper = BannerAdHelper();

  @override
  void initState() {
    super.initState();

    bannerAdHelper.initializeAdMob(
      onAdLoaded: (ad) {
        setState(() {
          bannerAdHelper.isBannerAd = true;
        });
      },
    );
  }

  @override
  void dispose() {
    bannerAdHelper.bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RadioController>(
      builder: (context, value, child) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          bannerAdHelper.isBannerAd
              ? SizedBox(
                  height: bannerAdHelper.bannerAd.size.height.toDouble(),
                  width: bannerAdHelper.bannerAd.size.width.toDouble(),
                  child: AdWidget(ad: bannerAdHelper.bannerAd),
                )
              : const SizedBox(
                  height: 40,
                ),
          const Spacer(),
          CircleAvatar(
            backgroundImage: NetworkImage(reciters[widget.index].image),
            radius: 120,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            reciters[widget.index].subtitle,
            style: const TextStyle(
              color: Colors.blueGrey,
              fontSize: 20,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
            decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.index == 0
                    ? const SizedBox()
                    : _SurahsDropdownButton(
                        audioPlayer: value.audioPlayer,
                        selectedChapter: value.selectedChapter,
                        quranChapters: quranChapters.entries.toList(),
                        onChapterSelected: (int chapter) {
                          value.selectedChapter = chapter;
                          value.refreshAudioUrls(value.reciterNames, chapter);
                          Future.delayed(const Duration(milliseconds: 20), () {
                            value.playAudio();
                          });
                        },
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: value.previousPagePressed,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                      ),
                      child: const Icon(
                        Icons.skip_previous,
                        color: Colors.blueGrey,
                        size: 30,
                      ),
                    ),
                    StreamBuilder<PlayerState>(
                      stream: value.audioPlayer.playerStateStream,
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
                            iconSize: 60,
                            onPressed: value.audioPlayer.stop,
                          );
                        } else if (playing != true || completed) {
                          return IconButton(
                            color: Colors.white,
                            disabledColor: Colors.grey,
                            icon: const Icon(Icons.play_circle_outline),
                            iconSize: 60,
                            onPressed: value.audioPlayer.play,
                          );
                        } else {
                          return IconButton(
                            color: Colors.white,
                            disabledColor: Colors.grey,
                            icon: const Icon(Icons.pause_circle_outline),
                            iconSize: 60,
                            onPressed: value.audioPlayer.pause,
                          );
                        }
                      },
                    ),
                    ElevatedButton(
                      onPressed: value.onNextPagePressed,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(90.0),
                        ),
                      ),
                      child: const Icon(
                        Icons.skip_next,
                        color: Colors.blueGrey,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8.0,
                ),
                widget.index == 0
                    ? const SizedBox()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StreamBuilder<PositioneData>(
                            stream: value.radioPositioneDataStream,
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
                                  progress:
                                      positionData?.positione ?? Duration.zero,
                                  buffered: positionData?.bufferedPosition ??
                                      Duration.zero,
                                  total:
                                      positionData?.duration ?? Duration.zero,
                                  onSeek: value.audioPlayer.seek,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SurahsDropdownButton extends StatelessWidget {
  final int selectedChapter;
  final AudioPlayer audioPlayer;
  final List<MapEntry<String, int>> quranChapters;
  final Function(int) onChapterSelected;

  const _SurahsDropdownButton({
    Key? key,
    required this.selectedChapter,
    required this.audioPlayer,
    required this.quranChapters,
    required this.onChapterSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.only(right: 5),
      alignment: Alignment.bottomRight,
      //width: MediaQuery.sizeOf(context).width /2,
      decoration: const BoxDecoration(color: Colors.black38),
      child: PopupMenuButton<int>(
        onSelected: (int chapter) {
          onChapterSelected(chapter);
        },
        itemBuilder: (BuildContext context) {
          return quranChapters.map((MapEntry<String, int> entry) {
            return PopupMenuItem<int>(
              value: entry.value,
              child: Text(entry.key),
            );
          }).toList();
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            StreamBuilder<double>(
              stream: audioPlayer.speedStream,
              builder: (context, snapshot) => PopupMenuButtonWidget(
                containerColor: Colors.blueGrey,
                speedStream: audioPlayer.speedStream,
                onSpeedSelected: (double newwidget) {
                  audioPlayer.setSpeed(newwidget);
                },
              ),
            ),
            const Spacer(),
            Text(
              "${LocaleKeys.surah.tr()}: ${quranChapters.firstWhere(
                    (entry) => entry.value == selectedChapter,
                    orElse: () => const MapEntry("Al-Fatihah", 1),
                  ).key}",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            const Icon(
              Icons.arrow_drop_down,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class InfoData {
  String id;
  String image;
  String? audioUrl;
  String name;
  String subtitle;
  InfoData(
      {required this.id,
      required this.image,
      required this.name,
      required this.subtitle,
      this.audioUrl});
}
