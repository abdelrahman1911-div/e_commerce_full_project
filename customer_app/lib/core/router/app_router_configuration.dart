import 'dart:async';
import 'dart:developer';
import 'package:e_commerce_full_project/core/router/app_routes.dart';
import 'package:e_commerce_full_project/features/All_categories_brands/all_Item_screen.dart';
import 'package:e_commerce_full_project/features/All_categories_brands/all_categorise_screen.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/presentation/screen/categorise_screen.dart';
import 'package:e_commerce_full_project/features/CheckOut/checkout_screen.dart';
import 'package:e_commerce_full_project/features/CheckOut/order_success/order_success_screen.dart';
import 'package:e_commerce_full_project/features/auth/presentations/cubit/auth_cubit.dart';
import 'package:e_commerce_full_project/features/auth/presentations/cubit/auth_state.dart';
import 'package:e_commerce_full_project/features/auth/presentations/screens/loginscreen.dart';
import 'package:e_commerce_full_project/features/auth/register/presentation/register_screen.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/presentations/screens/brand_screen.dart';
import 'package:e_commerce_full_project/features/changepassword/change_password_screen.dart';
import 'package:e_commerce_full_project/features/changepassword/forgotpassword/forgot_password_screen.dart';
import 'package:e_commerce_full_project/features/home/favourite/peresentation/favourite_screen.dart';
import 'package:e_commerce_full_project/features/home/homescreen.dart';
import 'package:e_commerce_full_project/features/home/mycart/mycart_screen.dart';
import 'package:e_commerce_full_project/features/home/product/data/model/product_model.dart';
import 'package:e_commerce_full_project/features/home/product/presentation/screen/product_details_screen.dart';
import 'package:e_commerce_full_project/features/home/profile/presentation/screen/profile_screen.dart';
import 'package:e_commerce_full_project/features/onboarding/onboarding_screen.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/presentation/screen/myorders_screen.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/widget/order_tracking/order_tracking.dart';
import 'package:e_commerce_full_project/features/settingscreen/PaymentPerf/paymentPerferences_screen.dart';
import 'package:e_commerce_full_project/features/settingscreen/addressScreen/address_screen.dart';
import 'package:e_commerce_full_project/features/settingscreen/personalinfo/personal_information.dart';
import 'package:e_commerce_full_project/features/settingscreen/settingscreen.dart';
import 'package:e_commerce_full_project/features/splashscreen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthRouterRefreshNotifier extends ChangeNotifier {
  late final StreamSubscription _authSubscription;
  late final VoidCallback _onboardingListener;

  final AuthCubit authCubit;
  final ValueNotifier<bool> onboardingComplete;

  AuthRouterRefreshNotifier(this.authCubit, this.onboardingComplete) {
    _authSubscription = authCubit.stream.listen((_) {
      notifyListeners();
    });

    _onboardingListener = () {
      notifyListeners();
    };

    onboardingComplete.addListener(_onboardingListener);
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    onboardingComplete.removeListener(_onboardingListener);
    super.dispose();
  }
}

GoRouter createAppRouter(
  AuthCubit authCubit,
  ValueNotifier<bool> onboardingComplete,
) {
  final refreshNotifier = AuthRouterRefreshNotifier(
    authCubit,
    onboardingComplete,
  );

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = authCubit.state;
      final onboardingDone = onboardingComplete.value;

      final currentRoute = state.matchedLocation;

      final isLogin = currentRoute == AppRoutes.login;
      final isRegister = currentRoute == AppRoutes.register;
      final isSplash = currentRoute == AppRoutes.splash;
      final isForgotPassword = currentRoute == AppRoutes.forgetPass;
      final isChangePassword = currentRoute == AppRoutes.changepass;
      final isOnboarding = currentRoute == AppRoutes.onboarding;

      log('CURRENT ROUTE: $currentRoute');
      log('AUTH STATE: $authState');
      log('ONBOARDING COMPLETE: $onboardingDone');

      if (!onboardingDone) {
        if (isSplash || isOnboarding) {
          return null;
        }

        return AppRoutes.onboarding;
      }

      if (authState is AuthInitial || authState is AuthChecking) {
        return isSplash ? null : AppRoutes.splash;
      }

      if (authState is AuthUnauthenticated) {
        if (isLogin || isRegister || isForgotPassword || isChangePassword) {
          return null;
        }

        return AppRoutes.login;
      }

      if (authState is AuthSuccess) {
        if (isSplash || isLogin || isRegister || isForgotPassword) {
          return AppRoutes.home;
        }

        return null;
      }

      if (authState is AuthError) {
        if (isLogin || isRegister || isForgotPassword || isChangePassword) {
          return null;
        }

        return AppRoutes.login;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) {
          return SplashScreen(onboardingComplete: onboardingComplete.value);
        },
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) {
          return OnboardingScreen(onboardingComplete: onboardingComplete);
        },
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.forgetPass,
        builder: (context, state) {
          return const ForgotPasswordScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) {
          return const RegisterScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) {
          return const HomeScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.checkOut,
        builder: (context, state) {
          return CheckoutScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.orderScreen,
        builder: (context, state) {
          final orderId = state.extra as String;

          return OrderSuccessScreen(orderId: orderId);
        },
      ),
      GoRoute(
        path: AppRoutes.OrderTracking,
        builder: (context, state) {
          final orderId = state.extra as String;

          return OrderTracking(orderId: orderId);
        },
      ),
      GoRoute(
        path: AppRoutes.allCategories,
        builder: (context, state) {
          return AllCategoriesScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.allItems,
        builder: (context, state) {
          final products = state.extra as List<ProductModel>;

          return AllItemsScreen(productsList: products);
        },
      ),
      GoRoute(
        path: AppRoutes.AddressScreen,
        builder: (context, state) {
          return const AddressScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.MyOrdersScreen,
        builder: (context, state) {
          return const MyOrdersScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.PayPerf,
        builder: (context, state) {
          return const PaymentPreferenceScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.settingScreen,
        builder: (context, state) {
          return SettingsScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.personalInformation,
        builder: (context, state) {
          return const PersonalInformationScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.changepass,
        builder: (context, state) {
          return const ChangePasswordScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.brand,
        builder: (context, state) {
          return BrandScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.categorise,
        builder: (context, state) {
          return const CategoriseScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.cart,
        builder: (context, state) {
          return const MycartScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) {
          return const ProfileScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.favourites,
        builder: (context, state) {
          return const FavouriteScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.product,
        builder: (context, state) {
          final product = state.extra as ProductModel;

          return ProductDetailsScreen(product: product);
        },
      ),
    ],
  );
}
