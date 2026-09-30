import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BallBounceSplash extends StatefulWidget {
  const BallBounceSplash({super.key});

  @override
  State<BallBounceSplash> createState() => _BallBounceSplashState();
}

class _BallBounceSplashState extends State<BallBounceSplash>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _bounceAnimation = TweenSequence<double>([
      // نزول
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 0.65,
        ).chain(
          CurveTween(
            curve: Curves.easeIn,
          ),
        ),
        weight: 40,
      ),

      // طلوع
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.65,
          end: 0.0,
        ).chain(
          CurveTween(
            curve: Curves.elasticOut,
          ),
        ),
        weight: 60,
      ),
    ]).animate(_controller);

    // ابدأ الـ bounce
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: AnimatedBuilder(
          animation: _bounceAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                0,
                _bounceAnimation.value * 150.h,
              ),
              child: child,
            );
          },
          child: SizedBox(
            height: 180.w,
            width: 180.w,
            child: SvgPicture.asset(
              'assets/surfco-icon.svg',
            ),
          ),
        ),
      ),
    );
  }
}
