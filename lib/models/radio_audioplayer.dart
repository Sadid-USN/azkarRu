import 'package:animate_icons/animate_icons.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:avrod/colors/colors.dart';
import 'package:avrod/controllers/radio_conteroller.dart';
import 'package:avrod/core/addbunner_helper.dart';
import 'package:avrod/data/radio_data_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import 'package:avrod/controllers/audio_controller.dart';

class RadioAudioPlayer extends StatefulWidget {
  const RadioAudioPlayer({
    Key? key,
  }) : super(key: key);

  @override
  State<RadioAudioPlayer> createState() => _RadioAudioPlayerState();
}

class _RadioAudioPlayerState extends State<RadioAudioPlayer> {
  @override
  void initState() {
    final controller = Provider.of<RadioController>(context, listen: false);
    controller.newListInfo = listInfo;
    controller.playAudio();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final PageController pageController = PageController();
    return AnimationLimiter(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Consumer<RadioController>(
          builder: (context, audioController, child) => PageView.builder(
            controller: audioController.pageController,
            itemCount: audioController.newListInfo.length,
            onPageChanged: (index) {
              audioController.audioPlayer.stop();
              audioController.onPageChanged(index);
            },
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 400),
                columnCount: audioController.newListInfo.length,
                child: const ScaleAnimation(
                  child: AudiPlyerCard(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class AudiPlyerCard extends StatefulWidget {
  const AudiPlyerCard({
    Key? key,
  }) : super(key: key);

  @override
  State<AudiPlyerCard> createState() => _AudiPlyerCardState();
}

class _AudiPlyerCardState extends State<AudiPlyerCard> {
  late BannerAdHelper bannerAdHelper = BannerAdHelper();

  @override
  void initState() {
    super.initState();

    bannerAdHelper.initializeAdMob(
      onAdLoaded: (ad) {
        setState(() {
          bannerAdHelper.isBannerAd = true;
        });
      },
    );
  }

  @override
  void dispose() {
    bannerAdHelper.bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RadioController>(
      builder: (context, value, child) => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          bannerAdHelper.isBannerAd
              ? SizedBox(
                  height: bannerAdHelper.bannerAd.size.height.toDouble(),
                  width: bannerAdHelper.bannerAd.size.width.toDouble(),
                  child: AdWidget(ad: bannerAdHelper.bannerAd),
                )
              : const SizedBox(
                  height: 40,
                ),
          CircleAvatar(
            backgroundImage: NetworkImage(listInfo[value.currentPage].image),
            radius: 140,
          ),

          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
                color: Colors.black12, borderRadius: BorderRadius.circular(12)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: value.previousPagePressed,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(90.0),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.blueGrey,
                    size: 30,
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
                        iconSize: 60,
                        onPressed: value.audioPlayer.stop,
                      );
                    } else if (playing != true || completed) {
                      return IconButton(
                        color: Colors.blueGrey,
                        disabledColor: Colors.grey,
                        icon: const Icon(Icons.play_circle_outline),
                        iconSize: 60,
                        onPressed: value.audioPlayer.play,
                      );
                    } else {
                      return IconButton(
                        color: Colors.blueGrey,
                        disabledColor: Colors.grey,
                        icon: const Icon(Icons.pause_circle_outline),
                        iconSize: 60,
                        onPressed: value.audioPlayer.pause,
                      );
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: value.onNextPagePressed,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(90.0),
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.blueGrey,
                    size: 30,
                  ),
                ),
              ],
            ),
          )
          // Container(
          //   height: 200,
          //   // margin: const EdgeInsets.only(
          //   //   top: 10,
          //   // ),
          //   padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          //   decoration: const BoxDecoration(
          //     gradient: LinearGradient(
          //       begin: Alignment.center,
          //       end: Alignment(-0.2, -0.5),
          //       stops: [-1.0, 0.1, 0.1, 0.2],
          //       colors: [
          //         Color.fromARGB(255, 72, 69, 66),
          //         Color.fromARGB(255, 72, 69, 66),
          //         Color.fromARGB(255, 72, 69, 66),
          //         Color.fromARGB(255, 72, 69, 66),
          //       ],
          //       tileMode: TileMode.clamp,
          //     ),
          //     color: Color.fromARGB(255, 92, 109, 110),
          //     borderRadius: BorderRadius.only(
          //         topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          //   ),
          //   child: Stack(
          //     children: [
          //       Column(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           // ListTile(
          //           //   title: Padding(
          //           //     padding: const EdgeInsets.only(
          //           //       bottom: 16,
          //           //     ),
          //           //     child: Text(
          //           //       "${widget.name}  ${widget.subtitle}",
          //           //       style: const TextStyle(
          //           //           height: 1.5,
          //           //           fontSize: 16,
          //           //           color: Colors.white,
          //           //           fontWeight: FontWeight.w700),
          //           //     ),
          //           //   ),
          //           //   subtitle: widget.index == 0
          //           //       ? const SizedBox()
          //           //       : Consumer<RadioController>(
          //           //           builder: (context, value, child) {
          //           //             return StreamBuilder<PositioneData>(
          //           //                 stream: value.positioneDataStream,
          //           //                 builder: (context, snapshot) {
          //           //                   final positionData = snapshot.data;

          //           //                   return ProgressBar(
          //           //                     barHeight: 4,
          //           //                     baseBarColor: Colors.grey.shade400,
          //           //                     bufferedBarColor: Colors.white,
          //           //                     progressBarColor: Colors.blueGrey,
          //           //                     thumbColor: Colors.blueGrey,
          //           //                     thumbRadius: 6,
          //           //                     timeLabelTextStyle: const TextStyle(
          //           //                         height: 1.2,
          //           //                         color: Colors.white,
          //           //                         fontSize: 12,
          //           //                         fontWeight: FontWeight.bold),
          //           //                     progress: positionData?.positione ??
          //           //                         Duration.zero,
          //           //                     buffered:
          //           //                         positionData?.bufferedPosition ??
          //           //                             Duration.zero,
          //           //                     total: positionData?.duration ??
          //           //                         Duration.zero,
          //           //                     onSeek: value.audioPlayer.seek,
          //           //                   );
          //           //                 });
          //           //           },
          //           //         ),
          //           //   // trailing: Container(
          //           //   //   decoration: BoxDecoration(
          //           //   //     shape: BoxShape.circle,
          //           //   //     border: Border.all(
          //           //   //       color: Colors.white,
          //           //   //       width: 2.0,
          //           //   //     ),
          //           //   //   ),
          //           //   //   child: CircleAvatar(
          //           //   //     radius: 25,
          //           //   //     backgroundImage: NetworkImage(image),
          //           //   //   ),
          //           //   // ),
          //           // ),
          //           NextPreviousButton(
          //             pageController: widget.pageController,
          //             index: widget.index,
          //           ),
          //         ],
          //       ),
          //       widget.index == 0 ? const SizedBox() : const RefreshButton(),
          //     ],
          //   ),
          // ),

          // const SizedBox(
          //   height: 25,
          // ),
        ],
      ),
    );
  }
}

class RefreshButton extends StatelessWidget {
  const RefreshButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      child: Consumer<RadioController>(
        builder: (context, value, child) {
          return AnimateIcons(
              duration: const Duration(milliseconds: 250),
              startIconColor: Colors.white,
              endIconColor: Colors.white,
              size: 30,
              startIcon: Icons.refresh,
              endIcon: Icons.refresh,
              onStartIconPress: () {
                value.refreshAudioUrls();
                value.audioPlayer.stop();

                return true;
              },
              onEndIconPress: () {
                value.refreshAudioUrls();
                value.audioPlayer.stop();
                return true;
              },
              controller: value.refreshController);
        },
      ),
    );
  }
}

class NextPreviousButton extends StatelessWidget {
  final PageController pageController;
  final int index;

  const NextPreviousButton({
    Key? key,
    required this.pageController,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioController>(
      builder: (context, value, child) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              if (pageController.page != 0) {
                pageController.previousPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              } else {
                pageController.jumpToPage(
                    (pageController.page!.toInt() - 1) % listInfo.length);
              }
              value.audioPlayer.stop();
            },
            icon: const Icon(
              Icons.skip_previous,
              size: 40,
              color: Colors.white,
            ),
          ),
          Consumer<AudioController>(
            builder: (context, audioController, child) => AnimateIcons(
              startIcon: listInfo[index].audioUrl != listInfo[index].audioUrl
                  ? Icons.pause_circle
                  : Icons.play_circle,
              endIcon: listInfo[index].audioUrl != listInfo[index].audioUrl
                  ? Icons.play_circle
                  : Icons.pause_circle,
              controller: audioController.buttonController,
              size: 50.0,
              onStartIconPress: () {
                audioController.playAudio();

                return true;
              },
              onEndIconPress: () {
                audioController.audioPlayer.stop();

                return true;
              },
              duration: const Duration(milliseconds: 250),
              startIconColor: Colors.white,
              endIconColor: Colors.white,
              clockwise: false,
            ),
          ),
          Consumer<AudioController>(
            builder: (context, value, child) => IconButton(
              onPressed: () {
                if (pageController.page != listInfo.length - 1) {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  );
                } else {
                  pageController.jumpToPage(
                      (pageController.page!.toInt() + 1) % listInfo.length);
                }

                value.audioPlayer.stop();
              },
              icon: const Icon(
                Icons.skip_next,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InfoData {
  String id;
  String image;
  String audioUrl;
  String name;
  String subtitle;
  InfoData(
      {required this.id,
      required this.image,
      required this.name,
      required this.subtitle,
      required this.audioUrl});
}
