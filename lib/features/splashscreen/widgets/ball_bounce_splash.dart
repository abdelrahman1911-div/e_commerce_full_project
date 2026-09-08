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
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _bounceAnimation = TweenSequence<double>([
      // البداية → نزول التنطيطة الأولى
      // TweenSequenceItem(
      //   tween: Tween<double>(
      //     begin: 0.0,
      //     end: 1.0,
      //   ).chain(
      //     CurveTween(curve: Curves.easeIn),
      //   ),
      //   weight: 20,
      // ),

      // // طلوع التنطيطة الأولى
      // TweenSequenceItem(
      //   tween: Tween<double>(
      //     begin: 1.0,
      //     end: 0.0,
      //   ).chain(
      //     CurveTween(curve: Curves.easeOut),
      //   ),
      //   weight: 20,
      // ),

      // نزول التنطيطة الثانية
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 0.65,
        ).chain(
          CurveTween(curve: Curves.easeIn),
        ),
        weight: 15,
      ),

      // طلوع التنطيطة الثانية → مكانها الأصلي
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.65,
          end: 0.0,
        ).chain(
          CurveTween(curve: Curves.easeOut),
        ),
        weight: 20,
      ),

      // تثبيت الكرة في مكانها
      TweenSequenceItem(
        tween: ConstantTween<double>(0.0),
        weight: 25,
      ),
    ]).animate(_controller);

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
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(
                0,
                _bounceAnimation.value * 150.h,
              ),
              child: Container(
                height: 180.w,
                width: 180.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  "assets/surfco-icon.svg",
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}