import 'package:flutter/material.dart';
import 'package:smart_personal_coach/constants.dart';

/// Title of the app bar
class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    super.key,
    required this.screenId,
  });
  // To get which screen the user is on
  final int screenId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: kAppBarSizedBoxWidth,
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: kAppBarActiveRoundedIconSize,
            color: screenId == 1 ? kAppThemeColor : kGreyThemeColor02,
          ),
          Icon(
            Icons.circle,
            size: kAppBarRoundedIconSize,
            color: screenId == 2 ? kAppThemeColor : kGreyThemeColor02,
          ),
          Icon(
            Icons.circle,
            size: kAppBarRoundedIconSize,
            color: screenId == 3 ? kAppThemeColor : kGreyThemeColor02,
          ),
          Icon(
            Icons.circle,
            size: kAppBarRoundedIconSize,
            color: screenId == 4 ? kAppThemeColor : kGreyThemeColor02,
          ),
          Icon(
            Icons.circle,
            size: kAppBarRoundedIconSize,
            color: screenId == 5 ? kAppThemeColor : kGreyThemeColor02,
          ),
          Icon(
            Icons.circle,
            size: kAppBarRoundedIconSize,
            color: screenId == 6 ? kAppThemeColor : kGreyThemeColor02,
          ),
          Icon(
            Icons.circle,
            size: kAppBarRoundedIconSize,
            color: screenId == 7 ? kAppThemeColor : kGreyThemeColor02,
          ),
        ],
      ),
    );
  }
}
