import 'package:flutter/material.dart';

import 'package:avrod/colors/colors.dart';

import '../models/radio_audioplayer.dart';

class RadioPlayerScreen extends StatelessWidget {
  final int ? index;
  const RadioPlayerScreen({
    Key? key,
    this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return    Scaffold(
          backgroundColor: bgColor,
        
          body: RadioAudioPlayer(index: index),
        );
    
  }
}
