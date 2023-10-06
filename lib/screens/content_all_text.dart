import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../colors/colors.dart';
import '../generated/locale_keys.g.dart';
import '../style/my_text_style.dart';

class AllTextsContent extends StatelessWidget {
  final double fontSize;
  final void Function()? increaseSize;
  final void Function()? decreaseSize;
  final String text;
  final String arabic;
  final String translation;

  const AllTextsContent({
    Key? key,
    required this.fontSize,
    required this.increaseSize,
    required this.decreaseSize,
    required this.text,
    required this.arabic,
    required this.translation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: decreaseSize,
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    size: 25,
                  ),
                ),
                Text(
                  fontSize.toStringAsFixed(0),
                ),
                IconButton(
                  onPressed: increaseSize,
                  icon: const Icon(
                    Icons.add_circle_outline,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                ExpandablePanel(
                  header: Text(
                    "",
                    textAlign: TextAlign.start,
                    style: expandableTextStyle,
                  ),
                  collapsed: SelectableText(
                    text,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: fontSize,
                      color: textColor,
                    ),
                  ),
                  expanded: SelectableText(
                    text,
                    maxLines: 1,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: fontSize,
                        color: textColor,
                        overflow: TextOverflow.fade),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 1.0),
                          blurRadius: 2.0)
                    ],
                    gradient: LinearGradient(
                      colors: [bgColor, bgColor],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  padding: const EdgeInsets.all(40),
                  child: ExpandablePanel(
                    header: const Text(''),
                    collapsed: SelectableText(
                      arabic,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.notoSansArabic(
                        
                        
                     fontStyle: FontStyle.normal,
                        
                        wordSpacing: 1.0,
                        color: textColor,
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    expanded: SelectableText(
                      arabic,
                      maxLines: 1,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily:
                            'JannaLT', // Use the custom font family name
                        textBaseline: TextBaseline.alphabetic,
                        wordSpacing: 1.5,
                        color: textColor,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Center(
                  child: ExpandablePanel(
                    header: Text(
                      LocaleKeys.translation.tr(),
                      textAlign: TextAlign.start,
                      style: expandableTextStyle,
                    ),
                    collapsed: SelectableText(
                      translation,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: fontSize,
                        color: textColor,
                      ),
                    ),
                    expanded: SelectableText(
                      translation,
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: fontSize,
                        color: textColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 120,
          )
        ],
      ),
    );
  }
}
