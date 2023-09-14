import 'package:avrod/controllers/audio_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class AnimationPage extends StatelessWidget {
 const AnimationPage({Key? key, }) : super(key: key);
  @override
  Widget build(BuildContext context) {
     final progressNotifier = context.watch<AudioController>();
    return Scaffold(
      
appBar:  AppBar(
 title: const Text('title'),
 centerTitle: true,
),
 body: Column(
  mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LinearProgressIndicator(
          value: progressNotifier.progress,
        ),
        const SizedBox(height: 40,),
        ElevatedButton(
          onPressed: () {
            // Эмулируем обновление прогресса с задержкой
            for (var i = 0; i <= 80; i++) {
              Future.delayed(const Duration(milliseconds: 100), () {
                progressNotifier.updateProgress(i / 100);
              });
            }
          },
          child: const Text("Запустить процесс"),
        ),
      ],
    )
    );
  }
}