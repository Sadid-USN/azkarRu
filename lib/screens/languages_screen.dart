import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:avrod/colors/colors.dart';

import '../generated/locale_keys.g.dart';

class LangugesScreen extends StatelessWidget {
  const LangugesScreen({Key? key}) : super(key: key);

  static String routName = '/langugesPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3.0,
        backgroundColor: const Color(0xffF6DEC4),
        automaticallyImplyLeading: false,
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
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
          const SizedBox(
            height: 16,
          ),
          LangButton(
            title: '🇷🇺  Русский',
            onPressed: () {
              context.setLocale(const Locale('ru'));

              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
          const SizedBox(
            height: 16,
          ),
          LangButton(
            title: '🇹🇯  Тоҷики',
            onPressed: () {
              context.setLocale(const Locale('fr'));

              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
          const SizedBox(
            height: 16,
          ),
          LangButton(
            title: '🇺🇦  Українська',
            onPressed: () {
              context.setLocale(const Locale('uk'));

              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
        ],
      ),
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
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: ElevatedButton(
          onPressed:
              onPressed, // This child can be everything. I want to choose a beautiful Text Widget
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
          ), //This prop for beautiful expressions
          child: Text(
            title,
            style: GoogleFonts.ptSerif(
                fontSize: 18, fontWeight: FontWeight.w500, color: textColor),
          ),
        ),
      ),
    );
  }
}
