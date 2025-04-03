import 'package:flutter/material.dart';
import 'package:smart_personal_coach/constants.dart';
import 'package:smart_personal_coach/components/top_image.dart';
import 'package:smart_personal_coach/screens/initial_screens/signin_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Body of the screen
      body: Column(
        children: [
          /// Top image container
          const Expanded(
            child: TopImage(imageUrl: 'images/theme-image.jpg'),
          ),

          /// The Title and the description holder
          SizedBox(
            child: Padding(
              // Add padding around the title and description holder
              padding: const EdgeInsets.all(kPadding16),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// Welcome text
                      Container(
                        height: 100,
                        alignment: Alignment.center,
                        child: AnimatedTextKit(
                          repeatForever: true,
                          animatedTexts: [
                            ColorizeAnimatedText(
                              "WELCOME",
                              textAlign: TextAlign.center,
                              textStyle: kWelcomeTextStyle,
                              colors: kBlackTextColorizeColors,
                            ),
                            ColorizeAnimatedText(
                              "SMART PERSONAL COACH",
                              textAlign: TextAlign.center,
                              textStyle: kWelcomeTextStyle,
                              colors: kBlackTextColorizeColors,
                            ),
                          ],
                        ),
                      ),

                      /// Description
                      AnimatedTextKit(
                        isRepeatingAnimation: false,
                        animatedTexts: [
                          ColorizeAnimatedText(
                            "Join us on your journey to wellness!",
                            textAlign: TextAlign.center,
                            speed: const Duration(milliseconds: 400),
                            textStyle: kSmallGreyColorDescriptionTextStyle,
                            colors: kGreyTextColorizeColors,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          /// Button to get started the application
          SizedBox(
            child: Padding(
              // Add padding around the button
              padding: const EdgeInsets.all(kPadding16),
              child: ElevatedButton(
                style: kWelcomeButtonStyle,
                onPressed: () {
                  // If the button is clicked, go to the Sign in screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Get Started',
                  style: kWelcomeButtonTextStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
