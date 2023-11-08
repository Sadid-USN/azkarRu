import 'package:avrod/colors/colors.dart';
import 'package:avrod/colors/gradient_class.dart';
import 'package:avrod/controllers/internet_chacker.dart';
import 'package:avrod/font_storage.dart';
import 'package:avrod/models/book_model.dart';
import 'package:avrod/widgets/audio_palayer_bottom_sheet.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sizer/sizer.dart';
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
  double _fontSize = 18.0;
  double _arabicFontSize = 31.0;
  late int currentIndex;
  late final AudioPlayer _audioPlayer = AudioPlayer();
  InternetConnectionController? internetConnectionController;
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();

    internetConnectionController = InternetConnectionController(Connectivity());

    internetConnectionController!.listenToNetworkChanges(context);

    _fontSize = textStorage.read('fontSize') ?? 18.0;

    _arabicFontSize = arabicTextStorage.read("arabicFont") ?? 25.0;

    currentIndex = 0;
    _tabController = TabController(length: widget.texts!.length, vsync: this);
    _pageController = PageController();

    playAudio();
  }

  void onArabicFontSizeChanged(double value) {
    setState(() {
      _arabicFontSize = value;
      arabicTextStorage.write("arabicFont", _arabicFontSize);
    });
  }

  void onFontSizeChanged(double value) {
    setState(() {
      _fontSize = value;
      textStorage.write('fontSize', _fontSize);
    });
  }

  //   void increaseSize() {
  //   if (_fontSize < 25.0) {
  //     _fontSize++;
  //     textStorage.write('fontSize', _fontSize);
  //   }
  // }

  // void decreaseSize() {
  //   if (_fontSize > 16.0) {
  //     _fontSize--;
  //     textStorage.write('fontSize', _fontSize);
  //   }
  // }

  @override
  void dispose() {
    _pageController.dispose();

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
          ScaffoldMessenger.of(context).hideCurrentMaterialBanner();

          return true;
        },
        child: Scaffold(
          backgroundColor: bgColor,
          bottomSheet: AudioPlayerBottomSheet(
            fontSize: _fontSize,
            arabicFontSize: _arabicFontSize,
            audioPlayer: _audioPlayer,
            chapter: widget.chapter!,
            texts: widget.texts!,
            currentIndex: currentIndex,
            positioneDataStream: positioneDataStream,
            onArabicFontSizeChanged: onArabicFontSizeChanged,
            onFontSizeChanged: onFontSizeChanged,
          ),
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                _audioPlayer.stop();

                Navigator.pop(context);
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
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
              onTap: (index) {
                _pageController.jumpToPage(index);
              },
              controller: _tabController,
              isScrollable: true,
              tabs: List<Widget>.generate(
                widget.texts!.length,
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
              Expanded(
                child: PageView.builder(
                  onPageChanged: (index) {
                    setState(() {
                      goToTab(index);
                      _pageController.jumpToPage(index);
                    });
                  },
                  controller: _pageController,
                  itemCount: widget.texts!.length,
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: mainScreenGradient,
                      child: Builder(builder: (context) {
                        return AllTextsContent(
                          text: widget.texts![index].text!,
                          arabic: widget.texts![index].arabic!,
                          translation: widget.texts![index].translation!,
                          fontSize: _fontSize,
                          arabicFontSize: _arabicFontSize,
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
