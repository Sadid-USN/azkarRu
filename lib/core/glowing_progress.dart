import 'package:avrod/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:progress_indicators/progress_indicators.dart';

class GlowingProgress extends StatelessWidget {
  const GlowingProgress({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: GlowingProgressIndicator(
          child: SvgPicture.asset(
            'assets/Svg/basmala.svg',
          ),
        ),
      )),
    );
  }
}
