import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_personal_coach/components/app_bar_title.dart';
import 'package:smart_personal_coach/constants.dart';
import 'package:smart_personal_coach/components/next_button.dart';
import 'package:smart_personal_coach/components/title_and_description_holder.dart';
import 'package:smart_personal_coach/screens/data_gathering_screens/main_goal_screen.dart';

/// Getting the user's preferred body areas to focus on
class BodyAreasSelectionScreen extends StatefulWidget {
  const BodyAreasSelectionScreen(
      {super.key,
      required this.userBirthDay,
      required this.userHeight,
      required this.userWeight,
      required this.userGender});

  final String userGender;
  final DateTime userBirthDay;
  final int userHeight;
  final int userWeight;

  @override
  State<BodyAreasSelectionScreen> createState() =>
      _BodyAreasSelectionScreenState();
}

class _BodyAreasSelectionScreenState extends State<BodyAreasSelectionScreen> {
  // Creating an instance of FirebaseAuth
  final _auth = FirebaseAuth.instance;

  // Creating an user variable to store logged in user
  late User loggedInUser;

  // Declare a list to store user selected body areas.
  final List<String> _userSelectedBodyAreas = [];

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
          screenId: 3,
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
        // The main column
        child: Column(
          children: [
            /// Top of the screen
            /// The title and the description
            const Padding(
              padding: EdgeInsets.only(
                bottom: kPadding16,
              ),
              child: InitialScreensTitleAndDescriptionHolder(
                title: 'Please select your focus area/areas',
                description: '',
              ),
            ),

            /// Middle of the screen
            /// Body area selection container
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(
                  top: kPadding16,
                  bottom: kPadding16,
                ),
                primary: false,
                children: [
                  /// Selection container
                  SizedBox(
                    // Add a fixed height to the container
                    height: 496.0,

                    /// Button bar and the body image holder
                    child: Row(
                      // Center button bar and image inside the holder
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ///  The Button bar
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              /// Select the full body button
                              SelectBodyAreaButton(
                                array: _userSelectedBodyAreas,
                                selectedBodyArea: "Full Body",
                                onPressed: () {
                                  setState(() {
                                    // Check whether bodyAreas array length >= 5
                                    if (_userSelectedBodyAreas.length >= 5) {
                                      // If it is true, the bodyAreas array should be empty when this button is clicked
                                      _userSelectedBodyAreas.clear();
                                    } else {
                                      // If it false, these body areas should be added to the array
                                      _userSelectedBodyAreas.clear();
                                      _userSelectedBodyAreas.add("Arms");
                                      _userSelectedBodyAreas.add("Back");
                                      _userSelectedBodyAreas.add("Chest");
                                      _userSelectedBodyAreas.add("Abs");
                                      _userSelectedBodyAreas.add("Legs");
                                    }
                                    // print(_userSelectedBodyAreas);
                                  });
                                },
                                buttonLabel: "Full Body",
                              ),

                              /// Select arms button
                              SelectBodyAreaButton(
                                onPressed: () {
                                  setState(() {
                                    // Check whether bodyAreas array contains arms
                                    if (_userSelectedBodyAreas
                                        .contains("Arms")) {
                                      // If it is true, remove arms from the array when this button is clicked
                                      _userSelectedBodyAreas.remove("Arms");
                                    } else {
                                      // If it false, add arms to the array when this button is clicked
                                      _userSelectedBodyAreas.add("Arms");
                                    }
                                    // print(_userSelectedBodyAreas);
                                  });
                                },
                                array: _userSelectedBodyAreas,
                                buttonLabel: "Arms",
                                selectedBodyArea: "Arms",
                              ),

                              /// Select back button
                              SelectBodyAreaButton(
                                onPressed: () {
                                  setState(() {
                                    // Check whether bodyAreas array contains back
                                    if (_userSelectedBodyAreas
                                        .contains("Back")) {
                                      // If it is true, remove back from the array when this button is clicked
                                      _userSelectedBodyAreas.remove("Back");
                                    } else {
                                      // If it false, add arms to the array when this button is clicked
                                      _userSelectedBodyAreas.add("Back");
                                    }
                                    // print(_userSelectedBodyAreas);
                                  });
                                },
                                array: _userSelectedBodyAreas,
                                buttonLabel: "Back",
                                selectedBodyArea: "Back",
                              ),

                              /// Select chest button
                              SelectBodyAreaButton(
                                onPressed: () {
                                  setState(() {
                                    // Check whether bodyAreas array contains chest
                                    if (_userSelectedBodyAreas
                                        .contains("Chest")) {
                                      // If it is true, remove chest from the array when this button is clicked
                                      _userSelectedBodyAreas.remove("Chest");
                                    } else {
                                      // If it false, add arms to the array when this button is clicked
                                      _userSelectedBodyAreas.add("Chest");
                                    }
                                    // print(_userSelectedBodyAreas);
                                  });
                                },
                                array: _userSelectedBodyAreas,
                                buttonLabel: "Chest",
                                selectedBodyArea: "Chest",
                              ),

                              /// Select abs button
                              SelectBodyAreaButton(
                                onPressed: () {
                                  setState(() {
                                    // Check whether bodyAreas array contains abs
                                    if (_userSelectedBodyAreas
                                        .contains("Abs")) {
                                      // If it is true, remove abs from the array when this button is clicked
                                      _userSelectedBodyAreas.remove("Abs");
                                    } else {
                                      // If it false, add arms to the array when this button is clicked
                                      _userSelectedBodyAreas.add("Abs");
                                    }
                                    // print(_userSelectedBodyAreas);
                                  });
                                },
                                array: _userSelectedBodyAreas,
                                buttonLabel: "Abs",
                                selectedBodyArea: "Abs",
                              ),

                              /// Select legs button
                              SelectBodyAreaButton(
                                onPressed: () {
                                  setState(() {
                                    // Check whether bodyAreas array contains legs
                                    if (_userSelectedBodyAreas
                                        .contains("Legs")) {
                                      // If it is true, remove legs from array when this button is clicked
                                      _userSelectedBodyAreas.remove("Legs");
                                    } else {
                                      // If it false, add legs to the array when this button is clicked
                                      _userSelectedBodyAreas.add("Legs");
                                    }
                                    // print(_userSelectedBodyAreas);
                                  });
                                },
                                array: _userSelectedBodyAreas,
                                buttonLabel: "Legs",
                                selectedBodyArea: "Legs",
                              ),
                            ],
                          ),
                        ),

                        /// Full body image
                        Image.asset(
                          'images/full-body-image.png',
                          height: 496, // Fixed height to the image
                          width: 243, // Fixed width to the image
                        ),
                      ],
                    ),
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
                // If the bodyAreas array is empty, this button should be disabled
                onPressed: _userSelectedBodyAreas.isEmpty
                    ? null
                    : () {
                        // When the button is clicked, navigate to the main goal screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainGoalScreen(
                              userGender: widget.userGender,
                              userBirthDay: widget.userBirthDay,
                              userHeight: widget.userHeight,
                              userWeight: widget.userWeight,
                              userSelectedBodyAreas: _userSelectedBodyAreas,
                            ),
                          ),
                        );
                      },
                style: kNextButtonStyle.copyWith(
                    // If the bodyAreas array is empty, the background color of this button should be grey
                    backgroundColor: MaterialStatePropertyAll(
                        _userSelectedBodyAreas.isEmpty
                            ? kGreyThemeColor02
                            : kAppThemeColor)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Button to select body areas
class SelectBodyAreaButton extends StatelessWidget {
  const SelectBodyAreaButton({
    super.key,
    required this.array,
    required this.selectedBodyArea,
    required this.onPressed,
    required this.buttonLabel,
  });

  final List<String> array;
  final String selectedBodyArea;
  final String buttonLabel;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: kSelectBodyAreaButtonStyle.copyWith(
        backgroundColor: array.contains(selectedBodyArea) || array.length == 5
            ? const MaterialStatePropertyAll(kAppThemeColor)
            : const MaterialStatePropertyAll(kWhiteThemeColor),
      ),
      child: Text(
        buttonLabel,
        style: kSelectBodyAreaButtonTextStyle.copyWith(
          color: array.contains(selectedBodyArea) || array.length == 5
              ? kWhiteThemeColor
              : kAppThemeColor,
        ),
      ),
    );
  }
}
