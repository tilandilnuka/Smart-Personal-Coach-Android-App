import 'package:flutter/material.dart';
import 'package:smart_personal_coach/constants.dart';

/// Select Capacity Button
class SelectCapacityButton extends StatelessWidget {
  const SelectCapacityButton({
    super.key,
    required this.actualCapacity,
    required this.selectedCapacity,
    required this.title,
    required this.description,
    required this.onPressed,
  });

  final String
      actualCapacity; // Declare a variable to store the actual capacity
  final String
      selectedCapacity; // Declare a variable to store the button capacity
  final String title; // Declare variable to hold the button label
  final String description;
  final void Function()?
      onPressed; // Function to trigger when button is clicked

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: kSelectCapacityButtonStyle.copyWith(
        // If the actual capacity is equal to button capacity, the button color should be blue, otherwise white
        backgroundColor: actualCapacity == selectedCapacity
            ? const MaterialStatePropertyAll(kAppThemeColor)
            : const MaterialStatePropertyAll(kWhiteThemeColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: kSelectCapacityButtonTextStyle.copyWith(
              // If the actual capacity is equal to button capacity, the button text color should be white, otherwise blue
              color: actualCapacity == selectedCapacity
                  ? kWhiteThemeColor
                  : kAppThemeColor,
            ),
          ),
          Text(
            description,
            style: kSmallGreyColorDescriptionTextStyle.copyWith(
              // If the actual capacity is equal to button capacity, the button text color should be white, otherwise blue
              color: actualCapacity == selectedCapacity
                  ? kGreyThemeColor02
                  : kGreyThemeColor,
            ),
          ),
        ],
      ),
    );
  }
}
