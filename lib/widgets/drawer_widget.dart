import 'package:avrod/widgets/drawer_option_list.dart';
import 'package:flutter/material.dart';

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
            child: ListView.builder(
              itemCount: drawerOptionList.length,
              itemBuilder: (context, index) {
                final optionList = drawerOptionList[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ListTile(
                    title: optionList.title,
                    leading: optionList.icon,
                    onTap: () {
                      optionList.onTap();
                    },
                  ),
                );
              },
            ),
          ),
        ],
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
