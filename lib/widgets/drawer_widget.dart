import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerModel extends StatefulWidget {
  const DrawerModel({Key? key}) : super(key: key);

  @override
  State<DrawerModel> createState() => _DrawerModelState();
}

class _DrawerModelState extends State<DrawerModel> {
  final String _lounchUrlGmail =
      'https://accounts.google.com/signout/chrome/landing?continue=https://mail.google.com&oc=https://mail.google.com&hl=en';
  final String _linkInstagramm =
      'https://instagram.com/darul_asar?utm_medium=copy_link';
  final String _youTubeLink =
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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black26,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            ListTile(
              title: const Text(
                'Поделиться с другими',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              leading: IconButton(
                  onPressed: () {
                    Share.share(
                        'В Приложение Азкар собраны тоько достоверные молитвы из причистой сунны пророка (ﷺ).\nhttps://play.google.com/store/apps/details?id=com.darulasar.avrod');
                  },
                  icon: Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 20.sp,
                  )),
            ),
            ListTile(
              title: const Text(
                'Языки',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              leading: IconButton(
                  onPressed: () {
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.language,
                    color: Colors.white,
                    size: 20.sp,
                  )),
            ),
            ListTile(
              title: const Text(
                'ulamuyaman@gmail.com',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              leading: IconButton(
                  onPressed: () {
                    _launchInBrowser(_lounchUrlGmail);
                  },
                  icon: Icon(
                    FontAwesomeIcons.envelope,
                    color: Colors.white,
                    size: 18.sp,
                  )),
            ),
            ListTile(
              title: const Text(
                '@darul_asar',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              leading: IconButton(
                  onPressed: () {
                    _launchInBrowser(_linkInstagramm);
                  },
                  icon: Icon(
                    FontAwesomeIcons.instagram,
                    color: Colors.pinkAccent,
                    size: 21.sp,
                  )),
            ),
            ListTile(
              title: const Text(
                'Darul-asar',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              leading: IconButton(
                  onPressed: () {
                    _launchInBrowser(_youTubeLink);
                  },
                  icon: Icon(
                    FontAwesomeIcons.youtube,
                    color: Colors.red,
                    size: 21.sp,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
