import 'package:avrod/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TryAgainButton extends StatelessWidget {
  final void Function()? onPressed;
  final String errorTitle;
  const TryAgainButton({
    Key? key,
    required this.onPressed,
    required this.errorTitle,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            errorTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Image.asset(
            "icons/location_off.png",
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              elevation: 3,
              backgroundColor: const Color(0xffFA5F62),
              padding: const EdgeInsets.symmetric(vertical: 16),
              foregroundColor: Colors.blueGrey.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LocaleKeys.tryAgain.tr(),
                  style: GoogleFonts.ptSerif(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
