import 'dart:math';

import 'package:animate_icons/animate_icons.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import 'package:avrod/controllers/audio_controller.dart';

import '../screens/text_screen.dart';

class RadioAudioPlayer extends StatelessWidget {
  const RadioAudioPlayer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    return AnimationLimiter(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height /2 * 0.5,
            child: PageView.builder(
            
              controller: pageController,
              itemCount: listInfo.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredGrid(
                  position: index,
                  duration: const Duration(milliseconds: 400),
                  columnCount: listInfo.length,
                  child: ScaleAnimation(
                    child: AudiPlyerCard(
                      index: index,
                      audioUrl: listInfo[index].audioUrl,
                      image: listInfo[index].image,
                      name: listInfo[index].name,
                      subtitle: listInfo[index].id,
                      pageController: pageController,
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 50,)
      
          
       
        ],
      ),
    );
  }
}

class AudiPlyerCard extends StatelessWidget {
  final String audioUrl;
  final String image;
  final String name;
  final String subtitle;
  final PageController pageController;
  final int index;

  const AudiPlyerCard({
    Key? key,
    required this.audioUrl,
    required this.image,
    required this.name,
    required this.subtitle,
    required this.pageController,
    required this.index,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
    height: 150,
      margin: const EdgeInsets.only(top: 16, right: 10, left: 10),
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.center,
          end: Alignment(-0.2, -0.5),
          stops: [-1.0, 0.1, 0.1, 0.2],
          colors: [
            Color.fromARGB(255, 92, 109, 110),
            Color.fromARGB(255, 92, 109, 110),
            Color.fromARGB(255, 66, 50, 65),
            Color.fromARGB(255, 66, 50, 65),
          ],
          tileMode: TileMode.clamp,
        ),
        color: const Color.fromARGB(255, 92, 109, 110),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          ListTile(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                name,
                style:  const TextStyle(
                    height: 1.5,
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
            ),
            subtitle: index == 0 ? const SizedBox():
            Consumer<AudioController>(
              builder: (context, value, child) {
                return StreamBuilder<PositioneData>(
                    stream: value.positioneDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
    
                      return 
                       ProgressBar(
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
                        progress:
                            positionData?.positione ?? Duration.zero,
                        buffered: positionData?.bufferedPosition ??
                            Duration.zero,
                        total: positionData?.duration ?? Duration.zero,
                        onSeek: value.audioPlayer.seek,
                      );
                    });
              },
            ),
            trailing: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
              ),
              child: CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(image),
              ),
            ),
         
          ),
    
           NextPreviousButton(pageController: pageController, index: index,),
        ],
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
      builder: (context, value, child) =>  
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    
        children: [
          IconButton(
            onPressed: () {
              if (pageController.page != 0) {
                pageController.previousPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              } else {
                pageController.jumpToPage((pageController.page!.toInt() - 1) % listInfo.length);
              }
              value.audioPlayer.stop();
            },
            icon: const Icon(Icons.skip_previous, size: 40, color: Colors.white,),
          ),

          Consumer<AudioController>(
                builder: (context, audioController, child) => AnimateIcons(
                  startIcon:
                      listInfo[index].audioUrl != listInfo[index].audioUrl
                          ? Icons.pause_circle
                          : Icons.play_circle,
                  endIcon:
                      listInfo[index].audioUrl != listInfo[index].audioUrl
                          ? Icons.play_circle
                          : Icons.pause_circle,
                  controller: audioController.buttonController,
                  size: 45.0,
                  onStartIconPress: () {
                    audioController.playAudio(
                      url: listInfo[index].audioUrl,
                      album: listInfo[index].name,
                      id: listInfo[index].id,
                      title: listInfo[index].subtitle,
                      imgUrl: listInfo[index].image,
                    );
    
                    return true;
                  },
                  onEndIconPress: () {
                    audioController.audioPlayer.pause();
    
                    return true;
                  },
                  duration: const Duration(milliseconds: 250),
                  startIconColor: Colors.white,
                  endIconColor: Colors.white,
                  clockwise: false,
                ),
              ),
          IconButton(
            onPressed: () {
              if (pageController.page != listInfo.length - 1) {
                pageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              } else {
                pageController.jumpToPage((pageController.page!.toInt() + 1) % listInfo.length);
              }

                value.audioPlayer.stop();
            },
            icon: const Icon(Icons.skip_next, size: 40, color: Colors.white,),
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

List<InfoData> listInfo = [
  InfoData(
      id: "1",
      audioUrl: 'https://s5.radio.co/sdaff9bd16/listen',
      image:
          'https://i.pinimg.com/564x/39/aa/2b/39aa2b0f6647ae3b098820c0285271f2.jpg',
      name: 'furqan-radio',
      subtitle: '24/7'),
  InfoData(
      id: "2",
      audioUrl:
          'https://download.quranicaudio.com/qdc/siddiq_minshawi/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/7/mohamed-siddiq-el-minshawi-profile.jpeg?v=1',
      name: 'Mohamed Siddiq',
      subtitle: 'al-Minshawi'),
  InfoData(
      id: "3",
      audioUrl:
          'https://download.quranicaudio.com/qdc/khalil_al_husary/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/5/mahmoud-khalil-al-hussary-profile.png?v=1',
      name: 'Mahmoud Khalil',
      subtitle: 'Al-Husary'),
  InfoData(
      id: "4",
      audioUrl:
          'https://download.quranicaudio.com/qdc/abdul_baset/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/1/abdelbasset-profile.jpeg?v=1',
      name: 'AbdulBaset',
      subtitle: 'AbdulSamad'),
  InfoData(
      id: "5",
      audioUrl:
          'https://download.quranicaudio.com/qdc/mishari_al_afasy/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/6/mishary-rashid-alafasy-profile.jpeg?v=1',
      name: 'Mishari Rashid',
      subtitle: 'al-`Afasy'),
  InfoData(
      id: "6",
      audioUrl:
          'https://download.quranicaudio.com/qdc/abu_bakr_shatri/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/3/abu-bakr-al-shatri-pofile.jpeg?v=1',
      name: 'Abu Bakr',
      subtitle: 'al-Shatri'),
  InfoData(
      id: "7",
      audioUrl:
          'https://download.quranicaudio.com/qdc/khalifah_taniji/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/11/khalifa-al-tunaiji-profile.jpeg?v=1',
      name: ' Khalifa Musabah',
      subtitle: 'Al-Tunaiji'),
  InfoData(
      id: "8",
      audioUrl:
          'https://download.quranicaudio.com/qdc/hani_ar_rifai/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/4/hani-ar-rifai-profile.jpeg?v=1',
      name: 'Sheikh Hani',
      subtitle: 'ar-Rifai'),
];
