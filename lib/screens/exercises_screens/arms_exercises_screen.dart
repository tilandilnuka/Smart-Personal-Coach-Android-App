import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_personal_coach/components/exercises_list_tile.dart';
import 'package:smart_personal_coach/constants.dart';

class ArmsExercisesScreen extends StatefulWidget {
  const ArmsExercisesScreen({super.key});

  @override
  State<ArmsExercisesScreen> createState() => _ArmsExercisesScreenState();
}

class _ArmsExercisesScreenState extends State<ArmsExercisesScreen> {
  final String _collectionName = "arms_exercises";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// App Bar
      appBar: AppBar(
        title: const Text(
          "Arms Exercises",
          style: kAppBarTextStyle,
        ),
        iconTheme: const IconThemeData(color: kWhiteThemeColor),
      ),

      /// Body of the screen
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection(_collectionName).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Loading exercises..."));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("No data available"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(kPadding16),
            primary: false,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              return Padding(
                // Adding space between two exercises list tiles
                padding: const EdgeInsets.only(bottom: kPadding8),
                child: ExercisesListTile(
                  collectionName: _collectionName,
                  document: document,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
