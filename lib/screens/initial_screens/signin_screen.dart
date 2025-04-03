import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_personal_coach/constants.dart';
import 'package:smart_personal_coach/components/signin_signup_button.dart';
import 'package:smart_personal_coach/components/title_and_description_holder.dart';
import 'package:smart_personal_coach/components/top_image.dart';
import 'package:smart_personal_coach/screens/initial_screens/bottom_navigationbar_screen.dart';
import 'package:smart_personal_coach/screens/initial_screens/forgot_password_screen.dart';
import 'package:smart_personal_coach/screens/data_gathering_screens/gender_selection_screen.dart';
import 'package:smart_personal_coach/screens/initial_screens/signup_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

/// Sign-In Screen
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Creating an instances of FirebaseFirestore
  final _firestore = FirebaseFirestore.instance;

  // Create text controllers and use them to retrieve
  // the current values of the email, password and confirm password text boxes
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKeySignIn = GlobalKey<FormState>();

  /// Checking if document exists
  Future<void> checkDocumentIsEmpty() async {
    DocumentSnapshot snapshot = await _firestore
        .collection('users')
        .doc(_emailController.text.trim())
        .get();
    if (!mounted) return;
    // Checking if the document exists
    if (snapshot.exists) {
      // If the document exists, go to the gender main screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BottomNavigationBarScreenScreen(),
        ),
      );
    } else {
      // If the document does not exist, go to the gender selection screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const GenderSelectionScreen(),
        ),
      );
    }
  }

  void _showBackDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kAppThemeColor,
          title: const Text(
            'Are you sure?',
            style: TextStyle(color: kWhiteThemeColor),
          ),
          content: const Text(
            'Are you sure you want to leave the application?',
            style: TextStyle(color: kWhiteThemeColor),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text(
                'No',
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text(
                'Yes',
              ),
              onPressed: () {
                Navigator.pop(context);
                SystemNavigator.pop();
              },
            ),
          ],
        );
      },
    );
  }

  /// Validator for email
  String? _validateEmail(String? value) {
    // Is the text field empty?
    if (value == null || value.isEmpty) {
      return 'Enter the email';
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
      return 'Enter the password';
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

  /// Sign in existing user
  Future<void> _signIn() async {
    setState(() {
      //Once click on the register button, showSpinner is equal to true and
      //shows the modal progress indicator.
      showSpinner = true;
    });
    try {
      // Sign in a user with an email address and password
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;

      // Checking whether the email is verified or not
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        // Go to the gender selection screen or home screen
        checkDocumentIsEmpty();
        // Show snack bar with 'Signed in' message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signed In!')),
        );
      } else {
        // Show snack bar with 'Signed in' message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  "You haven't verified your email yet. To proceed, please verify your email address.")),
        );
      }
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

  @override
  void dispose() {
    // Clean up the controllers when the widget is disposed
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        _showBackDialog();
      },
      child: Scaffold(
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
                      child:
                          TopImage(imageUrl: 'images/signin-screen-image.jpg'),
                    )
                  : const SizedBox(),

              /// Bottom components holder (Middle and bottom of the screen)
              Expanded(
                flex: MediaQuery.of(context).size.height > 800 ? 4 : 6,
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
                      /// Middle of the screen (Title ans user input fields)
                      /// User inputs container and title and description container
                      Form(
                        key: _formKeySignIn,
                        child: Column(
                          children: [
                            /// The Title and the description holder
                            const InitialScreensTitleAndDescriptionHolder(
                              title: "Sign In",
                              description:
                                  "Please enter email and password to login",
                            ),

                            /// Add space
                            const SizedBox(height: 12.0),

                            /// Get the user's email
                            TextFormField(
                              validator: _validateEmail,
                              controller: _emailController,
                              decoration: kSignInSignUpTextFormFieldDecorations
                                  .copyWith(
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
                              decoration: kSignInSignUpTextFormFieldDecorations
                                  .copyWith(
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

                            /// Forgot password button
                            Container(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  // Go to the forgot password screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordScreen(),
                                    ),
                                  );
                                },
                                style: kTextButtonStyle,
                                child: const Text(
                                  'Forgot Password?',
                                  style: kTextButtonTextStyle,
                                ),
                              ),
                            ),

                            /// Add space
                            const SizedBox(height: 12.0),

                            /// Sign in button
                            SignInSignUpButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, or false otherwise.
                                if (_formKeySignIn.currentState!.validate()) {
                                  _signIn();
                                }
                              },
                              buttonText: 'Sign In',
                            ),
                          ],
                        ),
                      ),

                      /// Adding space
                      const SizedBox(height: 12.0),

                      /// Sign up text button container
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don’t have an account?",
                            style: kSmallGreyColorDescriptionTextStyle,
                          ),

                          /// Sign up text button
                          TextButton(
                            onPressed: () {
                              // Navigate to the sign-up screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );
                            },
                            style: kTextButtonStyle,
                            child: const Text(
                              'Sign Up',
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
      ),
    );
  }
}
