import 'package:avrod/widgets/radio_audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:avrod/colors/colors.dart';


class RadioPlayerScreen extends StatelessWidget {

  const RadioPlayerScreen({
    Key? key,
   
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return    const Scaffold(
          backgroundColor: bgColor,
        
          body: RadioAudioPlayer(),
        );
    
  }
}
