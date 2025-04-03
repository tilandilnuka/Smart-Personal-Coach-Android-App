import 'package:flutter/material.dart';
import 'package:smart_personal_coach/constants.dart';

// Terms and Conditions
const String tncLastUpdateTitle = 'Last Updated: 19.01.2024';
const String tncLastUpdateDescription = 'Welcome to Smart Personal Coach. By accessing or using the App, you agree to comply with and be bound by the following terms and conditions. If you do not agree with these terms, please do not use the App.';

const String tncAcceptanceOfTermsTitle = 'Acceptance of Terms';
const String tncAcceptanceOfTermsDescription = 'By using the App, you acknowledge that you have read, understood, and agree to be bound by these terms and conditions. We reserve the right to update, modify, or replace any part of these terms at our sole discretion. It is your responsibility to check this page periodically for changes.';

const String tncUserAccountsTitle = 'User Accounts';
const String tncUserAccountsDescription = 'a. You are responsible for maintaining the confidentiality of your account information. b. You agree to provide accurate, current, and complete information during the registration process. c. You must notify us immediately of any unauthorized use of your account or any other security breach.';

const String tncAgreementToTermsTitle = 'Agreement to Terms';
const String tncAgreementToTermsDescription = 'By using the App, you acknowledge that you have read and understood these terms and agree to be bound by them.';

const String tncBottom = 'Remember to adapt these terms to the specific details of your fitness app and consult with legal professionals to ensure compliance with relevant laws and regulations.';

/// Terms and Conditions holder
class TermsAndConditionsHolder extends StatelessWidget {
  const TermsAndConditionsHolder({
    super.key,
    required this.title,
    required this.description,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: kPadding16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: kTermsAndConditionsTitlesTextStyle,
          ),
          Text(
            description,
            style: kTermsAndConditionsDescriptionsTextStyle,
          ),
        ],
      ),
    );
  }
}