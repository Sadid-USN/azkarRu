import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

class MyFabCircularMenu extends StatefulWidget {
  const MyFabCircularMenu({Key? key}) : super(key: key);

  @override
  State<MyFabCircularMenu> createState() => _MyFabCircularMenuState();
}

const String _lounchUrlGmail =
    'https://accounts.google.com/signout/chrome/landing?continue=https://mail.google.com&oc=https://mail.google.com&hl=en';
const String _linkInstagramm =
    'https://instagram.com/darul_asar?utm_medium=copy_link';
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

class _MyFabCircularMenuState extends State<MyFabCircularMenu> {
  @override
  Widget build(BuildContext context) {
    return FabCircularMenu(
      animationDuration: const Duration(milliseconds: 800),
      fabOpenIcon: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
      ringDiameter: 350,
      ringWidth: 70,
      ringColor: Colors.black38,
      fabCloseColor: Colors.transparent,
      fabColor: Colors.transparent,
      fabCloseIcon: const Icon(
        Icons.close,
        color: Colors.white,
      ),
      fabElevation: 0.0,
      animationCurve: Curves.bounceIn,
      alignment: Alignment.topLeft,
      fabSize: 45,
      children: [
        const SizedBox(
          height: 1,
        ),
        IconButton(
            onPressed: () {
              DropdownButton<String>(
                items: <String>['A', 'B', 'C', 'D'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (_) {},
              );
            },
            icon: Icon(
              Icons.language,
              color: Colors.white,
              size: 20.sp,
            )),
        IconButton(
            onPressed: () {
              Share.share(
                  'Барномаи «Avrod» дуоҳои саҳеҳи набави (ﷺ) бо забони тоҷикӣ, ба дустону наздикони худ равон кунед, чун роҳнамоӣ ба амали хайр дар савоб монанди анҷомдиҳандаи он аст.\nhttps://play.google.com/store/apps/details?id=com.darulasar.avrod');
            },
            icon: Icon(
              Icons.share,
              color: Colors.white,
              size: 20.sp,
            )),
        IconButton(
            onPressed: () {
              Share.share(_lounchUrlGmail);
            },
            icon: Icon(
              FontAwesomeIcons.envelope,
              color: Colors.white,
              size: 18.sp,
            )),
        IconButton(
            onPressed: () {
              Share.share(_linkInstagramm);
            },
            icon: Icon(
              FontAwesomeIcons.instagram,
              color: Colors.pinkAccent,
              size: 21.sp,
            )),
      ],
    );
  }
}


// FabCircularMenu(
            
//             fabOpenIcon: const Icon(Icons.menu, color: Colors.white,),
//              ringDiameter: 450,
//              ringWidth: 70,
//             ringColor: Colors.black45,
//             fabCloseColor: Colors.black26,
//             fabColor: Colors.black26,
//             fabCloseIcon: const Icon(Icons.close, color: Colors.white,),
//             fabElevation: 0.0,
//             animationCurve: Curves.bounceIn,
//             alignment: Alignment.topLeft,
//             fabSize: 45,
//             children: const [
//               Icon(Icons.share),
//               Icon(Icons.share),
//               Icon(Icons.share),
//             ],
//           ),
