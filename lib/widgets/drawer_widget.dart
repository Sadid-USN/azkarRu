import 'package:avrod/screens/support_screen.dart';
import 'package:avrod/widgets/drawer_option_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:sizer/sizer.dart';

class DrawerModel extends StatefulWidget {
  const DrawerModel({Key? key}) : super(key: key);

  @override
  State<DrawerModel> createState() => _DrawerModelState();
}

class _DrawerModelState extends State<DrawerModel> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black26,
      child: Stack(
        children: [
          _header(context),
          Container(
              padding: const EdgeInsets.only(top: 200),
              child: Column(
                children: [
                  _BuildListTile(
                    title: drawerTitles[0].tr(),
                    icon: icons[0],
                    onTap: () {
                      Share.share(
                        azkarGoogPlayLink,
                      );
                    },
                  ),
                  _BuildListTile(
                    title: drawerTitles[1].tr(),
                    icon: icons[1],
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const SupportScreen();
                      }));
                    },
                  ),
                  _BuildListTile(
                    title: drawerTitles[2].tr(),
                    icon: icons[2],
                    onTap: () {
                        Share.share(
                        youTubeLink,
                      );
                    },
                  ),
                  _BuildListTile(
                    title: drawerTitles[3].tr(),
                    icon: icons[3],
                    onTap: () {
                        Share.share(
                        linkInstagramm,
                      );
                    },
                  ),
                  _BuildListTile(
                    title: drawerTitles[4].tr(),
                    icon: icons[4],
                    onTap: () {
                        Share.share(
                        lounchUrlGmail,
                      );
                    },
                  ),
                ],
              )),
        ],
      ),
    );
  }
}

class _BuildListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final void Function()? onTap;
  const _BuildListTile({
    required this.title,
    required this.icon,
    // ignore: unused_element
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ),
        leading: Icon(
          icon,
          color: Colors.white,
          size: 20.sp,
        ),
        onTap: onTap,
      ),
    );
  }
}

Widget _header(BuildContext context) {
  return Material(
    color: Colors.transparent,
    child: Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(
          top: 20 + MediaQuery.of(context).padding.top, bottom: 25),
      child: Column(
        children: const [
          ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(23.0),
            ),
            child: Image(
              height: 180,
              image: AssetImage('icons/iconavrod.png'),
            ),
          ),
        ],
      ),
    ),
  );
}
