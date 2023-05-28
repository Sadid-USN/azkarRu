import 'dart:ui';

import 'package:animate_icons/animate_icons.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'package:avrod/colors/colors.dart';
import 'package:avrod/colors/gradient_class.dart';
import 'package:avrod/controllers/audio_controller.dart';
import 'package:avrod/data/book_map.dart';
import 'package:avrod/generated/locale_keys.g.dart';
import 'package:avrod/style/my_text_style.dart';
import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

class TextScreen extends StatefulWidget {
  final List<Texts>? texts;
  final Chapters? chapter;
  final int? index;

  const TextScreen({Key? key, this.texts, this.chapter, this.index})
      : super(key: key);

  @override
  _TextScreenState createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  int currentIndex = 0;
  late final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;

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
void playAudio(String url) {
  _audioPlayer.setAudioSource(
    AudioSource.uri(
      Uri.parse(url),
      tag: MediaItem(
        id: widget.texts![currentIndex].id.toString(),
        album: widget.chapter!.name,
        title:  widget.chapter!.name!,
        artUri: Uri.parse(widget.chapter!.listimage!),
      ),
    ),
  );
  _audioPlayer.play();
}

  void pauseAudio() {
    if (isPlaying) {
      setState(() {
        _audioPlayer.pause();
        isPlaying = false;
      });
    }
  }

  double _fontSize = 14.sp;

  AnimateIconController _copyController = AnimateIconController();
  final AnimateIconController _buttonController = AnimateIconController();

  @override
  void dispose() {
    _audioPlayer.dispose();
    _buttonController;
    super.dispose();
  }

  @override
  void initState() {
    _audioPlayer;
    _copyController = AnimateIconController();

    super.initState();
  }

  Widget _contenAllTexts(
    String text,
    String arabic,
    String translation,
    String url,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          child: Slider(
            activeColor: Colors.white,
            inactiveColor: Colors.grey[800],
            value: _fontSize,
            onChanged: (double newSize) {
              setState(() {
                _fontSize = newSize;
              });
            },
            max: 25.sp,
            min: 14.sp,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              ExpandablePanel(
                header: Text(
                  "",
                  textAlign: TextAlign.start,
                  style: expandableTextStyle,
                ),
                collapsed: SelectableText(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: _fontSize,
                    color: textColor,
                  ),
                ),
                expanded: SelectableText(
                  text,
                  maxLines: 1,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: _fontSize,
                      color: textColor,
                      overflow: TextOverflow.fade),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromARGB(44, 95, 191, 68),
                            offset: Offset(0.0, 2.0),
                            blurRadius: 6.0)
                      ],
                      // gradient: LinearGradient(
                      //     colors: [
                      //       Color.fromARGB(255, 240, 163, 163),
                      //       Color.fromARGB(97, 43, 165, 217)
                      //     ],
                      //     begin: Alignment.centerLeft,
                      //     end: Alignment.centerRight),
                    ),
                    padding: const EdgeInsets.all(40),
                    child: ExpandablePanel(
                      header: const Text(''),
                      collapsed: SelectableText(
                        arabic,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.amiri(
                          textBaseline: TextBaseline.ideographic,
                          wordSpacing: 0.5,
                          color: textColor,
                          fontSize: _fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      expanded: SelectableText(
                        arabic,
                        maxLines: 1,
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.amaticSc(
                          textBaseline: TextBaseline.ideographic,
                          wordSpacing: 0.5,
                          color: textColor,
                          fontSize: _fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Center(
                child: ExpandablePanel(
                  header: Text(
                    LocaleKeys.translation.tr(),
                    textAlign: TextAlign.start,
                    style: expandableTextStyle,
                  ),
                  collapsed: SelectableText(
                    translation,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: _fontSize,
                      color: textColor,
                    ),
                  ),
                  expanded: SelectableText(
                    translation,
                    maxLines: 1,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: _fontSize,
                        color: textColor),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 80,
        )
      ],
    );
  }

  Widget buildBook(
    Texts text,
    int index,
  ) {
    currentIndex = index;
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        _contenAllTexts(text.text!, text.arabic!, text.translation!, text.url!),
      ],
    );
  }

  final GlobalKey _key = GlobalKey();
  @override
  Widget build(
    BuildContext context,
  ) {
    return DefaultTabController(
      length: widget.texts!.length,
      child: ChangeNotifierProvider(
        create: (context) => AudioController(),
        child: Scaffold(
          bottomSheet: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            height: 8.4.h,
            color: const Color.fromARGB(255, 55, 100, 4),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimateIcons(
                      startIcon: Icons.play_circle,
                      endIcon: Icons.pause,
                      controller: _buttonController,
                      size: 40.0,
                      onStartIconPress: () {
                        playAudio(widget.texts![currentIndex].url!);

                        return true;
                      },
                      onEndIconPress: () {
                        pauseAudio();

                        return true;
                      },
                      duration: const Duration(milliseconds: 250),
                      startIconColor: Colors.white,
                      endIconColor: Colors.white,
                      clockwise: false,
                    ),
                    
                  
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          StreamBuilder<PositioneData>(
                              stream: positioneDataStream,
                              builder: (context, snapshot) {
                                final positionData = snapshot.data;

                                return SizedBox(
                                  width: 180,
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
                                    progress: positionData?.positione ??
                                        Duration.zero,
                                    buffered: positionData?.bufferedPosition ??
                                        Duration.zero,
                                    total:
                                        positionData?.duration ?? Duration.zero,
                                    onSeek: _audioPlayer.seek,
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AnimateIcons(
                          startIcon: Icons.copy,
                          endIcon: Icons.check_circle_outline,
                          controller: _copyController,
                          size: 33.0,
                          onStartIconPress: () {
                            FlutterClipboard.copy(
                                '*${widget.chapter?.name}*\n${widget.texts![currentIndex].text!}\n☘️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️☘️\n${widget.texts![currentIndex].arabic!}\n${widget.texts![currentIndex].translation!}\n☘️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️☘️\nСкачать приложкние *Azkar* в Playsore\n👇👇👇👇\nhttps://play.google.com/store/apps/details?id=com.darulasar.Azkar');

                            return true;
                          },
                          onEndIconPress: () {
                            return false;
                          },
                          duration: const Duration(milliseconds: 250),
                          startIconColor: Colors.white,
                          endIconColor: Colors.white,
                          clockwise: false,
                        ),
                        IconButton(
                            onPressed: () {
                              Share.share(
                                  '*${widget.chapter?.name}*\n${widget.texts![currentIndex].text!}\n☘️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️☘️\n${widget.texts![currentIndex].arabic!}\n${widget.texts![currentIndex].translation!}\n☘️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️☘️\nСкачать приложкние *Azkar* в Playsore\n👇👇👇👇\nhttps://play.google.com/store/apps/details?id=com.darulasar.Azkar');
                            },
                            icon: const Icon(Icons.share,
                                size: 33.0, color: Colors.white)),
                        const SizedBox(
                          width: 5,
                        )
                      ],
                    )
                  ],
                ),
            
            
              ],
            ),
          ),
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
                _audioPlayer.stop();
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
              decoration: mainScreenGradient,
            ),
            bottom: TabBar(
              labelColor: titleAbbBar,
              indicatorColor: titleAbbBar,
              isScrollable: true,
              tabs: widget.texts!.map((Texts e) => Tab(text: e.id)).toList(),
            ),
          ),
          body: TabBarView(
            children: widget.texts!
                .map(
                  (e) => Container(
                    decoration: mainScreenGradient,
                    child: Builder(builder: (context) {
                      return buildBook(e, widget.texts!.indexOf(e));
                    }),
                  ),
                )
                .toList(),
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
