import 'package:flutter/material.dart';
import 'package:smart_personal_coach/constants.dart';

class ReusableCardWithDatePicker extends StatelessWidget {
  const ReusableCardWithDatePicker(
      {super.key,
      required this.text1,
      required this.text2,
      required this.onPressed});

  final String text1;
  final String text2;
  final void Function()? onPressed;

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
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kRadius16)),
              ),
              onPressed: onPressed,
              child: const Text(
                'Select Date',
                style: kSelectBodyAreaButtonTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
