import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

import '../generated/locale_keys.g.dart';

String _lounchUrlGmail = 'https://mail.google.com/mail/u/0/#inbox';
String _linkInstagramm =
    'https://instagram.com/darul_asar?utm_medium=copy_link';
String _avrodAppLink =
    'https://play.google.com/store/apps/dev?id=4786339481234121988&hl=ru&gl=US';
String _youTubeLink =
    'https://www.youtube.com/channel/UCR2bhAQKRXDmE4v_rDVNOrA';
String _supportLink = 'https://taplink.cc/avrod';
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

class DrawerOption {
  Widget title;
  Widget icon;
  Function onTap;
  DrawerOption({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  DrawerOption copyWith({
    Widget? title,
    Widget? icon,
    Function? onTap,
  }) {
    return DrawerOption(
      title: title ?? this.title,
      icon: icon ?? this.icon,
      onTap: onTap ?? this.onTap,
    );
  }
}

final DrawerOption option = DrawerOption(
  title: const Text(
    LocaleKeys.share,
    style: TextStyle(fontSize: 14, color: Colors.white),
  ),
  icon: Icon(
    Icons.share,
    color: Colors.white,
    size: 20.sp,
  ),
  onTap: () {
    Share.share(
        'В Приложение Азкар собраны тоько достоверные молитвы из причистой сунны пророка (ﷺ).\nhttps://play.google.com/store/apps/details?id=com.darulasar.Azkar');
  },
);
final DrawerOption option_2 = option.copyWith(
  title: const Text(
    LocaleKeys.support,
    style: TextStyle(fontSize: 14, color: Colors.white),
  ),
  icon: Icon(
    FontAwesomeIcons.donate,
    color: Colors.white,
    size: 20.sp,
  ),
  onTap: () {
    Share.share(_supportLink);
  },
);

final DrawerOption option_3 = option.copyWith(
  title: const Text(
    LocaleKeys.email,
    style: TextStyle(fontSize: 14, color: Colors.white),
  ),
  icon: Icon(
    FontAwesomeIcons.envelope,
    color: Colors.white,
    size: 18.sp,
  ),
  onTap: () {
    Share.share(_lounchUrlGmail);
  },
);
final DrawerOption option_4 = option.copyWith(
  title: const Text(
    LocaleKeys.allApps,
    style: TextStyle(fontSize: 14, color: Colors.white),
  ),
  icon: const CircleAvatar(
    radius: 15,
    backgroundImage: AssetImage('icons/apps.png'),
  ),
  onTap: () {
    Share.share(_avrodAppLink);
  },
);
final DrawerOption option_5 = option.copyWith(
  title:  const Text(
    LocaleKeys.instagram,
    style: TextStyle(fontSize: 16, color: Colors.white),
  ),
  icon: Icon(
    FontAwesomeIcons.instagram,
    color: Colors.pinkAccent,
    size: 21.sp,
  ),
  onTap: () {
    Share.share(_linkInstagramm);
  },
);
final DrawerOption option_6 = option.copyWith(
  title:  const Text(
    'Darul-asar',
    style: TextStyle(fontSize: 14, color: Colors.white),
  ),
  icon: Icon(
    FontAwesomeIcons.youtube,
    color: Colors.red,
    size: 21.sp,
  ),
  onTap: () {
    Share.share(_youTubeLink);
  },
);
final List<String> drawerTitles = [
  LocaleKeys.share,
  LocaleKeys.support,
  LocaleKeys.email,
  LocaleKeys.instagram,
  'Darul-asar',
];

final List<DrawerOption> drawerOptionList = [
  option,
  option_2,
  option_3,
  option_4,
  option_5,
  option_6,
];
