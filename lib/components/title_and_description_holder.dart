import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:smart_personal_coach/constants.dart';

/// Title and description holder
class InitialScreensTitleAndDescriptionHolder extends StatelessWidget {
  const InitialScreensTitleAndDescriptionHolder({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedTextKit(
          repeatForever: true,
          animatedTexts: [
            ColorizeAnimatedText(
              title,
              textAlign: TextAlign.center,
              textStyle: kLargeBlackTitleTextStyle,
              colors: kBlackTextColorizeColors,
            ),
          ],
        ),
        description == ''
            ? const SizedBox(height: 0)
            : AnimatedTextKit(
                isRepeatingAnimation: false,
                animatedTexts: [
                  ColorizeAnimatedText(
                    description,
                    speed: const Duration(milliseconds: 200),
                    textAlign: TextAlign.center,
                    textStyle: kSmallGreyColorDescriptionTextStyle,
                    colors: kGreyTextColorizeColors,
                  ),
                ],
              ),
      ],
    );
  }
}
