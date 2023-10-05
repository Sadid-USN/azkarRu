import 'package:avrod/generated/locale_keys.g.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TryAgainButton extends StatelessWidget {
  final void Function()? onPressed;
  const TryAgainButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
        "icons/nowifi.png",
      ))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(
            flex: 4,
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width / 2,
            child: ElevatedButton(
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
                    style:
                        GoogleFonts.ptSerif(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
