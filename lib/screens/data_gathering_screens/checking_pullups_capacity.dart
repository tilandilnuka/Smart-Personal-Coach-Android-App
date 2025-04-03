import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_personal_coach/components/app_bar_title.dart';
import 'package:smart_personal_coach/components/exercise_card.dart';
import 'package:smart_personal_coach/constants.dart';
import 'package:smart_personal_coach/components/next_button.dart';
import 'package:smart_personal_coach/components/select_capacity_button.dart';
import 'package:smart_personal_coach/components/title_and_description_holder.dart';
import 'package:smart_personal_coach/screens/data_gathering_screens/weekly_goal_screen.dart';

/// Screen to get the user's pull ups capacity
class CheckingPullUpsCapacity extends StatefulWidget {
  const CheckingPullUpsCapacity(
      {super.key,
      required this.userGender,
      required this.userBirthDay,
      required this.userHeight,
      required this.userWeight,
      required this.userSelectedBodyAreas,
      required this.userMainGoal,
      required this.userPushUpsCapacity});

  final String userGender;
  final DateTime userBirthDay;
  final int userHeight;
  final int userWeight;
  final List<String> userSelectedBodyAreas;
  final String userMainGoal;
  final String userPushUpsCapacity;

  @override
  State<CheckingPullUpsCapacity> createState() =>
      _CheckingPullUpsCapacityState();
}

class _CheckingPullUpsCapacityState extends State<CheckingPullUpsCapacity> {
  // Creating an instance of FirebaseAuth
  final _auth = FirebaseAuth.instance;

  // Creating an user variable to store logged in user
  late User loggedInUser;

  // Declare a Capacity variable to store user's pull ups capacity
  String _userPullUpsCapacity = "Beginner";

  // User level
  late String _userLevel;

  /// Checking the user's level (Beginner, Intermediate or Advanced)
  void checkingUserLevel() {
    if (_userPullUpsCapacity == "Beginner" &&
        widget.userPushUpsCapacity == "Beginner") {
      setState(() {
        _userLevel = "Beginner";
      });
    } else if (_userPullUpsCapacity == "Advanced" &&
        widget.userPushUpsCapacity == "Advanced") {
      setState(() {
        _userLevel = "Advanced";
      });
    } else {
      setState(() {
        _userLevel = "Intermediate";
      });
    }
  }

  /// Creating a method to get the logged in user
  void getLoggedIntUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      // Show snack bar with error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error has occurred!')),
      );
    }
  }

  @override
  void initState() {
    getLoggedIntUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App Bar
      appBar: AppBar(
        backgroundColor: kWhiteThemeColor,
        scrolledUnderElevation: 0,
        elevation: 0,
        shadowColor: kWhiteThemeColor,
        centerTitle: true,

        /// Show which screen the user is on
        title: const AppBarTitle(
          screenId: 6,
        ),
      ),

      /// Body of the screen
      body: Padding(
        // Add padding around the body of the screen
        padding: const EdgeInsets.only(
          left: kPadding16,
          right: kPadding16,
          bottom: kPadding16,
        ),
        child: Column(
          children: [
            /// Top of the screen
            /// The title and the description
            const Padding(
              padding: EdgeInsets.only(
                bottom: kPadding16,
              ),
              child: InitialScreensTitleAndDescriptionHolder(
                title: 'How many pull-ups can you do at one time?',
                description: '',
              ),
            ),

            /// Middle of the screen
            /// Capacity buttons holder
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(
                  top: kPadding16,
                  bottom: kPadding16,
                ),
                primary: false,
                children: [
                  /// Beginner button
                  SelectCapacityButton(
                    onPressed: () {
                      setState(() {
                        _userPullUpsCapacity = "Beginner";
                      });
                      // print(_userPullUpsCapacity);
                    },
                    actualCapacity: _userPullUpsCapacity,
                    selectedCapacity: "Beginner",
                    title: "Beginner",
                    description: '0 - 5  Pull-ups',
                  ),

                  /// Add space between buttons
                  const SizedBox(height: 20.0),

                  /// Intermediate button
                  SelectCapacityButton(
                    onPressed: () {
                      setState(() {
                        _userPullUpsCapacity = "Intermediate";
                      });
                      // print(_userPullUpsCapacity);
                    },
                    actualCapacity: _userPullUpsCapacity,
                    selectedCapacity: "Intermediate",
                    title: "Intermediate",
                    description: '6 - 10  Pull-ups',
                  ),

                  /// Add space between buttons
                  const SizedBox(height: 20.0),

                  /// Advanced button
                  SelectCapacityButton(
                    onPressed: () {
                      setState(() {
                        _userPullUpsCapacity = "Advanced";
                      });
                      // print(_userPullUpsCapacity);
                    },
                    actualCapacity: _userPullUpsCapacity,
                    selectedCapacity: "Advanced",
                    title: "Advanced",
                    description: 'More than 10  Pull-ups',
                  ),

                  /// Add space between buttons
                  const SizedBox(height: 20.0),
                ],
              ),
            ),

            /// Bottom of the screen
            /// Next button
            Padding(
              padding: const EdgeInsets.only(
                top: kPadding16,
              ),
              child: NextButton(
                onPressed: () {
                  // When the button is clicked, navigate to the weekly goal screen
                  checkingUserLevel();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WeeklyGoalScreen(
                        userGender: widget.userGender,
                        userBirthDay: widget.userBirthDay,
                        userHeight: widget.userHeight,
                        userWeight: widget.userWeight,
                        userSelectedBodyAreas: widget.userSelectedBodyAreas,
                        userMainGoal: widget.userMainGoal,
                        userLevel: _userLevel,
                      ),
                    ),
                  );
                },
                style: kNextButtonStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
