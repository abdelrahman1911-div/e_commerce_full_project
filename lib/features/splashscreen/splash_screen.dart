import 'dart:async';
import 'package:e_commerce_full_project/core/router/app_routes.dart';
import 'package:e_commerce_full_project/features/auth/presentations/cubit/auth_cubit.dart';
import 'package:e_commerce_full_project/features/splashscreen/widgets/ball_bounce_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
class SplashScreen extends StatefulWidget {
  final bool onboardingComplete;
  const SplashScreen({
    super.key,
    required this.onboardingComplete,
  });
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  bool _navigated = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().checkAuth();
      if (!widget.onboardingComplete) {
        _timer = Timer(
          const Duration(seconds: 2),
          _goToOnboarding,
        );
      }
    });
  }
  void _goToOnboarding() {
    if (!mounted || _navigated) return;
    _navigated = true;
    context.go(AppRoutes.onboarding);
  }
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: BallBounceSplash(),
      ),
    );
  }
}
