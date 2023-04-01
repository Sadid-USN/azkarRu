import 'package:avrod/controllers/audio_controller.dart';
import 'package:avrod/data/book_map.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:clay_containers/constants.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:animate_icons/animate_icons.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class MyAudioPlayer extends StatelessWidget {
  final List<Texts>? texts;
  final Chapters? chapter;
  const MyAudioPlayer({Key? key, this.texts, this.chapter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClayContainer(
      spread: 0.0,
      curveType: CurveType.none,
      height: 70,
      depth: 10,
      color: const Color(0xff8D7E6F),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AnimateIcons(
            startIcon: Icons.play_circle,
            endIcon: Icons.pause,
            controller: AudioController().buttonController,
            size: 40.0,
            onStartIconPress: () {
              AudioController().playSound(chapter!.texts![0].url!);

              return true;
            },
            onEndIconPress: () {
              AudioController().pauseSound();
              // pauseSound();
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
                Consumer<AudioController>(
                  builder: (context, value, child) => Slider(
                      onChangeEnd: ((value) {
                        AudioController()
                            .seekAudio(Duration(seconds: value.toInt()));
                        // seekAudio(Duration(seconds: value.toInt()));
                      }),
                      activeColor: Colors.white,
                      inactiveColor: Colors.grey[800],
                      min: 0.0,
                      max: AudioController().duration.inSeconds.toDouble(),
                      value: AudioController().position.inSeconds.toDouble(),
                      onChanged: (double newPosition) {
                        newPosition =
                            AudioController().position.inSeconds.toDouble();
                        newPosition =
                            AudioController().duration.inSeconds.toDouble();
                      }),
                ),
                Expanded(
                    child: Text(
                  AudioController().position.toString().split('.').first,
                  style: const TextStyle(fontSize: 10, color: Colors.white),
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
                controller: AudioController().copyController,
                size: 33.0,
                onStartIconPress: () {
                  FlutterClipboard.copy(
                      '*${chapter?.name}*\n${texts![0].text!}\n☘️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️☘️\n${texts![0].arabic!}\n${texts![0].translation!}\n☘️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️☘️\nСкачать приложкние *Azkar* в Playsore\n👇👇👇👇\nhttps://play.google.com/store/apps/details?id=com.darulasar.Azkar');

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
                        '*${chapter?.name}*\n${texts![0].text!}\n☘️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️☘️\n${texts![0].arabic!}\n${texts![0].translation!}\n☘️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️☘️\nСкачать приложкние *Azkar* в Playsore\n👇👇👇👇\nhttps://play.google.com/store/apps/details?id=com.darulasar.Azkar');
                  },
                  icon:
                      const Icon(Icons.share, size: 33.0, color: Colors.white)),
              const SizedBox(
                width: 5,
              )
            ],
          )
        ],
      ),
    );
  }
}
