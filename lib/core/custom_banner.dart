import 'package:flutter/material.dart';

class CustomBanner {
  CustomBanner._();

  static void showBanner(
      BuildContext context, String message, Color bgColor, Duration? duration) {
    ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
      actions: [
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
          },
          icon: const Icon(
            Icons.close_outlined,
            color: Colors.white,
          ),
        ),
      ],
      backgroundColor: bgColor,
      content: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              color: Colors.white,
              size: 20,
            ),
            Text(
              message,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    ));

    if (duration != null) {
      // Hide the banner after the specified duration
      Future.delayed(duration, () {
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      });
    }
  }
}
