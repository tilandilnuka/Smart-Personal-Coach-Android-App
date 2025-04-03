import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_personal_coach/generate_workout_plan_exercises/workout_plan_exercises_card_list_tile.dart';
import 'package:smart_personal_coach/constants.dart';

class WorkoutPlanExercisesCard extends StatelessWidget {
  const WorkoutPlanExercisesCard({
    super.key,
    required this.collectionName,
    required this.title,
    required this.loggedInUserEmail,
    required this.workoutPlanExampleExercises,
    required this.motivationalQuote,
  });

  final String collectionName;
  final String title;
  final String? loggedInUserEmail;
  final String workoutPlanExampleExercises;
  final String motivationalQuote;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(loggedInUserEmail)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Text("Loading exercises..."));
        }

        if (!snapshot.hasData) {
          return const Center(child: Text("No data available"));
        }

        // Access the data from the snapshot
        Map<String, dynamic> data =
            snapshot.data!.data() as Map<String, dynamic>;

        List<dynamic> workoutPlanExercises = data[workoutPlanExampleExercises] ?? [];


        double cardHeight() {
          String level = data["level"];
          if (level == "Beginner") {
            return 332.0;
          } else if (level == "Intermediate") {
            return 444.0;
          } else {
            return 556.0;
          }
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: kPadding16),
          child: SizedBox(
            height: cardHeight(),
            child: Card(
              margin: EdgeInsets.zero,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(kRadius16)),
                  side: BorderSide(color: kAppThemeColor)),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: kAppThemeColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(kRadius16),
                          topRight: Radius.circular(kRadius16)),
                    ),
                    width: double.maxFinite,
                    height: 50.0,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: kWhiteThemeColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.only(
                        left: kPadding8,
                        top: kPadding8,
                        right: kPadding8,
                      ),
                      primary: false,
                      itemCount: workoutPlanExercises.length,
                      itemBuilder: (context, index) {
                        String exercise = workoutPlanExercises.elementAt(index);
                        return Padding(
                          // Adding space between two exercises list tiles
                          padding: const EdgeInsets.only(bottom: kPadding8),
                          child: WorkoutPlanExercisesCardListTile(
                            collectionName: collectionName,
                            docName: exercise,
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(kRadius16),
                          bottomRight: Radius.circular(kRadius16)),
                    ),
                    width: double.maxFinite,
                    height: 50.0,
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: kPadding8),
                      child: Text(
                        motivationalQuote,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 10.0,
                          fontWeight: FontWeight.w600,
                          color: kBlackThemeColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
