import 'dart:math';

import 'package:animate_icons/animate_icons.dart';
import 'package:avrod/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

import 'package:avrod/controllers/audio_controller.dart';

class RadioAudioPlayer extends StatelessWidget {
  const RadioAudioPlayer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: AnimationLimiter(
        child: ListView.builder(
            itemCount: listInfo.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 400),
                columnCount: listInfo.length,
                child: ScaleAnimation(
                  child: AudiPlyerCard(
                    audioUrl: listInfo[index].audioUrl,
                    image: listInfo[index].image,
                    name: listInfo[index].name,
                    subtitle: listInfo[index].subtitle,
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class AudiPlyerCard extends StatelessWidget {
  final String audioUrl;
  final String image;
  final String name;
  final String subtitle;

  const AudiPlyerCard({
    Key? key,
    required this.audioUrl,
    required this.image,
    required this.name,
    required this.subtitle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 16, right: 10, left: 10),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 2,
                offset: const Offset(0, 3),
              ),
            ],
            color: const Color(0xffF2DFC7),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              ListTile(
                title: Text(
                  name,
                  style: TextStyle(
                      height: 1.5,
                      fontSize: 14,
                      color: textColor,
                      fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: textColor,
                  ),
                ),
                trailing: CircleAvatar(
                  radius: 25,
                  backgroundImage: NetworkImage(image),
                ),
                leading: Consumer<AudioController>(
                  builder: (context, audioController, child) => AnimateIcons(
                    startIcon: Icons.play_circle,
                    endIcon: audioController.url != audioUrl
                        ? Icons.play_circle
                        : Icons.pause,
                    controller: audioController.buttonController,
                    size: 45.0,
                    onStartIconPress: () {
                      if (audioController.url != audioUrl) {
                        audioController.stopPlaying();
                      }
                      audioController.playSound(audioUrl);
                      return true;
                    },
                    onEndIconPress: () {
                      audioController.stopPlaying();
                      return true;
                    },
                    duration: const Duration(milliseconds: 250),
                    startIconColor: Colors.white,
                    endIconColor: Colors.white,
                    clockwise: false,
                  ),
                ),
              ),
              // Positioned(
              //   top: 10,
              //   right: 80,
              //   child: Consumer<AudioController>(
              //     builder: (context, value, child) => IconButton(
              //         onPressed: () {
              //           value.skipTrack();
              //         },
              //         icon: const Icon(
              //           Icons.skip_next,
              //           color: Colors.white,
              //           size: 40,
              //         )),
              //   ),
              // ),
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }
}

class InfoData {
  String image;
  String audioUrl;
  String name;
  String subtitle;
  InfoData(
      {required this.image,
      required this.name,
      required this.subtitle,
      required this.audioUrl});
}

List<InfoData> listInfo = [
  InfoData(
      audioUrl:
          'https://download.quranicaudio.com/qdc/siddiq_minshawi/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/7/mohamed-siddiq-el-minshawi-profile.jpeg?v=1',
      name: 'Mohamed Siddiq',
      subtitle: 'al-Minshawi'),
  InfoData(
      audioUrl:
          'https://download.quranicaudio.com/qdc/khalil_al_husary/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/5/mahmoud-khalil-al-hussary-profile.png?v=1',
      name: 'Mahmoud Khalil',
      subtitle: 'Al-Husary'),
  InfoData(
      audioUrl:
          'https://download.quranicaudio.com/qdc/abdul_baset/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/1/abdelbasset-profile.jpeg?v=1',
      name: 'AbdulBaset',
      subtitle: 'AbdulSamad'),
  InfoData(
      audioUrl:
          'https://download.quranicaudio.com/qdc/mishari_al_afasy/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/6/mishary-rashid-alafasy-profile.jpeg?v=1',
      name: 'Mishari Rashid',
      subtitle: 'al-`Afasy'),
  InfoData(
      audioUrl:
          'https://download.quranicaudio.com/qdc/abu_bakr_shatri/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/3/abu-bakr-al-shatri-pofile.jpeg?v=1',
      name: 'Abu Bakr',
      subtitle: 'al-Shatri'),
  InfoData(
      audioUrl:
          'https://download.quranicaudio.com/qdc/khalifah_taniji/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/11/khalifa-al-tunaiji-profile.jpeg?v=1',
      name: ' Khalifa Musabah',
      subtitle: 'Al-Tunaiji'),
  InfoData(
      audioUrl:
          'https://download.quranicaudio.com/qdc/hani_ar_rifai/murattal/${Random().nextInt(114) + 1}.mp3',
      image:
          'https://static.qurancdn.com/images/reciters/4/hani-ar-rifai-profile.jpeg?v=1',
      name: 'Sheikh Hani',
      subtitle: 'ar-Rifai'),
];
