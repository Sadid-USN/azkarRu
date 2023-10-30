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
  double _fontSize = 18.sp;
  late int currentIndex;
  late final AudioPlayer _audioPlayer = AudioPlayer();
  final double _arabicFontSize = 24.sp;
  InternetConnectionController? internetConnectionController;
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    internetConnectionController = InternetConnectionController(Connectivity());
    internetConnectionController!.listenTonetworkChacges(context);
    _fontSize = textStorage.read('fontSize') ?? 18.0;

    currentIndex = 0;
    _tabController = TabController(length: widget.texts!.length, vsync: this);
    _pageController = PageController();
    playAudio();
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

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void playAudioForTab(int index) {
    if (currentIndex != index) {
      currentIndex = index;
      _audioPlayer.pause();
      playAudio();
    }
  }

  void goToTab(int tabIndex) {
    if (tabIndex >= 0 && tabIndex < widget.texts!.length) {
      _tabController.animateTo(tabIndex);
      playAudioForTab(tabIndex);
    }
  }

  void goToNextTab() {
    final nextIndex = _tabController.index + 1;
    if (nextIndex < widget.texts!.length) {
      _tabController.animateTo(nextIndex);
   
      playAudioForTab(nextIndex);
    }
  }

  void goToPreviousTab() {
    final previousIndex = _tabController.index - 1;
    if (previousIndex >= 0) {
      _tabController.animateTo(previousIndex);
      playAudioForTab(previousIndex);
    }
  }

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

  void _onPlayerCompletion(PlayerState playerState) {
    if (playerState.processingState == ProcessingState.completed) {
      _audioPlayer.seek(Duration.zero); // Reset to the beginning of the audio
      _audioPlayer.pause(); // Pause the audio when it completes
    }
  }

  void playAudio() {
    final audioSource = AudioSource.uri(
      Uri.parse(widget.texts![currentIndex].url ?? ""),
      tag: MediaItem(
        id: widget.texts![currentIndex].id.toString(),
        album: widget.chapter?.name,
        title: widget.chapter?.name ?? "_",
        artUri: Uri.parse(widget.chapter?.listimage ?? "_"),
      ),
    );

    _audioPlayer.setAudioSource(audioSource);
    _audioPlayer.playerStateStream.listen((playerState) {
      _onPlayerCompletion(playerState);
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return DefaultTabController(
      length: widget.texts?.length ?? 0,
      child: WillPopScope(
        onWillPop: () async {
          _audioPlayer.stop();

          return true;
        },
        child: Scaffold(
          backgroundColor: bgColor,
          bottomSheet: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 14.5.h,
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
                            '*${widget.chapter?.name}\n\n${widget.texts?[currentIndex].text!}\n\n❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃\n\n${widget.texts?[currentIndex].arabic!}\n\n${widget.texts?[currentIndex].translation!}\n\n${widget.texts?[currentIndex].url!}\n\n❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃❃\n\n${LocaleKeys.downloadText.tr()}\n\n👇👇👇👇\n\nhttps://play.google.com/store/apps/details?id=com.darulasar.Azkar');
                      },
                      icon: const Icon(Icons.share,
                          size: 30.0, color: Colors.white),
                    ),
                    // IconButton(
                    //   onPressed: () {
                    //     goToPreviousTab();
                    //   },
                    //   icon: const Icon(
                    //     Icons.skip_previous,
                    //     color: Colors.white,
                    //   ),
                    // ),
                    StreamBuilder<PlayerState>(
                      stream: _audioPlayer.playerStateStream,
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
                            onPressed: _audioPlayer.stop,
                          );
                        } else if (playing != true || completed) {
                          return IconButton(
                            color: Colors.white,
                            disabledColor: Colors.grey,
                            icon: const Icon(Icons.play_circle_outline),
                            iconSize: 40,
                            onPressed: _audioPlayer.play,
                          );
                        } else {
                          return IconButton(
                            color: Colors.white,
                            disabledColor: Colors.grey,
                            icon: const Icon(Icons.pause_circle_outline),
                            iconSize: 40,
                            onPressed: _audioPlayer.pause,
                          );
                        }
                      },
                    ),
                    // IconButton(
                    //   onPressed: () {
                    //     goToNextTab();
                    //   },
                    //   icon: const Icon(
                    //     Icons.skip_next,
                    //     color: Colors.white,
                    //   ),
                    // ),
                    StreamBuilder<double>(
                      stream: _audioPlayer.speedStream,
                      builder: (context, snapshot) => PopupMenuButtonWidget(
                        speedStream: _audioPlayer.speedStream,
                        onSpeedSelected: (double newwidget) {
                          _audioPlayer.setSpeed(newwidget);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                StreamBuilder<PositioneData>(
                    stream: positioneDataStream,
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
                          onSeek: _audioPlayer.seek,
                        ),
                      );
                    }),
              ],
            ),
          ),
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                _audioPlayer.stop();

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
              controller: _tabController,
              isScrollable: true,
              tabs: List<Widget>.generate(
                widget.texts?.length ?? 0,
                (index) {
                  return Tab(
                    text: widget.texts![index].id,
                  );
                },
              ),
            ),

            // TabBar(
            //   controller: _tabController,
            //   onTap : playAudioForTab,
            //   labelColor: titleAbbBar,
            //   indicatorColor: titleAbbBar,
            //   isScrollable: true,
            //   tabs: widget.texts!.map((Texts e) => Tab(text: e.id)).toList(),
            // ),
          ),
          body: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: PageView.builder(
                  onPageChanged: goToTab,
                  controller: _pageController,
                  itemCount: widget.texts!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: mainScreenGradient,
                      child: Builder(builder: (context) {
                        return AllTextsContent(
                          arabicFontSize: _arabicFontSize,
                          text: widget.texts![index].text!,
                          arabic: widget.texts![index].arabic!,
                          translation: widget.texts![index].translation!,
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
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Widget> generateDots(List<Texts> texts, int currentPage) {
  return texts.map((text) {
    int dotCount = text.id!.length; // Get the length of the id
    return Row(
      children: List.generate(dotCount, (index) {
        return AnimatedContainer(
          margin: const EdgeInsets.only(right: 4),
          duration: const Duration(milliseconds: 300),
          height: 6,
          width: currentPage == index ? 20 : 6,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(12),
          ),
        );
      }),
    );
  }).toList();
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

class DotWidget extends StatelessWidget {
  final bool isCurrentPage;

  const DotWidget({Key? key, required this.isCurrentPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.all(isCurrentPage ? 5 : 0),
      width: isCurrentPage ? 20 : 10, // You can adjust the sizes
      height: 10, // You can adjust the sizes
      decoration: BoxDecoration(
        color: isCurrentPage
            ? Colors.blue
            : Colors.grey, // Change the colors as needed
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
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
