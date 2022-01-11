import 'package:animate_icons/animate_icons.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:avrod/colors/gradient_class.dart';
import 'package:avrod/data/book_map.dart';
import 'package:avrod/models/scrolling_text.dart';
import 'package:avrod/style/my_text_style.dart';
import 'package:clipboard/clipboard.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

class TextScreen extends StatefulWidget {
  final List<Texts>? texts;
  final Chapter? chapter;

  const TextScreen({
    Key? key,
    this.texts,
    this.chapter,
  }) : super(key: key);

  @override
  _TextScreenState createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  String currentAuthor = "";
  List audioList = [
    {
      "title": "Адабы поломников",
      "author": "Абу Яхя Крымский",
      "url":
          "https://download.media.islamway.net/lessons/scho1260/347_7esnnelmoslem_By_Doors/003.mp3"
    },
    {
      "title": "Условия (Шуруты)",
      "author": "Абу Яхя Крымский",
      "url":
          "https://musicd.mycdn.me/v0/stream?id=v0_10008505054_1_1&cid=v0_10008505054_1_1&fid=123080783368689&uid=c49ec470578a028868ba4819017ceb54&sid=7af2c90c5c4a87407975ef695cb202c082cf8c06078ac42088e908b9bdbbc1be9380b54c783fed0a87843915ffd8052706297edfa80cb7faa69a06288205792d&ts=1641818542301&md5=6f06b1f49ce0c7a598ee5601f8d93663&client=flash&clientHash=2801504605161501202402402163021024024023248961768454075163915210360138012024024033201222232"
    },
    {
      "title": "Условия (Шуруты)",
      "author": "Абу Яхя Крымский",
      "url":
          "https://soundcloud.com/user-416734396-544407763/01-4?in=user-416734396-544407763/sets/khadzh-i-umra-abu-yakhya-krymskiy"
    }
  ];
  // Audioplayer
  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  bool isPlaying = false;

  void playSound(String url) async {
    // ignore: unrelated_type_equality_checks
    if (isPlaying) {
      var result = await audioPlayer.pause();

      if (result == 1) {
        setState(() {
          isPlaying = false;
        });
      }
    } else if (!isPlaying) {
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
  IconData btnIcon = Icons.play_arrow;

  AnimateIconController _controller = AnimateIconController();
  AnimateIconController _buttonController = AnimateIconController();
  Duration duration = const Duration();
  Duration position = const Duration();
  double sliderPosition = 0.0;

  @override
  void dispose() {
    _controller = AnimateIconController();
    _buttonController = AnimateIconController();
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  void initState() {
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.only(left: 5, right: 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                  color: Colors.cyan.shade300,
                  offset: const Offset(2.0, 2.0),
                  blurRadius: 3.0,
                  spreadRadius: 1.0),
              const BoxShadow(
                  color: Colors.black26,
                  offset: Offset(4.0, 4.0),
                  blurRadius: 2.0,
                  spreadRadius: 1.0),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimateIcons(
                startIcon: Icons.play_circle,
                endIcon: Icons.pause,
                controller: _buttonController,
                size: 40.0,
                onStartIconPress: () {
                  playSound(url);

                  return true;
                },
                onEndIconPress: () {
                  playSound(url);
                  return true;
                },
                duration: const Duration(milliseconds: 250),
                startIconColor: Colors.white,
                endIconColor: Colors.white,
                clockwise: false,
              ),
              Slider.adaptive(
                  activeColor: Colors.white,
                  inactiveColor: Colors.blueGrey,
                  min: 0.0,
                  max: duration.inSeconds.toDouble(),
                  value: position.inSeconds.toDouble(),
                  onChanged: (double newPosition) {
                    setState(() {});
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
                          '*${widget.chapter?.name}*\n$text\n$arabic\n$translation\n☘️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️☘️\nОтправлено по средством приложения *Azkar*\n👇👇👇👇\nhttps://play.google.com/store/apps/details?id=com.darulasar.avrod');

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
                            '*${widget.chapter?.name}*\n$text\n$arabic\n$translation\nБо воситаи барномаи *Avrod* ирсол шуд.\n👇👇👇👇\nhttps://play.google.com/store/apps/details?id=com.darulasar.avrod');
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
        const SizedBox(
          height: 10.0,
        ),
        Slider(
          activeColor: Colors.white,
          inactiveColor: Colors.blueGrey,
          value: _fontSize,
          onChanged: (double newSize) {
            setState(() {
              _fontSize = newSize;
            });
          },
          min: 16.sp,
          max: 30.sp,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Произношение:",
            textAlign: TextAlign.start,
            style: expandableTextStyle,
          ),
        ),
        Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                SelectableText(
                  text,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: _fontSize,
                    color: Colors.white,
                  ),
                ),
              ],
            )),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
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
                  header: Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      "Арабский:",
                      textAlign: TextAlign.start,
                      style: expandableTextStyle,
                    ),
                  ),
                  collapsed: SelectableText(
                    arabic,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.amiri(
                      textBaseline: TextBaseline.ideographic,
                      wordSpacing: 0.5,
                      color: Colors.white,
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
                      color: Colors.white,
                      fontSize: _fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
            padding: const EdgeInsets.all(8),
            child: Center(
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
                    color: Colors.white,
                  ),
                ),
                expanded: SelectableText(
                  translation,
                  maxLines: 1,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: _fontSize,
                    color: Colors.white,
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Widget buildBook(
    Texts text,
  ) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        SizedBox(
          height: 2.h,
        ),
        _contenAllTexts(text.text!, text.arabic!, text.translation!, text.url!),
      ],
    );
  }

  final GlobalKey _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.texts!.length,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios),
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
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: favoriteGradient,
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            isScrollable: true,
            tabs: widget.texts!.map((Texts e) => Tab(text: e.id)).toList(),
          ),
        ),
        body: TabBarView(
          children: widget.texts!
              .map(
                (e) => Container(
                  decoration: favoriteGradient,
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

  // _updateProgress() {
  //   const oneSec = Duration(seconds: 1);
  //   Timer.periodic(oneSec, (Timer t) {
  //     setState(() {
  //       _progressLoading = 0.20;
  //       if (_progressLoading!.toStringAsFixed(1) == '1.00') {
  //         _loading = false;
  //         t.cancel();
  //         _progressLoading = 0.0;
  //         return;
  //       }
  //     });
  //   });
  // }
}
