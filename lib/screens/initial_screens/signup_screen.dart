import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:smart_personal_coach/constants.dart';
import 'package:smart_personal_coach/components/signin_signup_button.dart';
import 'package:smart_personal_coach/components/title_and_description_holder.dart';
import 'package:smart_personal_coach/components/top_image.dart';

/// Sign-Up Screen
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  /// Create text controllers and use them to retrieve
  /// the current values of the email, password and confirm password text boxes
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  /// Create a global key that uniquely identifies the Form widget
  /// and allows validation of the form.
  final _formKeySignUp = GlobalKey<FormState>();

  /// Validator for email
  String? _validateEmail(String? value) {
    // Is the text field empty?
    if (value == null || value.isEmpty) {
      return 'Enter an email';
    }
    // Is it a valid email?
    else if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email address';
    } else {
      return null;
    }
  }

  /// Validator for password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a password';
    }
    // Password length greater than 6
    else if (value.length < 6) {
      return 'Password must be longer than 6 characters';
    }
    // Contains at least one uppercase letter
    else if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Uppercase letter is missing';
    }
    // Contains at least one lowercase letter
    else if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Lowercase letter is missing';
    }
    // Contains at least one digit
    else if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Digit is missing';
    }
    // Contains at least one special character
    else if (!value.contains(RegExp(r'[!@#%^&*(),.?":{}|<>]'))) {
      return 'Special character is missing';
    }
    // If there are no error messages, the password is valid
    return null;
  }

  /// Validator for confirm password
  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text.trim()) {
      return 'The password and confirmation password do not match';
    } else {
      return null;
    }
  }

  /// To check whether check box is checked or not.
  // bool? _isTermsAndConditionsChecked = false;

  // To check whether visibility button is clicked or not.
  bool _isVisibilityButtonClicked = false;

  // To show or hide spinner
  bool showSpinner = false;

  /// Visibility button click function
  void visibilityButtonClick() {
    if (_isVisibilityButtonClicked == false) {
      _isVisibilityButtonClicked = true;
    } else {
      _isVisibilityButtonClicked = false;
    }
  }

  /// Sign up new user
  Future<void> _signUp() async {
    setState(() {
      //Once click on the register button, showSpinner is equal to true and
      //shows the modal progress indicator.
      showSpinner = true;
    });
    try {
      // Create a new user with email and password
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed Up!')),
      );
      // Back to the sign in page and show snack bar with 'Signed Up' message
      await _signIn();
      await _sendEmailVerification();
      await _signOut();
      if (!mounted) return;
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e);
      // Show snack bar with error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    } catch (e) {
      // print(e);
      // show snack bar with error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
    //After all, showSpinner is equal to false and disappears modal progress indicator.
    setState(() {
      showSpinner = false;
    });
  }

  /// Sign in existing user
  Future<void> _signIn() async {
    try {
      // Sign in a user with an email address and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;
      // ignore: avoid_print
      print("Signed In");
    } on FirebaseAuthException catch (e) {
      // ignore: avoid_print
      print(e.message);
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  /// Sign out method
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      // ignore: avoid_print
      print("Signed Out");
    } catch (e) {
      // ignore: avoid_print
      print("Error signing out: $e");
    }
  }

  /// Send verification email to the user's email
  Future<void> _sendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.sendEmailVerification();
    if (!mounted) return;
    // Show snack bar with message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Sent an email verification."
              " Please check your email inbox and verify the email to proceed!")),
    );
  }

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Body of the screen
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        progressIndicator: const CircularProgressIndicator(
          color: kAppThemeColor,
        ),
        child: Column(
          children: [
            /// Top of the screen (Top image)
            MediaQuery.of(context).viewInsets.bottom == 0
                ? const Expanded(
                    flex: 4,
                    child: TopImage(imageUrl: 'images/signup-screen-image.jpg'),
                  )
                : const SizedBox(),

            /// Bottom components holder (Middle and bottom of the screen)
            Expanded(
              flex: MediaQuery.of(context).size.height > 800 ? 4 : 10,
              // Add padding around the bottom components
              child: Padding(
                padding: const EdgeInsets.only(
                  left: kPadding16,
                  right: kPadding16,
                  bottom: kPadding16,
                ),
                // Adding all the components at the bottom to a column
                child: Column(
                  mainAxisAlignment:
                      MediaQuery.of(context).viewInsets.bottom == 0
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.center,
                  children: [
                    /// Middle of the screen (Title, user input fields and check box)
                    /// User inputs container and title and description container
                    Form(
                      key: _formKeySignUp,
                      child: Column(
                        children: [
                          /// The Title and the description holder
                          const InitialScreensTitleAndDescriptionHolder(
                            title: "Sign Up",
                            description: "Create your account here",
                          ),

                          /// Add space
                          const SizedBox(height: 12.0),

                          /// Get the user's email
                          TextFormField(
                            validator: _validateEmail,
                            controller: _emailController,
                            decoration:
                                kSignInSignUpTextFormFieldDecorations.copyWith(
                              hintText: 'Email',
                              prefixIcon: const Icon(
                                Icons.email_rounded,
                                color: kAppThemeColor,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),

                          /// Add space
                          const SizedBox(height: 12.0),

                          /// Get the user's password
                          TextFormField(
                            validator: _validatePassword,
                            controller: _passwordController,
                            decoration:
                                kSignInSignUpTextFormFieldDecorations.copyWith(
                              hintText: 'Password',
                              prefixIcon: const Icon(
                                Icons.lock_rounded,
                                color: kAppThemeColor,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    visibilityButtonClick();
                                  });
                                },
                                icon: _isVisibilityButtonClicked
                                    ? const Icon(
                                        Icons.visibility_rounded,
                                        color: kAppThemeColor,
                                      )
                                    : const Icon(
                                        Icons.visibility_off_rounded,
                                        color: kAppThemeColor,
                                      ),
                              ),
                            ),
                            obscureText:
                                _isVisibilityButtonClicked ? false : true,
                            enableSuggestions: false,
                            autofocus: false,
                          ),

                          /// Add space
                          const SizedBox(height: 12.0),

                          /// Confirm the password
                          TextFormField(
                            validator: _validateConfirmPassword,
                            controller: _confirmPasswordController,
                            decoration:
                                kSignInSignUpTextFormFieldDecorations.copyWith(
                              hintText: 'Confirm Password',
                              prefixIcon: const Icon(
                                Icons.lock_rounded,
                                color: kAppThemeColor,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    visibilityButtonClick();
                                  });
                                },
                                icon: _isVisibilityButtonClicked
                                    ? const Icon(
                                        Icons.visibility_rounded,
                                        color: kAppThemeColor,
                                      )
                                    : const Icon(
                                        Icons.visibility_off_rounded,
                                        color: kAppThemeColor,
                                      ),
                              ),
                            ),
                            obscureText:
                                _isVisibilityButtonClicked ? false : true,
                            enableSuggestions: false,
                            autofocus: false,
                          ),

                          /// Add space
                          const SizedBox(height: 12.0),

                          /// Sign up button
                          SignInSignUpButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_formKeySignUp.currentState!.validate()) {
                                _signUp();
                              }
                            },
                            buttonText: 'Sign Up',
                          ),
                        ],
                      ),
                    ),

                    /// Adding space
                    const SizedBox(height: 12.0),

                    /// Sign in text button container
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: kSmallGreyColorDescriptionTextStyle,
                        ),

                        /// Sign In text button
                        TextButton(
                          onPressed: () {
                            // Navigate to the sign-in screen
                            Navigator.pop(context);
                          },
                          style: kTextButtonStyle,
                          child: const Text(
                            'Sign In',
                            style: kTextButtonTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
