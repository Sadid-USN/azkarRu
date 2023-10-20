import 'package:flutter/material.dart';

import 'package:avrod/colors/colors.dart';

class CostomButton extends StatelessWidget {
  final Widget child;
  final void Function()? onPressed;
  const CostomButton({
    Key? key,
    required this.child,
    this.onPressed,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 3.0,
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
