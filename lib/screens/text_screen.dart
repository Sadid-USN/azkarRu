import 'dart:ui';

import 'package:animate_icons/animate_icons.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';

import 'package:avrod/colors/colors.dart';
import 'package:avrod/colors/gradient_class.dart';
import 'package:avrod/controllers/audio_controller.dart';
import 'package:avrod/data/book_map.dart';
import 'package:avrod/generated/locale_keys.g.dart';
import 'package:avrod/style/my_text_style.dart';
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

class _TextScreenState extends State<TextScreen>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  late final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: widget.texts!.length, vsync: this);
    // _tabController.addListener(() { 
    //   if(_tabController.indexIsChanging){
    //     playAudioForTab(_tabController.index);
    //   }
    // });
    playAudio(); // Play audio for the initial tab
  }

  void playAudioForTab(int index) {
    if (currentIndex != index) {
      currentIndex = index;
      _audioPlayer.pause(); // Pause the audio when switching tabs
      playAudio();
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
      Uri.parse(widget.texts![currentIndex].url ??
          ""),
      tag: MediaItem(
        id: widget.texts![currentIndex].id.toString(),
        album: widget.chapter!.name,
        title: widget.chapter!.name!,
        artUri: Uri.parse(widget.chapter!.listimage!),
      ),
    );

    _audioPlayer.setAudioSource(audioSource);
    _audioPlayer.playerStateStream.listen((playerState) {
      _onPlayerCompletion(playerState);
    });
  }

  double _fontSize = 14.sp;

  final AnimateIconController _copyController = AnimateIconController();
  final AnimateIconController _buttonController = AnimateIconController();

  @override
  void dispose() {
    _audioPlayer.dispose();
   _tabController.dispose();
    super.dispose();
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
          height: 120,
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
                            '*${widget.chapter?.name}*\n${widget.texts![currentIndex].text!}\n☘️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️☘️\n${widget.texts![currentIndex].arabic!}\n${widget.texts![currentIndex].translation!}\n☘️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️☘️\nСкачать приложкние *Azkar* в Playsore\n👇👇👇👇\nhttps://play.google.com/store/apps/details?id=com.darulasar.Azkar');
                      },
                      icon: const Icon(Icons.share,
                          size: 30.0, color: Colors.white),
                    ),
                    IconButton(
                      onPressed: () {
                        goToPreviousTab();
                      
                      },
                      icon: const Icon(
                        Icons.skip_previous,
                        color: Colors.white,
                      ),
                    ),
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
                            iconSize: 35,
                            onPressed: _audioPlayer.stop,
                          );
                        } else if (playing != true || completed) {
                          return IconButton(
                            color: Colors.white,
                            disabledColor: Colors.grey,
                            icon: const Icon(Icons.play_circle_outline),
                            iconSize: 35,
                            onPressed: _audioPlayer.play,
                          );
                        } else {
                          return IconButton(
                            color: Colors.white,
                            disabledColor: Colors.grey,
                            icon: const Icon(Icons.pause_circle_outline),
                            iconSize: 35,
                            onPressed: _audioPlayer.pause,
                          );
                        }
                      },
                    ),
                    IconButton(
                      onPressed: () {
                         goToNextTab();
                      },
                      icon: const Icon(
                        Icons.skip_next,
                        color: Colors.white,
                      ),
                    ),
                    StreamBuilder<double>(
                      stream: _audioPlayer.speedStream,
                      builder: (context, snapshot) => PopupMenuButtonWidget(
                        speedStream: _audioPlayer.speedStream,
                        onSpeedSelected: (double newValue) {
                          _audioPlayer.setSpeed(newValue);
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

                // AnimateIcons(
                //   startIcon: Icons.copy,
                //   endIcon: Icons.check_circle_outline,
                //   controller: _copyController,
                //   size: 33.0,
                //   onStartIconPress: () {
                //     FlutterClipboard.copy(
                //         '*${widget.chapter?.name}*\n${widget.texts![currentIndex].text!}\n☘️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️☘️\n${widget.texts![currentIndex].arabic!}\n${widget.texts![currentIndex].translation!}\n☘️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️☘️\nСкачать приложкние *Azkar* в Playsore\n👇👇👇👇\nhttps://play.google.com/store/apps/details?id=com.darulasar.Azkar');

                //     return true;
                //   },
                //   onEndIconPress: () {
                //     return true;
                //   },
                //   duration: const Duration(milliseconds: 250),
                //   startIconColor: Colors.white,
                //   endIconColor: Colors.white,
                //   clockwise: false,
                // ),

                // AnimateIcons(
                //   startIcon: Icons.play_circle,
                //   endIcon: Icons.pause,
                //   controller: _buttonController,
                //   size: 40.0,
                //   onStartIconPress: () {
                //     playAudio();

                //     return true;
                //   },
                //   onEndIconPress: () {
                //     _audioPlayer.stop();

                //     return true;
                //   },
                //   duration: const Duration(milliseconds: 250),
                //   startIconColor: Colors.white,
                //   endIconColor: Colors.white,
                //   clockwise: false,
                // ),
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
              
              controller: _tabController,
              onTap: playAudioForTab,
              labelColor: titleAbbBar,
              indicatorColor: titleAbbBar,
              isScrollable: true,
              tabs: widget.texts!.map((Texts e) => Tab(text: e.id)).toList(),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
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
          const PopupMenuItem<double>(
            value: 1.25,
            child: Text("1.25x",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          const PopupMenuItem<double>(
            value: 1.5,
            child: Text("1.5x",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          const PopupMenuItem<double>(
            value: 1.75,
            child: Text("1.75x",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          const PopupMenuItem<double>(
            value: 2.0,
            child: Text("2.0x",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
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

// class AudioSpeedSliderDialog extends StatefulWidget {
//   final double min;
//   final double max;
//   final double value;
//   final ValueChanged<double> onChanged;

//   const AudioSpeedSliderDialog({
//     Key? key,
//     required this.min,
//     required this.max,
//     required this.value,
//     required this.onChanged,
//   }) : super(key: key);

//   @override
//   _AudioSpeedSliderDialogState createState() => _AudioSpeedSliderDialogState();
// }

// class _AudioSpeedSliderDialogState extends State<AudioSpeedSliderDialog> {
//   late double _currentValue;

//   @override
//   void initState() {
//     super.initState();
//     _currentValue = widget.value;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Center(
//         child: Text(
//           "${_currentValue.toStringAsFixed(1)}x",
//           style:
//               const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//         ),
//       ),
//       // alignment: Alignment.,
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               IconButton(
//                 icon: const Icon(Icons.remove),
//                 onPressed: () {
//                   // setState(() {
//                   //   _currentValue -= 0.1;
//                   //   _currentValue = _currentValue.clamp(widget.min, widget.max);
//                   // });
//                 },
//               ),
//               Slider(
//                 activeColor: audioPlayerColor,
//                 value: _currentValue,
//                 min: widget.min,
//                 max: widget.max,
//                 divisions: 10,
//                 onChanged: (value) {
//                   setState(() {
//                     _currentValue = value;
//                   });
//                 },
//                 onChangeEnd: (value) {
//                   widget.onChanged(_currentValue);
//                 },
//               ),
//               IconButton(
//                 icon: const Icon(Icons.add),
//                 onPressed: () {
//                   // setState(() {
//                   //   _currentValue += 0.1;
//                   //   _currentValue = _currentValue.clamp(widget.min, widget.max);
//                   // });
//                 },
//               ),
//             ],
//           ),
//         ],
//       ),
//       // actions: [
//       //   ElevatedButton(
//       //     style: ElevatedButton.styleFrom(
//       //       backgroundColor:
//       //           audioPlayerColor, // Replace Colors.blue with the desired background color
//       //     ),
//       //     onPressed: () => Navigator.pop(context),
//       //     child: const Text("Илғо"),
//       //   ),
//       //   ElevatedButton(
//       //     style: ElevatedButton.styleFrom(
//       //       backgroundColor:
//       //           audioPlayerColor, // Replace Colors.blue with the desired background color
//       //     ),
//       //     onPressed: () {
//       //       widget.onChanged(_currentValue);
//       //       Navigator.pop(context);
//       //     },
//       //     child: const Text("Ok"),
//       //   ),
//       // ],
//     );
//   }
// }
