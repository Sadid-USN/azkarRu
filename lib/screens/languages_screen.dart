import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:avrod/colors/colors.dart';

import '../generated/locale_keys.g.dart';

class LangugesPage extends StatelessWidget {
  const LangugesPage({Key? key}) : super(key: key);

  static String routName = '/langugesPage';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool? result = await exitDialog(context);
        result ??= false;
        return result;
      },
      child: Scaffold(
        backgroundColor: const Color(0xffF3EEE2),
        appBar: AppBar(
          elevation: 0.0,
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xffF2DFC7),
          title: Text(
            LocaleKeys.lang.tr(),
            style: TextStyle(color: textColor),
          ),
          centerTitle: true,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 40,
            ),
            LangButton(
              title: "🇺🇸 English",
              onPressed: () {
                context.setLocale(const Locale('en'));
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(
              height: 16,
            ),
            LangButton(
              title: '🇷🇺  Русский',
              onPressed: () {
                context.setLocale(const Locale('ru'));
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool?> exitDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          title: const Text(""),
          content: const Text("dddd", style: TextStyle(fontSize: 16.0)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel",
                  style: TextStyle(color: Colors.blueGrey)),
            ),
            TextButton(
              onPressed: () {
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else {}
              },
              child: const Text("textConfirm",
                  style: TextStyle(color: Colors.blue)),
            ),
          ],
          backgroundColor: Colors.white,
        );
      },
    );
  }
}

class LangButton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  const LangButton({
    Key? key,
    required this.onPressed,
    required this.title,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: ElevatedButton(
        onPressed: onPressed, //This prop for beautiful expressions
        child: Text(
          title,
          style: GoogleFonts.ptSerif(
              fontSize: 18, fontWeight: FontWeight.w500, color: textColor),
        ), // This child can be everything. I want to choose a beautiful Text Widget
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 243, 225, 183),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          minimumSize:
              const Size(150, 50), //change size of this beautiful button

          shadowColor: Colors
              .grey, //shadow prop is a very nice prop for every button or card widgets.
          elevation: 5, // we can set elevation of this beautiful button
          // change border side of this beautiful button
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                12), //change border radius of this beautiful button thanks to BorderRadius.circular function
          ),
          tapTargetSize: MaterialTapTargetSize.padded,
        ),
      ),
    );
  }
}
