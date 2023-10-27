import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'package:avrod/colors/colors.dart';
import 'package:avrod/colors/gradient_class.dart';
import 'package:avrod/controllers/audio_controller.dart';
import 'package:avrod/controllers/internet_chacker.dart';
import 'package:avrod/core/addbunner_helper.dart';
import 'package:avrod/data/book_map.dart';
import 'package:avrod/generated/locale_keys.g.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

import '../font_storage.dart';
import 'content_all_text.dart';

class TextScreen extends StatefulWidget {
  final List<Texts>? texts;
  final Chapters? chapter;
  final int? index;

  const TextScreen({Key? key, this.texts, this.chapter, this.index})
      : super(key: key);

  @override
  _TextScreenState createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen>
    with SingleTickerProviderStateMixin {
  // int currentIndex = 0;
  // late final AudioPlayer _audioPlayer = AudioPlayer();
  // bool isPlaying = false;
  // late TabController _tabController;

  double _fontSize = 18.sp;
  final double _arabicFontSize = 24.sp;
  InternetConnectionController? internetConnectionController;
  BannerAdHelper bannerAdHelper = BannerAdHelper();
  @override
  void initState() {
    super.initState();
    var cntroller = Provider.of<AudioController>(context, listen: false);

    bannerAdHelper.initializeAdMob(
      onAdLoaded: (ad) {
        bannerAdHelper.isBannerAd = true;
      },
    );

    internetConnectionController = InternetConnectionController(Connectivity());
    internetConnectionController!.listenTonetworkChacges(context);
    _fontSize = textStorage.read('fontSize') ?? 18.0;

    cntroller.chapter = widget.chapter;
    cntroller.texts = widget.texts!;

    cntroller.tabController =
        TabController(length: cntroller.texts.length, vsync: this);

    cntroller.playAudio();
  }

  void increaseSize() {
    if (_fontSize < 25.0) {
      _fontSize++;
      textStorage.write('fontSize', _fontSize);
    }
  }

  void decreaseSize() {
    if (_fontSize > 14.0) {
      _fontSize--;
      textStorage.write('fontSize', _fontSize);
    }
  }

  // void playAudioForTab(int index) {
  //   if (currentIndex != index) {
  //     currentIndex = index;
  //     _audioPlayer.pause();
  //     playAudio();
  //   }
  // }

  // void goToNextTab() {
  //   final nextIndex = _tabController.index + 1;
  //   if (nextIndex < widget.texts!.length) {
  //     _tabController.animateTo(nextIndex);
  //     playAudioForTab(nextIndex);
  //   }
  // }

  // void goToPreviousTab() {
  //   final previousIndex = _tabController.index - 1;
  //   if (previousIndex >= 0) {
  //     _tabController.animateTo(previousIndex);
  //     playAudioForTab(previousIndex);
  //   }
  // }

  // Stream<PositioneData> get positioneDataStream =>
  //     Rx.combineLatest3<Duration, Duration, Duration?, PositioneData>(
  //         _audioPlayer.positionStream,
  //         _audioPlayer.bufferedPositionStream,
  //         _audioPlayer.durationStream,
  //         (positione, bufferedPosition, duration) => PositioneData(
  //               positione,
  //               bufferedPosition,
  //               duration ?? Duration.zero,
  //             ));

  // void _onPlayerCompletion(PlayerState playerState) {
  //   if (playerState.processingState == ProcessingState.completed) {
  //     _audioPlayer.seek(Duration.zero); // Reset to the beginning of the audio
  //     _audioPlayer.pause(); // Pause the audio when it completes
  //   }
  // }

  // void playAudio() {
  //   final audioSource = AudioSource.uri(
  //     Uri.parse(widget.texts![currentIndex].url ?? ""),
  //     tag: MediaItem(
  //       id: widget.texts![currentIndex].id.toString(),
  //       album: widget.chapter?.name,
  //       title: widget.chapter?.name ?? "_",
  //       artUri: Uri.parse(widget.chapter?.listimage ?? "_"),
  //     ),
  //   );

  //   _audioPlayer.setAudioSource(audioSource);
  //   _audioPlayer.playerStateStream.listen((playerState) {
  //     _onPlayerCompletion(playerState);
  //   });
  // }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Consumer<AudioController>(
      builder: (context, value, child) => DefaultTabController(
        length: value.texts.length,
        child: WillPopScope(
          onWillPop: () async {
            value.audioPlayer.stop();
            return true;
          },
          child: Scaffold(
            backgroundColor: bgColor,
            bottomSheet: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              height: 13.5.h,
              color: const Color.fromARGB(255, 55, 100, 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          Share.share(
                              '*${widget.chapter?.name}*\n${widget.texts![value.currentIndex].text!}\n☘️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️☘️\n${widget.texts![value.currentIndex].arabic!}\n${widget.texts![value.currentIndex].translation!}\n☘️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️☘️\n${LocaleKeys.downloadText.tr()}\n👇👇👇👇\nhttps://play.google.com/store/apps/details?id=com.darulasar.Azkar');
                        },
                        icon: const Icon(Icons.share,
                            size: 30.0, color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () {
                          value.goToPreviousTab();
                        },
                        icon: const Icon(
                          Icons.skip_previous,
                          color: Colors.white,
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
                                color: Colors.grey,
                              ),
                              iconSize: 35,
                              onPressed: value.audioPlayer.stop,
                            );
                          } else if (playing != true || completed) {
                            return IconButton(
                              color: Colors.white,
                              disabledColor: Colors.grey,
                              icon: const Icon(Icons.play_circle_outline),
                              iconSize: 35,
                              onPressed: value.audioPlayer.play,
                            );
                          } else {
                            return IconButton(
                              color: Colors.white,
                              disabledColor: Colors.grey,
                              icon: const Icon(Icons.pause_circle_outline),
                              iconSize: 35,
                              onPressed: value.audioPlayer.pause,
                            );
                          }
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          value.goToNextTab();
                        },
                        icon: const Icon(
                          Icons.skip_next,
                          color: Colors.white,
                        ),
                      ),
                      StreamBuilder<double>(
                        stream: value.audioPlayer.speedStream,
                        builder: (context, snapshot) => PopupMenuButtonWidget(
                          speedStream: value.audioPlayer.speedStream,
                          onSpeedSelected: (double newValue) {
                            value.audioPlayer.setSpeed(newValue);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  StreamBuilder<PositioneData>(
                      stream: value.positioneDataStream,
                      builder: (context, snapshot) {
                        final positionData = snapshot.data;

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 70),
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
                            onSeek: value.audioPlayer.seek,
                          ),
                        );
                      }),
                ],
              ),
            ),
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  value.audioPlayer.stop();
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: iconColor,
                ),
              ),
              elevation: 3.0,
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  widget.chapter?.name ?? "",
                  style: TextStyle(
                      color: textColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              centerTitle: true,
              flexibleSpace: Container(
                decoration: const BoxDecoration(color: appBarbg),
              ),
              bottom: TabBar(
                controller: value.tabController,
                onTap: value.playAudioForTab,
                labelColor: titleAbbBar,
                indicatorColor: titleAbbBar,
                isScrollable: true,
                tabs: widget.texts!.map((Texts e) => Tab(text: e.id)).toList(),
              ),
            ),
            body: Column(
              children: [
                bannerAdHelper.isBannerAd
                    ? SizedBox(
                        height: bannerAdHelper.bannerAd.size.height.toDouble(),
                        width: bannerAdHelper.bannerAd.size.width.toDouble(),
                        child: AdWidget(ad: bannerAdHelper.bannerAd),
                      )
                    : const SizedBox(),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 2 * 1.5,
                  child: TabBarView(
                    controller: value.tabController,
                    children: value.texts
                        .map(
                          (texts) => Container(
                            decoration: mainScreenGradient,
                            child: Builder(builder: (context) {
                              return AllTextsContent(
                                arabicFontSize: _arabicFontSize,
                                text: texts.text!,
                                arabic: texts.arabic!,
                                translation: texts.translation!,
                                fontSize: _fontSize,
                                increaseSize: () {
                                  setState(() {
                                    increaseSize();
                                  });
                                },
                                decreaseSize: () {
                                  setState(() {
                                    decreaseSize();
                                  });
                                },
                              );
                            }),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
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

class PopupMenuButtonWidget extends StatelessWidget {
  final Stream<double> speedStream;
  final Function(double) onSpeedSelected;

  const PopupMenuButtonWidget(
      {Key? key, required this.speedStream, required this.onSpeedSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<double>(
      elevation: 3,
      surfaceTintColor: const Color(0xff376404),
      itemBuilder: (context) {
        return <PopupMenuEntry<double>>[
          PopupMenuItem<double>(
            value: 0.25,
            child: Text("0.25",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
          ),
          PopupMenuItem<double>(
            value: 0.5,
            child: Text("0.5",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
          ),
          PopupMenuItem<double>(
            value: 0.75,
            child: Text("0.75",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
          ),
          PopupMenuItem<double>(
            value: 1.0,
            child: Text("Normal",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
          ),
          PopupMenuItem<double>(
            value: 1.25,
            child: Text("1.25x",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
          ),
          PopupMenuItem<double>(
            value: 1.5,
            child: Text("1.5x",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
          ),
          PopupMenuItem<double>(
            value: 1.75,
            child: Text("1.75x",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
          ),
          PopupMenuItem<double>(
            value: 2.0,
            child: Text("2.0x",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
          ),
        ];
      },
      onSelected: onSpeedSelected,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(8),
        ),
        child: StreamBuilder<double>(
          stream: speedStream,
          builder: (context, snapshot) {
            return Text(
              "${snapshot.data?.toStringAsFixed(1)}x",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            );
          },
        ),
      ),
    );
  }
}
