import 'package:flutter/material.dart';

import '../models/radio_audioplayer.dart';

class RadioPlayerScreen extends StatelessWidget {
  const RadioPlayerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   const Scaffold(
          backgroundColor: Color(0xffF3EEE2),
        
          body: RadioAudioPlayer(),
        );
    
  }
}
