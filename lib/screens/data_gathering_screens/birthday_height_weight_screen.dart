import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_personal_coach/components/app_bar_title.dart';
import 'package:smart_personal_coach/components/reusable_card_with_datepicker.dart';
import 'package:smart_personal_coach/constants.dart';
import 'package:smart_personal_coach/components/next_button.dart';
import 'package:smart_personal_coach/components/reusable_card_with_slider.dart';
import 'package:smart_personal_coach/components/title_and_description_holder.dart';
import 'package:smart_personal_coach/screens/data_gathering_screens/body_areas_selection_screen.dart';

/// Screen to get the user age, height, weight
class BirthDayHeightWeightScreen extends StatefulWidget {
  const BirthDayHeightWeightScreen({super.key, required this.userGender});

  final String userGender;

  @override
  State<BirthDayHeightWeightScreen> createState() =>
      _BirthDayHeightWeightScreenState();
}

class _BirthDayHeightWeightScreenState
    extends State<BirthDayHeightWeightScreen> {
  // Creating an instance of FirebaseAuth
  final _auth = FirebaseAuth.instance;

  // Creating an user variable to store logged in user
  late User loggedInUser;

  // Declare variables to store user birth day, height and weight and assign default values for them.
  DateTime _userBirthDay = DateTime.now();
  int _userHeight = 120;
  int _userWeight = 60;

  /// Getting user birthday
  Future<void> _selectUserBirthDay(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _userBirthDay,
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _userBirthDay) {
      setState(() {
        _userBirthDay = picked;
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
          screenId: 2,
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
                title: 'Let us known you better',
                description:
                    'Let us know you better to help boost your workout results',
              ),
            ),

            /// Middle of the screen
            /// Sliders holder (Birthday, Height, Weight)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(
                  top: kPadding16,
                  bottom: kPadding16,
                ),
                primary: false,
                children: [
                  /// Get the user's birth day
                  ReusableCardWithDatePicker(
                    text1: "Birth Day",
                    text2: "${_userBirthDay.toLocal()}".split(' ')[0],
                    onPressed: () {
                      _selectUserBirthDay(context);
                    },
                  ),

                  /// Add space between sliders
                  const SizedBox(height: 20.0),

                  /// Get the user's height
                  ReusableCardWithSlider(
                    text1: 'Height',
                    text2: _userHeight.toString(),
                    text3: 'cm',
                    value: _userHeight.toDouble(),
                    min: 60.0,
                    max: 280.0,
                    onChanged: (double newHeight) {
                      setState(() {
                        _userHeight = newHeight.round();
                      });
                    },
                  ),

                  /// Add space between sliders
                  const SizedBox(height: 20.0),

                  /// Get the user's weight
                  ReusableCardWithSlider(
                    text1: 'Weight',
                    text2: _userWeight.toString(),
                    text3: 'kg',
                    value: _userWeight.toDouble(),
                    min: 10.0,
                    max: 300.0,
                    onChanged: (double newWeight) {
                      setState(() {
                        _userWeight = newWeight.round();
                      });
                    },
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
                  // When the button is clicked, navigate to the body areas selection screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BodyAreasSelectionScreen(
                        userGender: widget.userGender,
                        userBirthDay: _userBirthDay,
                        userHeight: _userHeight,
                        userWeight: _userWeight,
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
