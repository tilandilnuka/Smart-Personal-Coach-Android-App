import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_personal_coach/constants.dart';
import 'package:smart_personal_coach/generate_workout_plan_exercises/generate_the_workout_plan_exercises.dart';
import 'package:smart_personal_coach/screens/workout_plan_screens/diet_plan_screen.dart';
import 'package:smart_personal_coach/screens/workout_plan_screens/workout_plan_exercises_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Creating an instance of FirebaseAuth
  final _auth = FirebaseAuth.instance;

  // Creating an user variable to store logged in user
  late User loggedInUser;

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

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  /// Finished a day of workout plan
  Future<void> finishedADayOfWorkoutPlan(
      int initialFinishedDaysOfCurrentWorkoutPlan,
      int initialFinishedWorkoutPlans,
      String userLevel,
      String? loggedInUserEmail,
      List<String> focusedBodyAreas) async {
    try {
      String day = DateTime.now().day.toString();
      String month = DateTime.now().month.toString();
      String year = DateTime.now().year.toString();
      String dayMonthYear = "$day-$month-$year";

      int finishedDaysOfCurrentWorkoutPlan =
          initialFinishedDaysOfCurrentWorkoutPlan;
      int finishedWorkoutPlans = initialFinishedWorkoutPlans;

      if (finishedDaysOfCurrentWorkoutPlan < 30) {
        finishedDaysOfCurrentWorkoutPlan++;
      } else {
        finishedDaysOfCurrentWorkoutPlan = 0;
        await generateTheWorkoutPlan(
            userLevel: userLevel,
            loggedInUserEmail: loggedInUserEmail,
            focusedBodyAreas: focusedBodyAreas);
        await FirebaseFirestore.instance
            .collection("users")
            .doc(loggedInUser.email)
            .collection("finished_workout_plans")
            .doc(
                "You have finished your ${finishedWorkoutPlans + 1} workout plan on $dayMonthYear")
            .set({});
        finishedWorkoutPlans++;
        if (!mounted) return;
        // Show snack bar with  message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Congratulations! You have finished your workout plan successfully and now you have a new workout plan.')),
        );
      }

      // Get a reference to the document
      DocumentReference documentRef =
          FirebaseFirestore.instance.collection('users').doc(loggedInUserEmail);

      await documentRef.update({
        'finishedDaysOfCurrentWorkoutPlan': finishedDaysOfCurrentWorkoutPlan,
        'finishedWorkoutPlans': finishedWorkoutPlans,
      });

      print('Document updated successfully.');
    } catch (e) {
      print('Error updating document: $e');
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
      appBar: AppBar(
        title: const Text(
          'HOME',
          style: kAppBarTextStyle,
        ),
        automaticallyImplyLeading: false,
      ),

      /// Body of the screen
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(loggedInUser.email)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Loading workout plan..."));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No data available"));
          }

          // Access the data from the snapshot
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          String userName = data["userName"];
          String userMainGoal = data["mainGoal"];
          String userLevel = data["level"];
          int userWeight = data['weight'];
          int userWeeklyGoal = data["weeklyGoal"];
          int userFinishedDaysOfCurrentWorkoutPlan =
              data["finishedDaysOfCurrentWorkoutPlan"];
          int userFinishedWorkoutPlans = data["finishedWorkoutPlans"];
          List<dynamic> userFocusedBodyAreas = data["focusedBodyAreas"];

          String reps = "";
          String sets = "";

          if (userMainGoal == "Loose Weight") {
            reps = "12-20";
            sets = "2 - 3";
          } else if (userMainGoal == "Build Muscles") {
            reps = "6-12";
            sets = "3-4";
          } else {
            reps = "6-20";
            sets = "2-4";
          }

          /// Percentage of the workout plan progress
          double percentageOfTheWorkoutPlanProgress =
              userFinishedDaysOfCurrentWorkoutPlan / 30;

          return ListView(
            padding: const EdgeInsets.all(kPadding16),
            primary: false,
            children: [
              /// Welcome message
              Text(
                "${greeting()} $userName!",
                style: kLargeBlackTitleTextStyle.copyWith(
                  color: kAppThemeColor,
                  height: 1,
                ),
              ),

              /// Adding space
              const SizedBox(height: 12.0),

              /// Workout Plan
              Card(
                margin: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(kRadius16))),
                child: Padding(
                  padding: const EdgeInsets.all(kPadding8),
                  child: Column(
                    children: [
                      /// Title Workout Plan
                      const Text(
                        "Workout Plan",
                        style: kLargeBlackTitleTextStyle,
                      ),

                      /// Adding space
                      const SizedBox(height: 12.0),

                      /// Current day
                      Text(
                        userFinishedDaysOfCurrentWorkoutPlan < 30
                            ? "Day ${userFinishedDaysOfCurrentWorkoutPlan + 1}"
                            : "All Days Are Completed",
                        style: userFinishedDaysOfCurrentWorkoutPlan < 30
                            ? kLargeBlackTitleTextStyle
                            : kLargeBlackTitleTextStyle.copyWith(
                                color: kGreenThemeColor),
                      ),

                      /// Adding space
                      const SizedBox(height: 12.0),

                      /// Progress
                      const Text(
                        "Progress",
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.w700),
                      ),

                      /// Adding space
                      const SizedBox(height: 8.0),

                      /// Progress of the workout plan
                      CircularPercentIndicator(
                        animation: true,
                        radius: 35.0,
                        lineWidth: 8.0,
                        percent: percentageOfTheWorkoutPlanProgress,
                        center: Text(
                          "${((userFinishedDaysOfCurrentWorkoutPlan * 10) / 3).round()}%",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        progressColor: kGreenThemeColor,
                        animationDuration: 1000,
                        footer: Text(
                            "You have finished $userFinishedDaysOfCurrentWorkoutPlan days out of 30 days of your workout plan",
                            textAlign: TextAlign.center,
                            style: kProfileTitleTextStyle),
                      ),

                      /// Adding space
                      const SizedBox(height: 12.0),

                      /// Instructions
                      const Text(
                        "Instructions",
                        style: TextStyle(
                            fontSize: 22.0, fontWeight: FontWeight.w700),
                      ),

                      /// Adding space
                      const SizedBox(height: 8.0),

                      /// Main Goal
                      const Text(
                        "Main Goal",
                        style: kProfileTitleTextStyle,
                      ),
                      Text(
                        "Your main goal is to $userMainGoal, so aim for $sets sets of $reps reps per exercise.",
                        textAlign: TextAlign.center,
                        style: kSmallGreyColorDescriptionTextStyle.copyWith(
                            color: kBlackThemeColor,
                            fontWeight: FontWeight.w400),
                      ),

                      /// Adding space
                      const SizedBox(height: 8.0),

                      /// Weekly goal
                      const Text(
                        "Weekly Goal",
                        style: kProfileTitleTextStyle,
                      ),
                      Text(
                        "Your weekly goal is to perform all the exercises listed within $userWeeklyGoal days of the week.",
                        textAlign: TextAlign.center,
                        style: kSmallGreyColorDescriptionTextStyle.copyWith(
                            color: kBlackThemeColor,
                            fontWeight: FontWeight.w400),
                      ),

                      /// Adding space
                      const SizedBox(height: 8.0),

                      /// Focused body areas
                      const Text(
                        "Focused Body Areas",
                        style: kProfileTitleTextStyle,
                      ),
                      Text(
                        userFocusedBodyAreas
                            .toString()
                            .split("[")
                            .last
                            .split("]")
                            .first,
                        textAlign: TextAlign.center,
                        style: kSmallGreyColorDescriptionTextStyle.copyWith(
                            color: kBlackThemeColor,
                            fontWeight: FontWeight.w400),
                      ),

                      /// Adding space
                      const SizedBox(height: 8.0),

                      /// Equipments
                      const Text(
                        "Equipments",
                        style: kProfileTitleTextStyle,
                      ),
                      Text(
                        "For optimum results, we recommend using Kettlebells or Dumbbells for weighted exercises.",
                        textAlign: TextAlign.center,
                        style: kSmallGreyColorDescriptionTextStyle.copyWith(
                            color: kBlackThemeColor,
                            fontWeight: FontWeight.w400),
                      ),

                      /// Adding space
                      const SizedBox(height: 8.0),

                      /// Exercises
                      Text(
                        "Exercises - $userLevel Level",
                        style: kProfileTitleTextStyle,
                      ),

                      /// Adding space
                      const SizedBox(height: 8.0),

                      /// Show workout plan exercises button
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WorkoutPlanExercisesScreen(
                                focusedBodyAreas: userFocusedBodyAreas,
                                loggedInUserEmail: loggedInUser.email,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kAppThemeColor),
                        icon: const Icon(
                          Icons.fitness_center_rounded,
                          color: kWhiteThemeColor,
                        ),
                        label: Text(
                          "Show Exercises",
                          style: kSmallGreyColorDescriptionTextStyle.copyWith(
                              color: kWhiteThemeColor),
                        ),
                      ),

                      /// Show diet plan button
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DietPlanScreen(
                                userWeight: userWeight,
                                userMainGoal: userMainGoal,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kAppThemeColor),
                        icon: const Icon(
                          Icons.fastfood_rounded,
                          color: kWhiteThemeColor,
                        ),
                        label: Text(
                          "Show Diet Plan",
                          style: kSmallGreyColorDescriptionTextStyle.copyWith(
                              color: kWhiteThemeColor),
                        ),
                      ),

                      /// Adding space
                      const SizedBox(height: 8.0),

                      /// Finished workout plan button
                      ElevatedButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor:
                                    userFinishedDaysOfCurrentWorkoutPlan < 30
                                        ? kRedThemeColor
                                        : kGreenThemeColor,
                                title: Text(
                                  userFinishedDaysOfCurrentWorkoutPlan < 30
                                      ? "Did you finish the day ${userFinishedDaysOfCurrentWorkoutPlan + 1} of your workout plan?"
                                      : "Congratulations! You have finished"
                                          " your workout plan successfully. Do you want to generate a new workout plan?",
                                  style:
                                      const TextStyle(color: kWhiteThemeColor),
                                ),
                                icon: const Icon(
                                  Icons.warning_rounded,
                                  color: kWhiteThemeColor,
                                ),
                                actions: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: kWhiteThemeColor),
                                    onPressed: () {
                                      finishedADayOfWorkoutPlan(
                                        userFinishedDaysOfCurrentWorkoutPlan,
                                        userFinishedWorkoutPlans,
                                        userLevel,
                                        loggedInUser.email,
                                        userFocusedBodyAreas
                                            .map(
                                                (element) => element.toString())
                                            .toList(),
                                      );
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Yes",
                                      style:
                                          TextStyle(color: kGreenThemeColor),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: kWhiteThemeColor),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "No",
                                      style:
                                          TextStyle(color: kBMIRedThemeColor),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kGreenThemeColor,
                            fixedSize: const Size.fromWidth(double.maxFinite)),
                        icon: const Icon(
                          Icons.done_all_rounded,
                          color: kWhiteThemeColor,
                        ),
                        label: Text(
                          userFinishedDaysOfCurrentWorkoutPlan < 30
                              ? "Finished Day ${userFinishedDaysOfCurrentWorkoutPlan + 1}"
                              : "Completed all days of the current workout plan. Generate a new one!",
                          textAlign: TextAlign.center,
                          style: kSmallGreyColorDescriptionTextStyle.copyWith(
                              color: kWhiteThemeColor),
                        ),
                      ),

                      /// Note
                      const Text(
                        'Note:- Once you complete your daily exercises and follow the diet plan,'
                        ' make sure to click the "Finished Day" button to save your progress.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 8.8),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
