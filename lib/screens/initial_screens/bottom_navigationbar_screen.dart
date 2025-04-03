import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_personal_coach/constants.dart';
import 'package:smart_personal_coach/screens/initial_screens/signin_screen.dart';
import 'package:smart_personal_coach/screens/main_screens/explore_screen.dart';
import 'package:smart_personal_coach/screens/main_screens/home_screen.dart';
import 'package:smart_personal_coach/screens/main_screens/profile_screen.dart';
import 'package:smart_personal_coach/screens/main_screens/suppliment_shop.dart'; // Import your shop screen

/// Main screen with bottom navigation bar
class BottomNavigationBarScreenScreen extends StatefulWidget {
  const BottomNavigationBarScreenScreen({super.key});

  @override
  State<BottomNavigationBarScreenScreen> createState() =>
      _BottomNavigationBarScreenScreenState();
}

class _BottomNavigationBarScreenScreenState
    extends State<BottomNavigationBarScreenScreen> {
  final _auth = FirebaseAuth.instance;
  late User loggedInUser;

  int _currentScreenIndex = 0;

  void getLoggedIntUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error has occurred!')),
      );
    }
  }

  // Added ShopScreen to the screens list
  final List<Widget> _screens = [
    const HomeScreen(),
    const ExploreScreen(),
    const SupplementShopScreen(), // New shop screen
    const ProfileScreen(),
  ];

  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signed Out!')),
      );
    } catch (e) {
      print("Error signing out: $e");
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
            'Are you sure you want to sign out?',
            style: TextStyle(color: kWhiteThemeColor),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text('Yes'),
              onPressed: () {
                _signOut();
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInScreen(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    getLoggedIntUser();
    super.initState();
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
        body: _screens[_currentScreenIndex],
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (index) {
            setState(() {
              _currentScreenIndex = index;
            });
          },
          animationDuration: const Duration(seconds: 1),
          elevation: 8,
          shadowColor: kAppThemeColor,
          surfaceTintColor: kWhiteThemeColor,
          backgroundColor: kWhiteThemeColor,
          indicatorColor: kAppThemeColor,
          selectedIndex: _currentScreenIndex,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_rounded, color: kBlackThemeColor),
              label: 'Home',
              selectedIcon: Icon(Icons.home_rounded, color: kWhiteThemeColor),
            ),
            NavigationDestination(
              icon: Icon(Icons.fitness_center_rounded, color: kBlackThemeColor),
              label: 'Explore',
              selectedIcon:
              Icon(Icons.fitness_center_rounded, color: kWhiteThemeColor),
            ),
            NavigationDestination(
              icon: Icon(Icons.shopping_bag_rounded, color: kBlackThemeColor), // Shopping icon
              label: 'Shop',
              selectedIcon: Icon(Icons.shopping_bag_rounded, color: kWhiteThemeColor),
            ),
            NavigationDestination(
              icon: Icon(Icons.person_rounded, color: kBlackThemeColor),
              label: 'Profile',
              selectedIcon: Icon(Icons.person_rounded, color: kWhiteThemeColor),
            ),
          ],
        ),
      ),
    );
  }
}