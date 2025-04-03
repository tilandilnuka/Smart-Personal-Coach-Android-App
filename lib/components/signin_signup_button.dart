import 'package:flutter/material.dart';
import 'package:smart_personal_coach/constants.dart';

//Login and SignUp button
class SignInSignUpButton extends StatelessWidget {
  const SignInSignUpButton(
      {super.key, required this.buttonText, required this.onPressed});

  final String buttonText;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: kSignInSignUpSignOutResetPasswordButtonStyle,
      child: Text(
        buttonText,
        style: kSignInSignUpSignOutButtonResetPasswordTextStyle,
      ),
    );
  }
}
