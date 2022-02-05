import 'package:animate_icons/animate_icons.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:avrod/colors/colors.dart';
import 'package:avrod/colors/gradient_class.dart';
import 'package:avrod/data/book_map.dart';
import 'package:avrod/models/scrolling_text.dart';
import 'package:avrod/style/my_text_style.dart';
import 'package:clay_containers/constants.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:clipboard/clipboard.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

class TextScreen extends StatefulWidget {
  final List<Texts>? texts;
  final Chapter? chapter;
  final int index;

  const TextScreen({Key? key, this.texts, this.chapter, required this.index})
      : super(key: key);

  @override
  _TextScreenState createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
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

  double _fontSize = 16.sp;
  String? creepingLine;

  AnimateIconController _controller = AnimateIconController();
  AnimateIconController _buttonController = AnimateIconController();

  //double sliderPosition = 0.0;

  @override
  void dispose() {
    _controller = AnimateIconController();
    _buttonController = AnimateIconController();
    audioPlayer.dispose();
    audioPlayer.onAudioPositionChanged;
    audioPlayer.onDurationChanged;

    super.dispose();
  }

  @override
  void initState() {
    audioPlayer = AudioPlayer();

    _controller = AnimateIconController();

    super.initState();
  }

  Widget _contenAllTexts(
    String text,
    String arabic,
    String translation,
    String url,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Slider(
          activeColor: Colors.white,
          inactiveColor: Colors.blueGrey,
          value: _fontSize,
          onChanged: (double newSize) {
            setState(() {
              _fontSize = newSize;
            });
          },
          max: 30.sp,
          min: 16.sp,
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
                    color: Colors.blueGrey,
                  ),
                ),
                expanded: SelectableText(
                  text,
                  maxLines: 1,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.blueGrey,
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
              Container(
                decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xffEFE2BF),
                          offset: Offset(0.0, 2.0),
                          blurRadius: 6.0)
                    ],
                    gradient: LinearGradient(
                        colors: [Colors.white24, Colors.white38],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                padding: const EdgeInsets.all(40),
                child: ExpandablePanel(
                  header: const Text(''),
                  collapsed: SelectableText(
                    arabic,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.amiri(
                      textBaseline: TextBaseline.ideographic,
                      wordSpacing: 0.5,
                      color: Colors.blueGrey,
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
                      color: Colors.blueGrey,
                      fontSize: _fontSize,
                      fontWeight: FontWeight.bold,
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
                      color: Colors.blueGrey,
                    ),
                  ),
                  expanded: SelectableText(
                    translation,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.blueGrey,
                    ),
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
  ) {
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
      child: Scaffold(
        backgroundColor: Colors.green,
        bottomSheet: ClayContainer(
          curveType: CurveType.concave,
          height: 65,
          depth: 25,
          color: const Color(0xffD6BC9B),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AnimateIcons(
                startIcon: Icons.play_circle,
                endIcon: Icons.pause,
                controller: _buttonController,
                size: 40.0,
                onStartIconPress: () {
                  playSound(widget.texts![widget.index].url!);

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
              Slider(
                  activeColor: Colors.white,
                  inactiveColor: Colors.blueGrey,
                  min: 0.0,
                  max: duration.inSeconds.toDouble(),
                  value: position.inSeconds.toDouble(),
                  onChanged: (double newPosition) {
                    setState(() {
                      newPosition = position.inSeconds.toDouble();
                      newPosition = duration.inSeconds.toDouble();
                    });
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  AnimateIcons(
                    startIcon: Icons.copy,
                    endIcon: Icons.check_circle_outline,
                    controller: _controller,
                    size: 33.0,
                    onStartIconPress: () {
                      FlutterClipboard.copy(
                          '*${widget.chapter?.name}*\n${widget.texts![widget.index].text!}\n☘️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️☘️\n${widget.texts![widget.index].arabic!}\n${widget.texts![widget.index].translation!}\n☘️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️☘️\nСкачать приложкние *Azkar* в Playsore\n👇👇👇👇\nhttps://play.google.com/store/apps/details?id=com.darulasar.Azkar');

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
                            '*${widget.chapter?.name}*\n${widget.texts![widget.index].text!}\n☘️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️☘️\n${widget.texts![widget.index].arabic!}\n${widget.texts![widget.index].translation!}\n☘️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️☘️\nСкачать приложкние *Azkar* в Playsore\n👇👇👇👇\nhttps://play.google.com/store/apps/details?id=com.darulasar.Azkar');
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
          elevation: 0.0,
          title: Column(
            children: [
              // ignore: sized_box_for_whitespace
              Container(
                key: _key,
                padding: const EdgeInsets.only(top: 5),
                height: 40.0,
                child: ScrollingText(
                  text: '${widget.chapter?.name}',
                  textStyle: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: mainScreenGradient,
          ),
          bottom: TabBar(
            labelColor: Colors.blueGrey,
            indicatorColor: Colors.blueGrey,
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
                    return buildBook(e);
                  }),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
