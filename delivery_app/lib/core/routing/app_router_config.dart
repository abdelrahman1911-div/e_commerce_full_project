import 'dart:async';

import 'package:e_commerce_delivery_app/features/auth/presentation/cubit/cubit/auth_cubit.dart';
import 'package:e_commerce_delivery_app/features/auth/presentation/cubit/cubit/state/auth_state.dart';
import 'package:e_commerce_delivery_app/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:e_commerce_delivery_app/features/auth/presentation/screens/login_screen.dart';
import 'package:e_commerce_delivery_app/features/home/presentation/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';

class AuthRouterRefreshNotifier extends ChangeNotifier {
  final AuthCubit authCubit;
  late final StreamSubscription<AuthState> _subscription;

  AuthRouterRefreshNotifier(this.authCubit) {
    _subscription = authCubit.stream.listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  static GoRouter createRouter(AuthCubit authCubit) {
    final refreshNotifier = AuthRouterRefreshNotifier(authCubit);

    return GoRouter(
      initialLocation: AppRoutes.login,
      refreshListenable: refreshNotifier,

      redirect: (context, state) {
        final authState = authCubit.state;
        final currentLocation = state.matchedLocation;

        final isLogin = currentLocation == AppRoutes.login;
        final isForgotPassword =
            currentLocation == AppRoutes.forgotPassword;

        if (authState is AuthSuccess) {
          if (isLogin || isForgotPassword) {
            return AppRoutes.home;
          }

          return null;
        }

        if (authState is AuthUnauthenticated) {
          if (isLogin || isForgotPassword) {
            return null;
          }

          return AppRoutes.login;
        }

        return null;
      },

      routes: [
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          builder: (context, state) {
            return const LoginScreen();
          },
        ),

        GoRoute(
          path: AppRoutes.forgotPassword,
          name: 'forgotPassword',
          builder: (context, state) {
            return const ForgotPasswordScreen();
          },
        ),

        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          builder: (context, state) {
            return const DeliveryHomeScreen();
          },
        ),
      ],
    );
  }
}