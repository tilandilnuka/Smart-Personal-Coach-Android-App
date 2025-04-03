import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_personal_coach/constants.dart';

class ExerciseCard extends StatelessWidget {
  const ExerciseCard({
    super.key,
    required this.collectionName,
    required this.docName,
  });

  final String collectionName;
  final String docName;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection(collectionName)
            .doc(docName)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text(
              "Loading...",
              style: TextStyle(color: kAppThemeColor),
            );
          }

          if (!snapshot.hasData) {
            return const Text('No data available');
          }

          // Access the data from the snapshot
          Map<String, dynamic> data =
          snapshot.data!.data() as Map<String, dynamic>;

          return Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(kRadius16))),
            surfaceTintColor: kWhiteThemeColor,
            color: kWhiteThemeColor,
            child: ListView(
              padding: const EdgeInsets.all(kPadding16),
              primary: false,
              children: [
                /// Animation image
                CachedNetworkImage(
                  imageUrl: data['animationImage'],
                  placeholder: (context, url) => const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 8.0),
                        Text("Loading animation...")
                      ],
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error_rounded),
                  height: 300,
                ),

                /// Name of the exercise
                Text(
                  data['name'],
                  style: kExerciseCardTitleTextStyle,
                ),

                /// Divider line
                const Divider(),

                /// Introduction
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Introduction",
                      style: kExerciseCardSubtitleTextStyle,
                    ),
                    Text(
                      data['introduction'],
                      style: kExerciseCardDescriptionTextStyle,
                    ),
                  ],
                ),

                /// Adding space
                const SizedBox(height: 12.0),

                /// Difficulty
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Difficulty",
                      style: kExerciseCardSubtitleTextStyle,
                    ),
                    SizedBox(
                      height: 50.0,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: kBlackThemeColor),
                                color: data["difficulty"] == "Easy"
                                    ? kAppThemeColor
                                    : kWhiteThemeColor,
                              ),
                              child: Text(
                                "Easy",
                                style:
                                kExerciseCardDescriptionTextStyle.copyWith(
                                  color: data["difficulty"] == "Easy"
                                      ? kWhiteThemeColor
                                      : kGreyThemeColor,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: const Border.symmetric(
                                    horizontal:
                                    BorderSide(color: kBlackThemeColor)),
                                color: data["difficulty"] == "Moderate"
                                    ? kAppThemeColor
                                    : kWhiteThemeColor,
                              ),
                              child: Text(
                                "Moderate",
                                style:
                                kExerciseCardDescriptionTextStyle.copyWith(
                                  color: data["difficulty"] == "Moderate"
                                      ? kWhiteThemeColor
                                      : kGreyThemeColor,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: kBlackThemeColor),
                                color: data["difficulty"] == "Challenging"
                                    ? kAppThemeColor
                                    : kWhiteThemeColor,
                              ),
                              child: Text(
                                "Challenging",
                                style:
                                kExerciseCardDescriptionTextStyle.copyWith(
                                  color: data["difficulty"] == "Challenging"
                                      ? kWhiteThemeColor
                                      : kGreyThemeColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                /// Adding space
                const SizedBox(height: 12.0),

                /// Common mistakes
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Common Mistakes",
                      style: kExerciseCardSubtitleTextStyle,
                    ),
                    Text(
                      data['commonMistakes'],
                      style: kExerciseCardDescriptionTextStyle,
                    ),
                  ],
                ),

                /// Adding space
                const SizedBox(height: 12.0),

                /// Close button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kAppThemeColor,
                      fixedSize: const Size.fromWidth(double.maxFinite)),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Close Page",
                    style: TextStyle(
                      color: kWhiteThemeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}