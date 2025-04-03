import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Body areas
String abs = "Abs";
String arms = "Arms";
String back = "Back";
String chest = "Chest";
String legs = "Legs";

/// Names of exercises collections
String absExercisesCollection = "abs_exercises";
String armsExercisesCollection = "arms_exercises";
String backExercisesCollection = "back_exercises";
String chestExercisesCollection = "chest_exercises";
String legsExercisesCollection = "legs_exercises";

/// Types of exercises
String absExercises = "workoutPlanAbsExercises";
String armsExercises = "workoutPlanArmsExercises";
String backExercises = "workoutPlanBackExercises";
String chestExercises = "workoutPlanChestExercises";
String legsExercises = "workoutPlanLegsExercises";

/// The Difficulty of the exercise
String easy = "Easy";
String moderate = "Moderate";
String challenging = "Challenging";

/// Field name
String difficulty = "difficulty";

/// User levels
String beginner = "Beginner";
String intermediate = "Intermediate";
String advanced = "Advanced";

/// Select exercises for Beginners
Future<void> selectExercisesForBeginners({
  required String nameOfTheExercisesCollection,
  required String? loggedInUserEmail,
  required String typeOfExercises}) async {
  final firestore = FirebaseFirestore.instance;
  final collection = firestore.collection(nameOfTheExercisesCollection);
  final usersCollection = firestore.collection("users");

  // List to store selected exercises
  List<String> selectedExercisesList = [];

  try {
    QuerySnapshot querySnapshot = await collection.get();
    // List to store all the exercises in the collection
    List<DocumentSnapshot> allExercises = querySnapshot.docs;

    // If the total of all exercises is greater than or equal to 2, do the following task
    if (allExercises.length >= 2) {
      // Shuffle the all exercises list to get a random order
      allExercises.shuffle();

      // Grab two random exercises from the All Exercises list and add them to the Selected Exercises list
      for (DocumentSnapshot randomExercise in allExercises) {
        // Check if the random exercise meets the condition
        if (randomExercise[difficulty] == easy) {
          if (!selectedExercisesList.contains(randomExercise.id)) {
            // Add the random exercise to the Selected Exercises list
            selectedExercisesList.add(randomExercise.id);
          }
          // If the Selected Exercises length is 2, stop the loop
          if (selectedExercisesList.length == 2) {
            break;
          }
        }
      }

      // Add the selected exercises list to the workout plan
      await usersCollection.doc(loggedInUserEmail).set(
        {
          typeOfExercises: selectedExercisesList,
        },
        SetOptions(merge: true),
      );
    } else {
      // When there are less than two exercises in the collection, show the error message
      print('There are less than two documents in the collection.');
    }
  } catch (e) {
    print(e);
  }
}

/// Select exercises for Intermediate
Future<void> selectExercisesForIntermediate(
    {required String nameOfTheExercisesCollection,
    required String? loggedInUserEmail,
    required String typeOfExercises}) async {
  final firestore = FirebaseFirestore.instance;
  final collection = firestore.collection(nameOfTheExercisesCollection);
  final usersCollection = firestore.collection("users");

  // List to store selected exercises
  List<String> selectedExercisesList = [];

  try {
    QuerySnapshot querySnapshot = await collection.get();
    // List to store all the exercises in the collection
    List<DocumentSnapshot> allExercises = querySnapshot.docs;

    // If the total of all exercises is greater than or equal to 3, do the following task
    if (allExercises.length >= 3) {
      // Shuffle the all exercises list to get a random order
      allExercises.shuffle();

      // Grab two random exercises from the All Exercises list and add them to the Selected Exercises list
      for (DocumentSnapshot randomExercise in allExercises) {
        // Check if the random exercise meets the condition
        if (randomExercise[difficulty] == easy ||
            randomExercise[difficulty] == moderate) {
          if (!selectedExercisesList.contains(randomExercise.id)) {
            // Add the random exercise to the Selected Exercises list
            selectedExercisesList.add(randomExercise.id);
          }
          // If the Selected Exercises length is 3, stop the loop
          if (selectedExercisesList.length == 3) {
            break;
          }
        }
      }

      // Add the selected exercises list to the workout plan
      await usersCollection.doc(loggedInUserEmail).set(
        {
          typeOfExercises: selectedExercisesList,
        },
        SetOptions(merge: true),
      );
    } else {
      // When there are less than two exercises in the collection, show the error message
      print('There are less than two documents in the collection.');
    }
  } catch (e) {
    print(e);
  }
}

/// Select exercises for Advanced
Future<void> selectExercisesForAdvanced(
    {required String nameOfTheExercisesCollection,
    required String? loggedInUserEmail,
    required String typeOfExercises}) async {
  final firestore = FirebaseFirestore.instance;
  final collection = firestore.collection(nameOfTheExercisesCollection);
  final usersCollection = firestore.collection("users");

  // List to store selected exercises
  List<String> selectedExercisesList = [];

  try {
    QuerySnapshot querySnapshot = await collection.get();
    // List to store all the exercises in the collection
    List<DocumentSnapshot> allExercises = querySnapshot.docs;

    // If the total of all exercises is greater than or equal to 4, do the following task
    if (allExercises.length >= 4) {
      // Shuffle the all exercises list to get a random order
      allExercises.shuffle();

      // Grab two random exercises from the All Exercises list and add them to the Selected Exercises list
      for (DocumentSnapshot randomExercise in allExercises) {
        // Check if the random exercise meets the condition
        if (randomExercise[difficulty] == easy ||
            randomExercise[difficulty] == moderate ||
            randomExercise[difficulty] == challenging) {
          if (!selectedExercisesList.contains(randomExercise.id)) {
            // Add the random exercise to the Selected Exercises list
            selectedExercisesList.add(randomExercise.id);
          }
          // If the Selected Exercises length is 4, stop the loop
          if (selectedExercisesList.length == 4) {
            break;
          }
        }
      }

      // Add the selected exercises list to the workout plan
      await usersCollection.doc(loggedInUserEmail).set(
        {
          typeOfExercises: selectedExercisesList,
        },
        SetOptions(merge: true),
      );
    } else {
      // When there are less than two exercises in the collection, show the error message
      print('There are less than two documents in the collection.');
    }
  } catch (e) {
    print(e);
  }
}

/// Generate a workout plan for a Beginner user
Future<void> generateBeginnerWorkoutPlan(
    {required String? loggedInUserEmail,
    required List<String> focusedBodyAreas}) async {
  // If the user focuses on abs, he/she will get abs exercises.
  if (focusedBodyAreas.contains(abs)) {
    selectExercisesForBeginners(
      loggedInUserEmail: loggedInUserEmail,
      nameOfTheExercisesCollection: absExercisesCollection,
      typeOfExercises: absExercises,
    );
  }

  // If the user focuses on arms, he/she will get arms exercises.
  if (focusedBodyAreas.contains(arms)) {
    selectExercisesForBeginners(
      loggedInUserEmail: loggedInUserEmail,
      nameOfTheExercisesCollection: armsExercisesCollection,
      typeOfExercises: armsExercises,
    );
  }

  // If the user focuses on back, he/she will get back exercises.
  if (focusedBodyAreas.contains(back)) {
    selectExercisesForBeginners(
      loggedInUserEmail: loggedInUserEmail,
      nameOfTheExercisesCollection: backExercisesCollection,
      typeOfExercises: backExercises,
    );
  }

  // If the user focuses on chest, he/she will get chest exercises.
  if (focusedBodyAreas.contains(chest)) {
    selectExercisesForBeginners(
      loggedInUserEmail: loggedInUserEmail,
      nameOfTheExercisesCollection: chestExercisesCollection,
      typeOfExercises: chestExercises,
    );
  }

  // If the user focuses on legs, he/she will get legs exercises.
  if (focusedBodyAreas.contains(legs)) {
    selectExercisesForBeginners(
      loggedInUserEmail: loggedInUserEmail,
      nameOfTheExercisesCollection: legsExercisesCollection,
      typeOfExercises: legsExercises,
    );
  }
}

/// Generate a workout plan for an Intermediate user
Future<void> generateIntermediateWorkoutPlan(
    {required String? loggedInUserEmail,
    required List<String> focusedBodyAreas}) async {
  // If the user focuses on abs, he/she will get abs exercises.
  if (focusedBodyAreas.contains(abs)) {
    selectExercisesForIntermediate(
      loggedInUserEmail: loggedInUserEmail,
      nameOfTheExercisesCollection: absExercisesCollection,
      typeOfExercises: absExercises,
    );
  }

  // If the user focuses on arms, he/she will get arms exercises.
  if (focusedBodyAreas.contains(arms)) {
    selectExercisesForIntermediate(
      loggedInUserEmail: loggedInUserEmail,
      nameOfTheExercisesCollection: armsExercisesCollection,
      typeOfExercises: armsExercises,
    );
  }

  // If the user focuses on back, he/she will get back exercises.
  if (focusedBodyAreas.contains(back)) {
    selectExercisesForIntermediate(
      loggedInUserEmail: loggedInUserEmail,
      nameOfTheExercisesCollection: backExercisesCollection,
      typeOfExercises: backExercises,
    );
  }

  // If the user focuses on chest, he/she will get chest exercises.
  if (focusedBodyAreas.contains(chest)) {
    selectExercisesForIntermediate(
      loggedInUserEmail: loggedInUserEmail,
      nameOfTheExercisesCollection: chestExercisesCollection,
      typeOfExercises: chestExercises,
    );
  }

  // If the user focuses on legs, he/she will get legs exercises.
  if (focusedBodyAreas.contains(legs)) {
    selectExercisesForIntermediate(
      loggedInUserEmail: loggedInUserEmail,
      nameOfTheExercisesCollection: legsExercisesCollection,
      typeOfExercises: legsExercises,
    );
  }
}

/// Generate a workout plan for an Advanced user
Future<void> generateAdvancedWorkoutPlan(
    {required String? loggedInUserEmail,
    required List<String> focusedBodyAreas}) async {
  // If the user focuses on abs, he/she will get abs exercises.
  if (focusedBodyAreas.contains(abs)) {
    selectExercisesForAdvanced(
      loggedInUserEmail: loggedInUserEmail,
      nameOfTheExercisesCollection: absExercisesCollection,
      typeOfExercises: absExercises,
    );
  }

  // If the user focuses on arms, he/she will get arms exercises.
  if (focusedBodyAreas.contains(arms)) {
    selectExercisesForAdvanced(
      loggedInUserEmail: loggedInUserEmail,
      nameOfTheExercisesCollection: armsExercisesCollection,
      typeOfExercises: armsExercises,
    );
  }

  // If the user focuses on back, he/she will get back exercises.
  if (focusedBodyAreas.contains(back)) {
    selectExercisesForAdvanced(
      loggedInUserEmail: loggedInUserEmail,
      nameOfTheExercisesCollection: backExercisesCollection,
      typeOfExercises: backExercises,
    );
  }

  // If the user focuses on chest, he/she will get chest exercises.
  if (focusedBodyAreas.contains(chest)) {
    selectExercisesForAdvanced(
      loggedInUserEmail: loggedInUserEmail,
      nameOfTheExercisesCollection: chestExercisesCollection,
      typeOfExercises: chestExercises,
    );
  }

  // If the user focuses on legs, he/she will get legs exercises.
  if (focusedBodyAreas.contains(legs)) {
    selectExercisesForAdvanced(
      loggedInUserEmail: loggedInUserEmail,
      nameOfTheExercisesCollection: legsExercisesCollection,
      typeOfExercises: legsExercises,
    );
  }
}

/// Delete exercises that the user does not care about
Future<void> deleteExercisesFromWorkoutPlan(
    {required String? loggedInUserEmail,
    required String typeOfExercises}) async {
  try {
    // Get reference to the document
    DocumentReference docRef =
        FirebaseFirestore.instance.collection("users").doc(loggedInUserEmail);

    // Delete exercises from the workout plan
    await docRef.update({
      typeOfExercises: FieldValue.delete(),
    });

    print("$typeOfExercises deleted successfully from workout plan");
  } catch (e) {
    print("Error deleting exercise: $e");
  }
}

/// Generate the workout plan
Future<void> generateTheWorkoutPlan(
    {required String userLevel,
    required String? loggedInUserEmail,
    required List<String> focusedBodyAreas}) async {
  try {
    // If the user is a beginner, he/she will get a beginner workout plan
    if (userLevel == beginner) {
      generateBeginnerWorkoutPlan(
        loggedInUserEmail: loggedInUserEmail,
        focusedBodyAreas: focusedBodyAreas,
      );
    }

    // If the user is an intermediate, he/she will get an intermediate workout plan
    if (userLevel == intermediate) {
      generateIntermediateWorkoutPlan(
        loggedInUserEmail: loggedInUserEmail,
        focusedBodyAreas: focusedBodyAreas,
      );
    }

    // If the user is an advanced, he/she will get an advanced workout plan
    if (userLevel == advanced) {
      generateAdvancedWorkoutPlan(
        loggedInUserEmail: loggedInUserEmail,
        focusedBodyAreas: focusedBodyAreas,
      );
    }

    // If the user doesn't care about abs, delete abs exercises from the workout plan
    if (!focusedBodyAreas.contains(abs)) {
      deleteExercisesFromWorkoutPlan(
          loggedInUserEmail: loggedInUserEmail, typeOfExercises: absExercises);
    }

    // If the user doesn't care about arms, delete arms exercises from the workout plan
    if (!focusedBodyAreas.contains(arms)) {
      deleteExercisesFromWorkoutPlan(
          loggedInUserEmail: loggedInUserEmail, typeOfExercises: armsExercises);
    }

    // If the user doesn't care about back, delete back exercises from the workout plan
    if (!focusedBodyAreas.contains(back)) {
      deleteExercisesFromWorkoutPlan(
          loggedInUserEmail: loggedInUserEmail, typeOfExercises: backExercises);
    }

    // If the user doesn't care about chest, delete chest exercises from the workout plan
    if (!focusedBodyAreas.contains(chest)) {
      deleteExercisesFromWorkoutPlan(
          loggedInUserEmail: loggedInUserEmail,
          typeOfExercises: chestExercises);
    }

    // If the user doesn't care about legs, delete legs exercises from the workout plan
    if (!focusedBodyAreas.contains(legs)) {
      deleteExercisesFromWorkoutPlan(
          loggedInUserEmail: loggedInUserEmail, typeOfExercises: legsExercises);
    }
  } catch (e) {
    print("An error has occurred");
  }
}
