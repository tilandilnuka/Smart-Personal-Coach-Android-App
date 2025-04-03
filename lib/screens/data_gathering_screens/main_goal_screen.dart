import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_personal_coach/components/app_bar_title.dart';
import 'package:smart_personal_coach/constants.dart';
import 'package:smart_personal_coach/components/next_button.dart';
import 'package:smart_personal_coach/components/title_and_description_holder.dart';
import 'package:smart_personal_coach/screens/data_gathering_screens/checking_pushups_capacity.dart';

/// Screen to get the user's main goal
class MainGoalScreen extends StatefulWidget {
  const MainGoalScreen(
      {super.key,
      required this.userGender,
      required this.userBirthDay,
      required this.userHeight,
      required this.userWeight,
      required this.userSelectedBodyAreas});

  final String userGender;
  final DateTime userBirthDay;
  final int userHeight;
  final int userWeight;
  final List<String> userSelectedBodyAreas;

  @override
  State<MainGoalScreen> createState() => _MainGoalScreenState();
}

class _MainGoalScreenState extends State<MainGoalScreen> {
  // Creating an instance of FirebaseAuth
  final _auth = FirebaseAuth.instance;

  // Creating an user variable to store logged in user
  late User loggedInUser;

  // Declare a variable to store the user's main goal
  String _userMainGoal = "Lose Weight";

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
          screenId: 4,
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

        /// The main column of the screen
        child: Column(
          children: [
            /// Top of the screen
            /// The title and the description
            const Padding(
              padding: EdgeInsets.only(
                bottom: kPadding16,
              ),
              child: InitialScreensTitleAndDescriptionHolder(
                title: 'What are your main goals?',
                description: 'Why do you use this application?',
              ),
            ),

            /// Middle of the screen
            /// Buttons holder
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(
                  top: kPadding16,
                  bottom: kPadding16,
                ),
                primary: false,
                children: [
                  /// Lose weight button
                  SelectMainGoalButton(
                    onPressed: () {
                      setState(() {
                        // If the button is clicked, the user's main goal should be to lose weight.
                        _userMainGoal = "Lose Weight";
                      });
                      // print(_userMainGoal);
                    },
                    userMainGoal: _userMainGoal,
                    selectedMainGoal: "Lose Weight",
                    buttonLabel: "Lose Weight",
                  ),

                  /// Add space between buttons
                  const SizedBox(height: 20.0),

                  /// Build muscles button
                  SelectMainGoalButton(
                    onPressed: () {
                      setState(() {
                        // If the button is clicked, the user's main goal should be to build muscles.
                        _userMainGoal = "Build Muscles";
                      });
                      // print(_userMainGoal);
                    },
                    userMainGoal: _userMainGoal,
                    selectedMainGoal: "Build Muscles",
                    buttonLabel: "Build Muscles",
                  ),

                  /// Add space between buttons
                  const SizedBox(height: 20.0),

                  /// Keep fit button
                  SelectMainGoalButton(
                    onPressed: () {
                      setState(() {
                        // If the button is clicked, the user's main goal should be to keep fit.
                        _userMainGoal = "Keep Fit";
                      });
                      // print(_userMainGoal);
                    },
                    userMainGoal: _userMainGoal,
                    selectedMainGoal: "Keep Fit",
                    buttonLabel: "Keep Fit",
                  ),
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
                  // When the button is clicked, navigate to the checking push ups capacity screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CheckingPushUpsCapacity(
                        userGender: widget.userGender,
                        userBirthDay: widget.userBirthDay,
                        userHeight: widget.userHeight,
                        userWeight: widget.userWeight,
                        userSelectedBodyAreas: widget.userSelectedBodyAreas,
                        userMainGoal: _userMainGoal,
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

/// Create a button to select the user's main goal
class SelectMainGoalButton extends StatelessWidget {
  const SelectMainGoalButton({
    super.key,
    required this.userMainGoal,
    required this.selectedMainGoal,
    this.onPressed,
    required this.buttonLabel,
  });

  final String userMainGoal;
  final String selectedMainGoal;
  final void Function()? onPressed;
  final String buttonLabel;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: kSelectCapacityButtonStyle.copyWith(
        // If the selected main goal is equal to the user's main goal, the button color should be blue, otherwise white
        backgroundColor: selectedMainGoal == userMainGoal
            ? const MaterialStatePropertyAll(kAppThemeColor)
            : const MaterialStatePropertyAll(kWhiteThemeColor),
      ),
      child: Text(
        buttonLabel,
        style: kSelectCapacityButtonTextStyle.copyWith(
          // If the selected main goal is equal to the user's main goal, the button text color should be white, otherwise blue
          color: selectedMainGoal == userMainGoal
              ? kWhiteThemeColor
              : kAppThemeColor,
        ),
      ),
    );
  }
}
