import 'package:flutter/material.dart';

BoxDecoration mainScreenGradient = const BoxDecoration(
    // borderRadius: BorderRadius.circular(20),
    gradient: LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomLeft,
  colors: [
    Color(0xffF2DFC7),
    Color(0xffF3EEE2),
  ],
));

BoxDecoration searchScreenGradient = const BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(16.0)),
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomLeft,
      colors: [
        Color(0xffF2DFC7),
        Color(0xffECDBB8),
      ],
    ));
