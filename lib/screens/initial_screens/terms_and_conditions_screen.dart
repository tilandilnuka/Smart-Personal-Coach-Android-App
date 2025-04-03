import 'package:flutter/material.dart';
import 'package:smart_personal_coach/constants.dart';
import 'package:smart_personal_coach/components/terms_and_conditions.dart';

/// Show terms and conditions
class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Appbar
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Terms & Conditions',
          style: kAppBarTextStyle,
        ),
      ),

      /// Body of the screen
      body: Padding(
        // Add padding around the body content
        padding: const EdgeInsets.all(kPadding16),
        child: Column(
          children: [
            /// Terms and Conditions holder
            Expanded(
              child: ListView(
                // Include all components in a list view and set padding around the components to 0
                padding: const EdgeInsets.only(
                  top: kPadding16,
                  bottom: kPadding16,
                ),
                primary: false,
                children: const [
                  TermsAndConditionsHolder(
                    title: tncLastUpdateTitle,
                    description: tncLastUpdateDescription,
                  ),
                  TermsAndConditionsHolder(
                    title: tncAcceptanceOfTermsTitle,
                    description: tncAcceptanceOfTermsDescription,
                  ),
                  TermsAndConditionsHolder(
                    title: tncUserAccountsTitle,
                    description: tncUserAccountsDescription,
                  ),
                  TermsAndConditionsHolder(
                    title: tncAgreementToTermsTitle,
                    description: tncAgreementToTermsDescription,
                  ),

                  /// App name and Company name holder
                  Column(
                    children: [
                      Text(
                        'Smart Personal Coach',
                        style: kTermsAndConditionsTitlesTextStyle,
                      ),
                      Text(
                        'Powered by ADNA',
                        style: kSmallGreyColorDescriptionTextStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Add a sized box to add space between the terms and conditions holder and the go-back button
            const SizedBox(height: 8.0),

            /// Go-back button
            ElevatedButton(
              onPressed: () {
                // When the button is clicked, go back to the sign-up screen
                Navigator.pop(context);
              },
              style: kNextButtonStyle,
              child: const Text(
                'OK',
                style: kNextButtonTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
