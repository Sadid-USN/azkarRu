import 'package:flutter/material.dart';

class CustomBanner {
  CustomBanner._();

  static showBanner(
      BuildContext context, String message, Color bgColor, Duration? duration) {
    ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
      actions: [Container()],
      backgroundColor: bgColor,
      content:  SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_outlined,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(message, style: const TextStyle(color: Colors.white, fontSize: 16),)
          ],
        ),
      ),
    ));
  }
}
