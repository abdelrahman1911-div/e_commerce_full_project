import 'package:e_commerce_full_project/features/auth/presentations/cubit/auth_cubit.dart';
import 'package:e_commerce_full_project/features/splashscreen/widgets/ball_bounce_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  final bool onboardingComplete;

  const SplashScreen({super.key, required this.onboardingComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().checkAuth();
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: BallBounceSplash())
      ); 
    
  }
}
