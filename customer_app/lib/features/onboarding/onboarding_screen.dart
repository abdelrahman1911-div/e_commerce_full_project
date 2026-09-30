import 'package:e_commerce_full_project/core/router/app_routes.dart';
import 'package:e_commerce_full_project/features/onboarding/widget/onboarding_body_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  final ValueNotifier<bool> onboardingComplete;

  const OnboardingScreen({
    required this.onboardingComplete,
    super.key,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('onboardingComplete', true);

    widget.onboardingComplete.value = true;

    if (!mounted) return;

    context.go(AppRoutes.splash);
  }

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "",
          bodyWidget: OnboardingBodyWidget(),
        ),
        PageViewModel(
          title: "",
          bodyWidget: OnboardingBodyWidget(
            mainOnBoardingSvg: SvgPicture.asset(
              "assets/Credit.svg",
            ),
            headerText: "Lot Of Payment Methods",
            subHeaderText:
                "Choose the Payment method that suits you best , whether you prefer paying by credit card or cash on delivery",
          ),
        ),
        PageViewModel(
          title: "",
          bodyWidget: OnboardingBodyWidget(
            mainOnBoardingSvg: SvgPicture.asset(
              "assets/Discount.svg",
            ),
            headerText: "Amazing Deals Await",
            subHeaderText:
                "Discover new discounts and special offers whenever you shop with us!",
          ),
        ),
      ],
      showSkipButton: true,
      showNextButton: true,
      showDoneButton: true,
      next: const Text("Next"),
      skip: const Text("Skip"),
      done: const Text("Get Started"),
      onSkip: _completeOnboarding,
      onDone: _completeOnboarding,
    );
  }
}
