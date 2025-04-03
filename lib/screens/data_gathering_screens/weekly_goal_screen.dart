import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:smart_personal_coach/generate_workout_plan_exercises/generate_the_workout_plan_exercises.dart';
import 'package:smart_personal_coach/components/app_bar_title.dart';
import 'package:smart_personal_coach/constants.dart';
import 'package:smart_personal_coach/components/title_and_description_holder.dart';
import 'package:smart_personal_coach/screens/initial_screens/bottom_navigationbar_screen.dart';

/// Screen to get data on how many days per week the user can dedicate to one workout plan
class WeeklyGoalScreen extends StatefulWidget {
  const WeeklyGoalScreen(
      {super.key,
      required this.userGender,
      required this.userBirthDay,
      required this.userHeight,
      required this.userWeight,
      required this.userSelectedBodyAreas,
      required this.userMainGoal,
      required this.userLevel});

  final String userGender;
  final DateTime userBirthDay;
  final int userHeight;
  final int userWeight;
  final List<String> userSelectedBodyAreas;
  final String userMainGoal;
  final String userLevel;

  @override
  State<WeeklyGoalScreen> createState() => _WeeklyGoalScreenState();
}

class _WeeklyGoalScreenState extends State<WeeklyGoalScreen> {
  // Creating an instances of FirebaseAuth and FirebaseFirestore
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Creating an user variable to store logged in user
  late User loggedInUser;

  // Default profile picture url
  final String defaultProfilePicture =
      "https://firebasestorage.googleapis.com/v0/b/smartpersonalcoach.appspot.com/o/profile_pictures%2Ftheme-image.jpg?alt=media&token=777d29fb-0bcc-4bbb-bddd-b65d6c1f4eea";

  // Declare an int variable to store how many days the user can dedicate to the workout plan
  int _userSelectedDays = 1;

  // To show or hide spinner
  bool showSpinner = false;

  /// Adding data to the database (User weekly goal)
  Future<void> _setData() async {
    setState(() {
      //Once click on the register button, showSpinner is equal to true and
      //shows the modal progress indicator.
      showSpinner = true;
    });
    try {
      String year = DateTime.now().year.toString();
      String month = DateTime.now().month.toString();
      String yearMonth = "$year.$month";

      await _firestore.collection("users").doc(loggedInUser.email).set(
        {
          'gender': widget.userGender,
          'userName': "user",
          'email': loggedInUser.email,
          'profilePicture': defaultProfilePicture,
          'birthDay': widget.userBirthDay,
          'height': widget.userHeight,
          'weight': widget.userWeight,
          'focusedBodyAreas': widget.userSelectedBodyAreas,
          'mainGoal': widget.userMainGoal,
          'level': widget.userLevel,
          'weeklyGoal': _userSelectedDays,
          'finishedDaysOfCurrentWorkoutPlan': 0,
          'finishedWorkoutPlans': 0,
        },
      );

      await _firestore
          .collection("users")
          .doc(loggedInUser.email)
          .collection("height_chart_data")
          .doc(yearMonth)
          .set({
        'date': yearMonth,
        'height': widget.userHeight,
      });

      await _firestore
          .collection("users")
          .doc(loggedInUser.email)
          .collection("weight_chart_data")
          .doc(yearMonth)
          .set({
        'date': yearMonth,
        'weight': widget.userWeight,
      });

      /// Generate the workout plan
      await generateTheWorkoutPlan(
        userLevel: widget.userLevel,
        loggedInUserEmail: loggedInUser.email,
        focusedBodyAreas: widget.userSelectedBodyAreas,
      );

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomNavigationBarScreenScreen(),
        ),
      );
    } catch (e) {
      // Show snack bar with error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong!')),
      );
    }
    //After all, showSpinner is equal to false and disappears modal progress indicator.
    setState(() {
      showSpinner = false;
    });
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
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      progressIndicator: const CircularProgressIndicator(
        color: kAppThemeColor,
      ),
      child: Scaffold(
        /// App Bar
        appBar: AppBar(
          backgroundColor: kWhiteThemeColor,
          scrolledUnderElevation: 0,
          elevation: 0,
          shadowColor: kWhiteThemeColor,
          centerTitle: true,

          /// Show which screen the user is on
          title: const AppBarTitle(
            screenId: 7,
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
                  title: 'Set your weekly goal',
                  description:
                      'How many days per week can you dedicate to one workout plan?',
                ),
              ),

              /// Middle of the screen
              /// Week days buttons holder
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.only(
                    top: kPadding16,
                    bottom: kPadding16,
                  ),
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  primary: false,
                  children: [
                    /// 1 day a week button
                    DayButton(
                      onPressed: () {
                        setState(() {
                          _userSelectedDays = 1;
                        });
                        // print(_userSelectedDays);
                      },
                      userSelectedDays: _userSelectedDays,
                      selectedDays: 1,
                      title: '1 Day',
                      description: 'Dedicate 1 day a week',
                    ),

                    /// 2 days a week button
                    DayButton(
                      onPressed: () {
                        setState(() {
                          _userSelectedDays = 2;
                        });
                        // print(_userSelectedDays);
                      },
                      userSelectedDays: _userSelectedDays,
                      selectedDays: 2,
                      title: '2 Days',
                      description: 'Dedicate 2 days a week',
                    ),

                    /// 3 days a week button
                    DayButton(
                      onPressed: () {
                        setState(() {
                          _userSelectedDays = 3;
                        });
                        // print(_userSelectedDays);
                      },
                      userSelectedDays: _userSelectedDays,
                      selectedDays: 3,
                      title: '3 Days',
                      description: 'Dedicate 3 days a week',
                    ),

                    /// 4 days a week button
                    DayButton(
                      onPressed: () {
                        setState(() {
                          _userSelectedDays = 4;
                        });
                        // print(_userSelectedDays);
                      },
                      userSelectedDays: _userSelectedDays,
                      selectedDays: 4,
                      title: '4 Days',
                      description: 'Dedicate 4 days a week',
                    ),

                    /// 5 days a week button
                    DayButton(
                      onPressed: () {
                        setState(() {
                          _userSelectedDays = 5;
                        });
                        // print(_userSelectedDays);
                      },
                      userSelectedDays: _userSelectedDays,
                      selectedDays: 5,
                      title: '5 Days',
                      description: 'Dedicate 5 days a week',
                    ),

                    /// 6 days a week button
                    DayButton(
                      onPressed: () {
                        setState(() {
                          _userSelectedDays = 6;
                        });
                        // print(_userSelectedDays);
                      },
                      userSelectedDays: _userSelectedDays,
                      selectedDays: 6,
                      title: '6 Days',
                      description: 'Dedicate 6 days a week',
                    ),

                    /// 7 days a week button
                    DayButton(
                      onPressed: () {
                        setState(() {
                          _userSelectedDays = 7;
                        });
                        // print(_userSelectedDays);
                      },
                      userSelectedDays: _userSelectedDays,
                      selectedDays: 7,
                      title: '7 Days',
                      description: 'Dedicate 7 days a week',
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
                child: ElevatedButton(
                  onPressed: () {
                    // Calling the setData method to add data to the database
                    _setData();
                  },
                  style: kNextButtonStyle,
                  child: const Text(
                    "Start",
                    style: kNextButtonTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Button to select how many days the user can dedicate to the workout plan
class DayButton extends StatelessWidget {
  const DayButton({
    super.key,
    required this.userSelectedDays,
    required this.selectedDays,
    required this.onPressed,
    required this.title,
    required this.description,
  });

  final int userSelectedDays;
  final int selectedDays;
  final String title;
  final String description;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: kDayButtonStyle.copyWith(
        backgroundColor: userSelectedDays == selectedDays
            ? const MaterialStatePropertyAll(kAppThemeColor)
            : const MaterialStatePropertyAll(kWhiteThemeColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: kDayButtonTextStyle.copyWith(
              color: userSelectedDays == selectedDays
                  ? kWhiteThemeColor
                  : kAppThemeColor,
            ),
          ),
          Text(
            description,
            style: kSmallGreyColorDescriptionTextStyle.copyWith(
              color: userSelectedDays == selectedDays
                  ? kGreyThemeColor02
                  : kGreyThemeColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
