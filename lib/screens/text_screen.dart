import 'dart:ui';

import 'package:animate_icons/animate_icons.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:avrod/colors/colors.dart';
import 'package:avrod/colors/gradient_class.dart';
import 'package:avrod/controllers/audio_controller.dart';
import 'package:avrod/data/book_map.dart';
import 'package:avrod/style/my_text_style.dart';
import 'package:clay_containers/constants.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:clipboard/clipboard.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);

  bool isPlaying = false;

  void stopPlaying() async {
    if (isPlaying) {
      var reslult = await audioPlayer.stop();
      if (reslult == 1) {
        setState(() {
          isPlaying = false;
        });
      }
    }
  }

  void seekAudio(Duration durationToSeek) {
    audioPlayer.seek(durationToSeek);
  }

  void pauseSound() async {
    if (isPlaying) {
      var result = await audioPlayer.pause();

      if (result == 1) {
        setState(() {
          isPlaying = false;
        });
      }
    }
  }

  Duration duration = const Duration();
  Duration position = const Duration();
  void playSound(String url) async {
    // ignore: unrelated_type_equality_checks
    if (!isPlaying) {
      var result = await audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          isPlaying = true;
        });
      }
    }
    audioPlayer.onDurationChanged.listen((event) {
      setState(() {
        duration = event;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((event) {
      setState(() {
        position = event;
      });
    });
  }

  double _fontSize = 14.sp;

  AnimateIconController _copyController = AnimateIconController();
  final AnimateIconController _buttonController = AnimateIconController();

  @override
  void dispose() {
    audioPlayer.dispose();
    audioPlayer.onAudioPositionChanged;
    audioPlayer.onDurationChanged;
    _buttonController;
    super.dispose();
  }

  @override
  void initState() {
    audioPlayer = AudioPlayer();

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
                      fontSize: 14,
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
                    "Перевод:",
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
                        fontSize: 14,
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
    print(text.id);
    print(index);
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
          bottomSheet: ClayContainer(
            spread: 0.0,
            curveType: CurveType.none,
            height: 7.4.h,
            depth: 10,
            color: const Color.fromARGB(23, 151, 79, 8),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AnimateIcons(
                      startIcon: Icons.play_circle,
                      endIcon: Icons.pause,
                      controller: _buttonController,
                      size: 40.0,
                      onStartIconPress: () {
                        playSound(widget.texts![currentIndex].url!);
                        print(widget.texts.toString());

                        return true;
                      },
                      onEndIconPress: () {
                        pauseSound();
                        return true;
                      },
                      duration: const Duration(milliseconds: 250),
                      startIconColor: Colors.white,
                      endIconColor: Colors.white,
                      clockwise: false,
                    ),
                    // IconButton(
                    //     onPressed: () {},
                    //     icon: const Icon(
                    //       Icons.stop,
                    //       size: 40,
                    //       color: Colors.white,
                    //     )),
                    Expanded(
                      child: Row(
                        children: [
                          Slider(
                              onChangeEnd: ((value) {
                                seekAudio(Duration(seconds: value.toInt()));
                              }),
                              activeColor: Colors.white,
                              inactiveColor: Colors.grey[800],
                              min: 0.0,
                              max: duration.inSeconds.toDouble(),
                              value: position.inSeconds.toDouble(),
                              onChanged: (double newPosition) {
                                setState(() {
                                  newPosition = position.inSeconds.toDouble();
                                  newPosition = duration.inSeconds.toDouble();
                                });
                              }),
                          Expanded(
                              child: Text(
                            position.toString().split('.').first,
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white),
                          )),
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
                                '*${widget.chapter?.name}*\n${widget.texts![0].text!}\n☘️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️☘️\n${widget.texts![0].arabic!}\n${widget.texts![0].translation!}\n☘️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️☘️\nСкачать приложкние *Azkar* в Playsore\n👇👇👇👇\nhttps://play.google.com/store/apps/details?id=com.darulasar.Azkar');

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
                                  '*${widget.chapter?.name}*\n${widget.texts![0].text!}\n☘️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️☘️\n${widget.texts![0].arabic!}\n${widget.texts![0].translation!}\n☘️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️☘️\nСкачать приложкние *Azkar* в Playsore\n👇👇👇👇\nhttps://play.google.com/store/apps/details?id=com.darulasar.Azkar');
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
                stopPlaying();
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
                '${widget.chapter?.name}',
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
