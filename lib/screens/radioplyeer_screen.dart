import 'package:avrod/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../colors/colors.dart';
import '../controllers/audio_controller.dart';
import '../models/radio_audioplayer.dart';

class RadioPlayerScreen extends StatelessWidget {
  const RadioPlayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AudioController(),
      child: Consumer<AudioController>(
        builder: (context, value, child) => WillPopScope(
          onWillPop: () async {
            value.stopPlaying();
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xffF2DFC7),
              leading: Consumer<AudioController>(
                builder: (context, value, child) => IconButton(
                  onPressed: () {
                    value.stopPlaying();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const HomePage();
                    }));
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: iconColor,
                  ),
                ),
              ),
              elevation: 3.0,
              title: Text(
                "Radio Quran",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
            body: const RadioAudioPlayer(),
          ),
        ),
      ),
    );
  }
}
