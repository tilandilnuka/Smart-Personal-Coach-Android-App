import 'package:flutter/material.dart';
import 'package:smart_personal_coach/constants.dart';
import 'package:smart_personal_coach/screens/exercises_screens/abs_exercises_screen.dart';
import 'package:smart_personal_coach/screens/exercises_screens/arms_exercises_screen.dart';
import 'package:smart_personal_coach/screens/exercises_screens/back_exercises_screen.dart';
import 'package:smart_personal_coach/screens/exercises_screens/chest_exercises_screen.dart';
import 'package:smart_personal_coach/screens/exercises_screens/legs_exercises_screen.dart';

/// Explore screen
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Appbar
      appBar: AppBar(
        title: const Text(
          'EXPLORE',
          style: kAppBarTextStyle,
        ),
        automaticallyImplyLeading: false,
      ),

      /// Body of the screen
      body: ListView(
        padding: const EdgeInsets.all(kPadding16),
        primary: false,
        children: [
          /// Abs button
          ButtonWithBackgroundImageAndText(
            image: "images/abs.jpg",
            text: "ABS",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AbsExercisesScreen(),
                ),
              );
            },
          ),

          /// Adding space
          const SizedBox(height: 10.0),

          /// Arms button
          ButtonWithBackgroundImageAndText(
            image: "images/arms.jpg",
            text: "ARMS",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ArmsExercisesScreen(),
                ),
              );
            },
          ),

          /// Adding space
          const SizedBox(height: 10.0),

          /// Back button
          ButtonWithBackgroundImageAndText(
            image: "images/back.jpg",
            text: "BACK",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BackExercisesScreen(),
                ),
              );
            },
          ),

          /// Adding space
          const SizedBox(height: 10.0),

          /// Chest button
          ButtonWithBackgroundImageAndText(
            image: "images/chest.jpg",
            text: "CHEST",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChestExercisesScreen(),
                ),
              );
            },
          ),

          /// Adding space
          const SizedBox(height: 10.0),

          /// Legs button
          ButtonWithBackgroundImageAndText(
            image: "images/legs.jpg",
            text: "LEGS",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LegsExercisesScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ButtonWithBackgroundImageAndText extends StatelessWidget {
  const ButtonWithBackgroundImageAndText({
    super.key,
    required this.image,
    required this.text,
    this.onPressed,
  });

  final String image;
  final String text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: kExploreScreenButton,
      onPressed: onPressed,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(kRadius16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: kPadding8),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                text,
                style: kExploreScreenButtonTextStyle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
