import 'package:animate_icons/animate_icons.dart';
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
  double _fontSize = 18.sp;

  String? creepingLine;

  int? index;

  AnimateIconController _controller = AnimateIconController();

  // @override
  // void dispose() {
  //   _controller = AnimateIconController();
  //   super.dispose();
  // }

  @override
  void initState() {
    _controller = AnimateIconController();

    super.initState();
  }

  Widget _contenAllTexts(
    String text,
    String arabic,
    String translation,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                    '*${widget.chapter?.name}*\n$text\n$arabic\n$translation\n☘️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️☘️\nБо воситаи барномаи *Avrod* насх шуд\n👇👇👇👇\nhttps://play.google.com/store/apps/details?id=com.darulasar.avrod');

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
                icon: const Icon(Icons.share, size: 33.0, color: Colors.white)),
            Slider(
              activeColor: Colors.white,
              inactiveColor: Colors.blueGrey,
              value: _fontSize,
              onChanged: (double newSize) {
                setState(() {
                  _fontSize = newSize;
                });
              },
              min: 18.sp,
              max: 50,
            )
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          child: ExpandablePanel(
            header: Text(
              "Произношение:",
              textAlign: TextAlign.start,
              style: expandableTextStyle,
            ),
            collapsed: SelectableText(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: _fontSize,
                color: Colors.white,
              ),
            ),
            expanded: SelectableText(
              text,
              maxLines: 1,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: _fontSize,
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis),
            ),
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
        _contenAllTexts(text.text!, text.arabic!, text.translation!),
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
