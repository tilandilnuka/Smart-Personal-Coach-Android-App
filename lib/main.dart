import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_personal_coach/constants.dart';
import 'package:smart_personal_coach/screens/initial_screens/welcome_screen.dart';
import 'firebase_options.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = "pk_test_51R9CUTHKDwKFlmiws1jJ7QaYr3GiWI2nUj5IXpxCVeDUuvfIDzcs5Z77S6uSZsUXoHsi91kq723VWAwUFIWhnQfn00r4ssb5uu";
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> precacheAssets(BuildContext context) async {
    // List of asset images paths
    final List<String> assetPaths = [
      "images/abs.jpg",
      "images/arms.jpg",
      "images/back.jpg",
      "images/chest.jpg",
      "images/legs.jpg",
      "images/signin-screen-image.jpg",
      "images/signup-screen-image.jpg",
      "images/theme-image.jpg",
      "images/facebook-logo.png",
      "images/google-logo.png",
      "images/full-body-image.png",
      "images/gender-selection-screen-image.jpg",
    ];

    // Precache all asset images
    for (String path in assetPaths) {
      await precacheImage(AssetImage(path), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: precacheAssets(context),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While the initialization is in progress, show a loading indicator
          return MaterialApp(
            home: Scaffold(
              body: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/theme-image.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: kAppThemeColor,
                        strokeAlign: 4.0,
                        backgroundColor: kWhiteThemeColor,
                        strokeWidth: 8.0,
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      Text(
                        "Loading...",
                        style: TextStyle(
                          color: kWhiteThemeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          // If an error occurs during initialization, display an error message
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('Error occurred during initialization'),
              ),
            ),
          );
        } else {
          // Once initialization is complete, build the main app UI
          return MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: kAppThemeColor),
              useMaterial3: true,
              fontFamily: 'Roboto',
              scaffoldBackgroundColor: kWhiteThemeColor,
              appBarTheme: const AppBarTheme(
                color: kAppThemeColor,
                shadowColor: kAppThemeColor,
                elevation: 2,
              ),
            ),
            debugShowCheckedModeBanner: false,
            home: const WelcomeScreen(),
          );
        }
      },
    );
  }
}