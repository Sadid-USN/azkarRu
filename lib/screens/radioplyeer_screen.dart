import 'package:avrod/widgets/radio_audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:avrod/colors/colors.dart';


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
