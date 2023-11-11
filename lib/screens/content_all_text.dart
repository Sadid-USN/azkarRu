import 'package:arabic_font/arabic_font.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';



import '../colors/colors.dart';
import '../generated/locale_keys.g.dart';
import '../style/my_text_style.dart';

class AllTextsContent extends StatelessWidget {
  final double fontSize;
  final double arabicFontSize;

  final String text;
  final String arabic;
  final String translation;

  const AllTextsContent({
    Key? key,
    required this.fontSize,
    required this.arabicFontSize,
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
                          color: Colors.black12,
                          offset: Offset(1.0, 3.1),
                          blurRadius: 1.0),
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(-1.0, 0.0), // Shadow to the left
                        blurRadius: 1.0,
                      ),
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
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(
                      //   padding: const EdgeInsets.all(5),
                      //   decoration: BoxDecoration(
                      //       color: Colors.black12,
                      //       borderRadius: BorderRadius.circular(5)),
                      //   child: SelectableText(
                      //     arabicFontSize.round().toStringAsFixed(1),
                      //     style: const TextStyle(
                      //         fontWeight: FontWeight.w600,
                      //         fontSize: 14,
                      //         color: Colors.white70),
                      //   ),
                      // ),
                      ExpandablePanel(
                        header: const Text(''),
                        collapsed: SelectableText(
                          arabic,
                          textAlign: TextAlign.justify,
                          style: ArabicTextStyle(
                            arabicFont: ArabicFont.scheherazade,
                            color: textColor,
                            fontSize: arabicFontSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        expanded: SelectableText(arabic,
                            maxLines: 1,
                            textAlign: TextAlign.justify,
                            style: ArabicTextStyle(
                              arabicFont: ArabicFont.scheherazade,
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            )),
                      ),
                    ],
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
          const Gap(160),
          // const SizedBox(
          //   height: 160,
          // )
        ],
      ),
    );
  }
}
