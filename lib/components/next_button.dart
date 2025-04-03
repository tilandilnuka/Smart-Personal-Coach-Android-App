import 'package:flutter/material.dart';
import 'package:smart_personal_coach/constants.dart';

/// Next Button
class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
    required this.onPressed,
    required this.style,
  });

  final void Function()? onPressed;
  final ButtonStyle style;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: style,
      child: const Text(
        'Next',
        style: kNextButtonTextStyle,
      ),
    );
  }
}