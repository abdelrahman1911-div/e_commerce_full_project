import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:e_commerce_full_project/features/auth/presentations/screens/loginscreen.dart';
import 'package:e_commerce_full_project/features/onboarding/onboarding_screen.dart';
import 'package:e_commerce_full_project/features/splashscreen/widgets/ball_bounce_splash.dart';
import 'package:flutter/material.dart';
class SplashScreen extends StatelessWidget {
  final bool onboardingComplete;
  const SplashScreen({super.key, required this.onboardingComplete});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        splash: BallBounceSplash(), 
        duration: 700,
        splashTransition: SplashTransition.sizeTransition,
        backgroundColor: Colors.white,
        nextScreen: onboardingComplete
            ? const LoginScreen()
            : const OnboardingScreen(),
      ),
    );
  }
}
