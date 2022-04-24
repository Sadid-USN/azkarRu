import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

String _lounchUrlGmail = 'https://mail.google.com/mail/u/0/#inbox';
String _linkInstagramm =
    'https://instagram.com/darul_asar?utm_medium=copy_link';
String _avrodAppLink =
    'https://play.google.com/store/apps/details?id=com.darulasar.avrod';
String _youTubeLink =
    'https://www.youtube.com/channel/UCR2bhAQKRXDmE4v_rDVNOrA';
Future<void> _launchInBrowser(String url) async {
  if (await canLaunch(url)) {
    await launch(url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'header_key': 'header_value'});
  } else {
    throw 'Пайванд кушода нашуд $url';
  }
}

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

final DrawerOption _option = DrawerOption(
  title: const Text(
    'Поделиться с другими',
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
final DrawerOption _option_2 = _option.copyWith(
  title: const Text(
    'Поддержать',
    style: TextStyle(fontSize: 14, color: Colors.white),
  ),
  icon: Icon(
    FontAwesomeIcons.donate,
    color: Colors.white,
    size: 20.sp,
  ),
  onTap: () {},
);

final DrawerOption _option_3 = _option.copyWith(
  title: const Text(
    'ulamuyaman@gmail.com',
    style: TextStyle(fontSize: 14, color: Colors.white),
  ),
  icon: Icon(
    FontAwesomeIcons.envelope,
    color: Colors.white,
    size: 18.sp,
  ),
  onTap: () {
    _launchInBrowser(_lounchUrlGmail);
  },
);
final DrawerOption _option_4 = _option.copyWith(
  title: const Text(
    'Avrod на таджиксом',
    style: TextStyle(fontSize: 14, color: Colors.white),
  ),
  icon: const CircleAvatar(
    radius: 15,
    backgroundImage: AssetImage('icons/iconavrod.png'),
  ),
  onTap: () {
    _launchInBrowser(_avrodAppLink);
  },
);
final DrawerOption _option_5 = _option.copyWith(
  title: const Text(
    '@darul_asar',
    style: TextStyle(fontSize: 16, color: Colors.white),
  ),
  icon: Icon(
    FontAwesomeIcons.instagram,
    color: Colors.pinkAccent,
    size: 21.sp,
  ),
  onTap: () {
    _launchInBrowser(_linkInstagramm);
  },
);
final DrawerOption _option_6 = _option.copyWith(
  title: const Text(
    'Darul-asar',
    style: TextStyle(fontSize: 14, color: Colors.white),
  ),
  icon: Icon(
    FontAwesomeIcons.youtube,
    color: Colors.red,
    size: 21.sp,
  ),
  onTap: () {
    _launchInBrowser(_youTubeLink);
  },
);
final List<DrawerOption> drawerOptionList = [
  _option,
  _option_2,
  _option_3,
  _option_4,
  _option_5,
  _option_6,
];
