import 'package:avrod/screens/support_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';

import '../generated/locale_keys.g.dart';

String lounchUrlGmail = 'https://mail.google.com/mail/u/0/#inbox';
String linkInstagramm =
    'https://instagram.com/darul_asar?utm_medium=copy_link';
String avrodAppLink =
    'https://play.google.com/store/apps/dev?id=4786339481234121988&hl=ru&gl=US';
String youTubeLink =
    'https://www.youtube.com/channel/UCR2bhAQKRXDmE4v_rDVNOrA';
String supportLink = 'https://taplink.cc/avrod';

String azkarGoogPlayLink =
    'В Приложение Азкар собраны тоько достоверные молитвы из причистой сунны пророка (ﷺ).\nhttps://play.google.com/store/apps/details?id=com.darulasar.Azkar';
// Future<void> _launchInBrowser(String url) async {
//   if (await canLaunch(url)) {
//     await launch(url,
//         forceSafariVC: false,
//         forceWebView: false,
//         headers: <String, String>{'header_key': 'header_value'});
//   } else {
//     throw 'Пайванд кушода нашуд $url';
//   }
// }




final List<String> drawerTitles = [
  LocaleKeys.share,
  LocaleKeys.support,
  'Darul-asar',
  LocaleKeys.instagram,
  LocaleKeys.email,
];

final List<IconData> icons = [
  Icons.share,
  FontAwesomeIcons.donate,
  FontAwesomeIcons.youtube,
  FontAwesomeIcons.instagram,
  FontAwesomeIcons.envelope,
];


 onTapList(BuildContext context, int index){
   final List<dynamic> onTaps = [
   Share.share(azkarGoogPlayLink),
   Navigator.push(context, MaterialPageRoute(builder: (context) {
    return const SupportScreen();
  }))

  
];
 return onTaps[index];

  }


