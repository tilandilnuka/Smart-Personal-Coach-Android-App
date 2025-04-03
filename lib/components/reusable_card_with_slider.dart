import 'package:flutter/material.dart';
import 'package:smart_personal_coach/constants.dart';

class ReusableCardWithSlider extends StatelessWidget {
  const ReusableCardWithSlider(
      {super.key,
      required this.text1,
      required this.text2,
      required this.text3,
      required this.value,
      required this.min,
      required this.max,
      required this.onChanged});

  final String text1;
  final String text2;
  final String text3;
  final double value;
  final double min;
  final double max;
  final void Function(double)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(kRadius16))),
      color: kAppThemeColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    text1,
                    style: kSelectCapacityButtonTextStyle.copyWith(
                      color: kWhiteThemeColor,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        text2,
                        style: kSelectCapacityButtonTextStyle.copyWith(
                          color: kWhiteThemeColor,
                        ),
                      ),
                      Text(
                        text3,
                        style: kSmallGreyColorDescriptionTextStyle.copyWith(
                            color: kWhiteThemeColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SliderTheme(
              data: kSliderStyle,
              child: Slider(
                value: value,
                min: min,
                max: max,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
