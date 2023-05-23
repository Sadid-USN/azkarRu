import 'package:flutter/material.dart';

import '../models/radio_audioplayer.dart';

class RadioPlayerScreen extends StatelessWidget {
  const RadioPlayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   const Scaffold(
          backgroundColor: Color(0xffF3EEE2),
          // appBar: AppBar(
          //   backgroundColor: const Color(0xffF2DFC7),
          //   leading: Consumer<AudioController>(
          //     builder: (context, value, child) => IconButton(
          //       onPressed: () {
          //         value.stopPlaying();
          //         value.onTapBar(value.selectedIndex);
                
          //       },
          //       icon: const Icon(
          //         Icons.arrow_back_ios,
          //         color: iconColor,
          //       ),
          //     ),
          //   ),
          //   elevation: 3.0,
          //   title: Text(
          //     LocaleKeys.radio.tr(),
          //     style: TextStyle(
          //       fontSize: 14.sp,
          //       color: textColor,
          //       fontWeight: FontWeight.bold,
          //     ),
          //   ),
          //   centerTitle: true,
          // ),
          body: RadioAudioPlayer(),
        );
    
  }
}
