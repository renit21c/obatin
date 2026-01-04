import 'package:flutter/material.dart';
import 'dart:async';
import 'package:obatin/shared_prefs_helper.dart';
import 'package:obatin/homescreen.dart';
import 'package:obatin/login_options_screen.dart';
import 'package:obatin/privacy_policy_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      // Check if privacy policy has been agreed to
      final privacyAgreed = await SharedPreferencesHelper()
          .getPrivacyPolicyAgreed();

      Timer(const Duration(seconds: 3), () async {
        if (!mounted) return;
        if (!privacyAgreed) {
          // Privacy policy not agreed, show privacy policy screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const PrivacyPolicyScreen(),
            ),
          );
          return;
        }

        // Now we use the helper to see if a user is logged in
        final user = await SharedPreferencesHelper().getLoggedInUser();

        if (!mounted) return;

        if (user != null) {
          // User is logged in, go to home
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          // User is not logged in, go to login options
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginOptionsScreen()),
          );
        }
      });
    } catch (e) {
      // If there's an error, navigate to privacy policy screen after 3 seconds
      Timer(const Duration(seconds: 3), () {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/obatinlogo.png',
          errorBuilder: (context, error, stackTrace) {
            return const Text(
              'Failed to load logo',
              style: TextStyle(color: Colors.black),
            );
          },
        ),
      ),
    );
  }
}
