import 'package:avrod/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
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
          child: const Scaffold(
           backgroundColor:  Color(0xffF3EEE2),
            body: RadioAudioPlayer(),
          ),
        ),
      ),
    );
  }
}
