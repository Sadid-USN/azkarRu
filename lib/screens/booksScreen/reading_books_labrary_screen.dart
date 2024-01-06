import 'package:animate_icons/animate_icons.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:avrod/controllers/library_controller.dart';
import 'package:avrod/widgets/audio_palayer_bottom_sheet.dart';
import 'package:avrod/widgets/popup_menu_btutton.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:avrod/colors/colors.dart';
import 'package:avrod/generated/locale_keys.g.dart';
import 'package:avrod/models/lib_book_model.dart';
import 'package:avrod/screens/text_screen.dart';

const String appLink =
    "https://play.google.com/store/apps/details?id=com.darulasar.Azkar";

class BookReading extends StatefulWidget {
  final LibBookModel book;
  final int index;
  const BookReading({
    Key? key,
    // this.source,
    required this.book,
    required this.index,
  }) : super(
          key: key,
        );

  @override
  State<BookReading> createState() => _BookReadingState();
}

class _BookReadingState extends State<BookReading> {
  bool isOntap = false;
  // late int initialPage;
  ScrollController scrollController = ScrollController();
  AnimateIconController animateIconController = AnimateIconController();
  @override
  void initState() {
    final controller = Provider.of<LibraryController>(context, listen: false);
    controller.book = widget.book;

    int initialPage = controller.currentPage = widget.index;

    controller.pageController = PageController(initialPage: initialPage);

    controller.playAudio();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryController>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              value.audioPlayer.stop();
              Navigator.of(context).pop();
            },
          ),
          title: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(
              widget.book.title ?? "_",
              style: TextStyle(color: Colors.grey.shade800, fontSize: 16.0),
            ),
          ),
          centerTitle: true,
          elevation: 0.5,
          backgroundColor: const Color.fromARGB(255, 245, 221, 192),
          automaticallyImplyLeading: false,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
        ),
        backgroundColor: bgColor,
        extendBodyBehindAppBar: true,
        body: PageView.builder(
          controller: value.pageController,
          onPageChanged: (index) {
            value.currentPage = index;
            value.onPageChanged(index);
            value.audioPlayer.stop();
          },
          itemCount: widget.book.chapters!.length,
          itemBuilder: (context, index) {
            return WillPopScope(
              onWillPop: () async {
                value.audioPlayer.stop();
                return true;
              },
              child: SafeArea(
                child: SingleChildScrollView(
                  child: BookContent(
                    positioneDataStream: value.positioneDataStream,
                    audioPlayer: value.audioPlayer,
                    onShareTap: () {
                      final text = widget.book.chapters![index].text;
                      final title = widget.book.title;
                      final sentByAzkar = LocaleKeys.sentByAzkarApp.tr();
                      Share.share(
                          "$title\n$text\n$sentByAzkar\n👇👇👇\n$appLink");
                    },
                    max: widget.book.chapters!.length.toDouble() - 1,
                    image: widget.book.image ?? "_",
                    scrollController: scrollController,
                    page: value.currentPage + 1,
                    chapters: widget.book.chapters![index],
                    onNextPagePressed: value.onNextPagePressed,
                    onPreviousPagePressed: value.previousPagePressed,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class BookContent extends StatelessWidget {
  final void Function()? onPreviousPagePressed;
  final void Function()? onNextPagePressed;
  final void Function()? onShareTap;
  final ScrollController scrollController;
  final AudioPlayer audioPlayer;
  final Stream<PositioneData> positioneDataStream;

  final int? page;
  final double max;
  final LibChapters chapters;
  final String image;
  const BookContent({
    Key? key,
    this.onPreviousPagePressed,
    this.onNextPagePressed,
    this.onShareTap,
    required this.scrollController,
    required this.audioPlayer,
    required this.positioneDataStream,
    this.page,
    required this.max,
    required this.chapters,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String sourceText =
        chapters.sources!.map((source) => source.source).join('\n');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                "icons/pattern.png",
                height: 60,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MarkdownBody(
              selectable: true,
              data: chapters.subtitle ?? "_",
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 18.0),
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            MarkdownBody(
              selectable: true,
              data: chapters.text ?? "_",
              styleSheet: MarkdownStyleSheet(
                p: GoogleFonts.ptSerif(
                    height: 1.6,
                    letterSpacing: 0.7,
                    color: Colors.blueGrey[900],
                    fontWeight: FontWeight.w400,
                    fontSize: 16),
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            SelectableText(
              sourceText,
              textAlign: TextAlign.start,
              style: TextStyle(
                letterSpacing: 1.0,
                color: Colors.blueGrey[900],
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Center(
              child: Image.asset(
                "icons/pattern.png",
                height: 70,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Center(
                  child: Text(
                page.toString(),
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )),
            ),
            const SizedBox(
              height: 20,
            ),
            _ReadingAudioPlayer(
              positioneDataStream: positioneDataStream,
              audioPlayer: audioPlayer,
              onShareTap: onShareTap,
              max: max,
              scrollController: scrollController,
              page: page!,
              chapters: chapters,
              onNextPagePressed: onNextPagePressed,
              onPreviousPagePressed: onPreviousPagePressed,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReadingAudioPlayer extends StatelessWidget {
  final void Function()? onPreviousPagePressed;
  final void Function()? onNextPagePressed;
  final void Function()? onShareTap;
  final ScrollController scrollController;
  final AudioPlayer audioPlayer;
  final Stream<PositioneData> positioneDataStream;
  final int page;
  final double max;
  final LibChapters chapters;

  const _ReadingAudioPlayer({
    required this.onPreviousPagePressed,
    required this.onNextPagePressed,
    required this.onShareTap,
    required this.scrollController,
    required this.audioPlayer,
    required this.positioneDataStream,
    required this.page,
    required this.max,
    required this.chapters,
  });

  @override
  Widget build(BuildContext context) {
    return chapters.isAudioUrl!
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                // margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    StreamBuilder<PlayerState>(
                      stream: audioPlayer.playerStateStream,
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
                            onPressed: audioPlayer.stop,
                          );
                        } else if (playing != true || completed) {
                          return IconButton(
                            color: Colors.blueGrey,
                            disabledColor: Colors.grey,
                            icon: const Icon(Icons.play_circle_outline),
                            iconSize: 50,
                            onPressed: audioPlayer.play,
                          );
                        } else {
                          return IconButton(
                            color: Colors.blueGrey,
                            disabledColor: Colors.grey,
                            icon: const Icon(Icons.pause_circle_outline),
                            iconSize: 50,
                            onPressed: audioPlayer.pause,
                          );
                        }
                      },
                    ),
                    StreamBuilder<PositioneData>(
                      stream: positioneDataStream,
                      builder: (context, snapshot) {
                        final positionData = snapshot.data;

                        return SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          child: ProgressBar(
                            barHeight: 4,
                            baseBarColor: Colors.grey.shade400,
                            bufferedBarColor: Colors.white,
                            progressBarColor: Colors.blueGrey,
                            thumbColor: Colors.green.shade800,
                            thumbRadius: 6,
                            timeLabelTextStyle: const TextStyle(
                              height: 1.2,
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            progress: positionData?.positione ?? Duration.zero,
                            buffered:
                                positionData?.bufferedPosition ?? Duration.zero,
                            total: positionData?.duration ?? Duration.zero,
                            onSeek: audioPlayer.seek,
                          ),
                        );
                      },
                    ),
                    StreamBuilder<double>(
                      stream: audioPlayer.speedStream,
                      builder: (context, snapshot) => PopupMenuButtonWidget(
                        speedStream: audioPlayer.speedStream,
                        onSpeedSelected: (double newValue) {
                          audioPlayer.setSpeed(newValue);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: onPreviousPagePressed,
                      style: ElevatedButton.styleFrom(
                        elevation: 1,
                        backgroundColor: Colors.blueGrey.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Icon(
                        Icons.skip_previous_sharp,
                      ),
                    ),
                    GestureDetector(
                      onTap: onShareTap,
                      child: Image.asset(
                        "icons/shared.png",
                        height: 30,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onNextPagePressed,
                      style: ElevatedButton.styleFrom(
                        elevation: 1,
                        backgroundColor: Colors.blueGrey.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Icon(
                        Icons.skip_next,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : const SizedBox();
    // : Column(
    //     mainAxisSize: MainAxisSize.min,
    //     children: [
    //       Padding(
    //         padding: const EdgeInsets.only(
    //             bottom: 10, right: 20, left: 20, top: 20),
    //         child: AnimatedTextKit(
    //           totalRepeatCount: 1,
    //           repeatForever: false,
    //           pause: const Duration(seconds: 2),
    //           animatedTexts: [
    //             TypewriterAnimatedText(
    //               LocaleKeys.audioIsPending.tr(),
    //               textAlign: TextAlign.center,
    //               textStyle: TextStyle(
    //                   fontSize: 16.0,
    //                   fontWeight: FontWeight.bold,
    //                   color: Colors.blueGrey.shade600),
    //               speed: const Duration(milliseconds: 50),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   );
  }
}

// class ReadingBooksOnline extends StatefulWidget {
//   final File? file;

//   const ReadingBooksOnline({
//     Key? key,
//     this.file,
//   }) : super(key: key);

//   @override
//   State<ReadingBooksOnline> createState() => _ReadingBooksOnlineState();
// }

// class _ReadingBooksOnlineState extends State<ReadingBooksOnline> {
//   @override
//   Widget build(BuildContext context) {
//     final name = basename(widget.file!.path);
//     return Scaffold(
      
//       appBar: AppBar(title:  Text(name),),
//       body: PDFView(
//         filePath: widget.file!.path ,
        
//       ),
//     );
//   }
// }
