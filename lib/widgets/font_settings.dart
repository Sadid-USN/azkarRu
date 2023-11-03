import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'package:avrod/generated/locale_keys.g.dart';

class FontsSettings extends StatefulWidget {
  double arabicFontSize;
  double fontSize;
  final void Function(double) onArabicFontSizeChanged;
  final void Function(double) onFontSizeChanged;

  FontsSettings({
    Key? key,
    required this.arabicFontSize,
    required this.fontSize,
    required this.onArabicFontSizeChanged,
    required this.onFontSizeChanged,
  }) : super(key: key);

  @override
  _FontsSettingsState createState() => _FontsSettingsState();
}

class _FontsSettingsState extends State<FontsSettings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 238, 233, 181),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      height: 20.5.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          Text(LocaleKeys.fontsize.tr(),
              style: const TextStyle(color: Colors.black)),
          const SizedBox(height: 10),
          SliderTheme(
            data: SliderThemeData(overlayShape: SliderComponentShape.noOverlay),
            child: Slider(
              activeColor: Colors.grey,
              inactiveColor: Colors.grey,
              thumbColor: Colors.white,
              value: widget.fontSize,
              min: 16, // Change the minimum value as per your requirement
              max: 25, // Change the maximum value as per your requirement
              divisions: 9, // You can adjust the number of divisions as needed
              onChanged: (double value) {
                setState(() {
                  widget.fontSize = value;
                  widget.onFontSizeChanged(value);
                });
              },
              label: widget.fontSize
                  .toStringAsFixed(1), // Display the selected value
            ),
          ),
          const SizedBox(height: 10),
          const Text("حجم الخط", style: TextStyle(color: Colors.black)),
          const SizedBox(height: 10),
          SliderTheme(
            data: SliderThemeData(overlayShape: SliderComponentShape.noOverlay),
            child: Slider(
              activeColor: Colors.grey,
              inactiveColor: Colors.grey,
              thumbColor: Colors.white,
              value: widget.arabicFontSize,
              min: 25, // Change the minimum value as per your requirement
              max: 40, // Change the maximum value as per your requirement
              divisions: 15, // You can adjust the number of divisions as needed
              onChanged: (double value) {
                setState(() {
                  widget.arabicFontSize = value;
                  widget.onArabicFontSizeChanged(value);
                });
              },
              label: widget.arabicFontSize
                  .toStringAsFixed(1), // Display the selected value
            ),
          ),
        ],
      ),
    );
  }
}
