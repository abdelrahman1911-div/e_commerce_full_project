import 'dart:developer' show log;

import 'package:e_commerce_full_project/core/di/injection_container.dart'
    as InjectionContainer;
import 'package:e_commerce_full_project/core/router/app_router_configuration.dart';
import 'package:e_commerce_full_project/core/styling/app_themes.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/cubit/order_cubit.dart';
import 'package:e_commerce_full_project/features/settingscreen/PaymentPerf/cubit/payment_preference_services.dart';
import 'package:e_commerce_full_project/features/auth/presentations/cubit/auth_cubit.dart';
import 'package:e_commerce_full_project/features/home/favourite/cubit/favourite_cubit.dart';
import 'package:e_commerce_full_project/features/home/mycart/cubit/mycart_cubit.dart';
import 'package:e_commerce_full_project/firebase_options.dart';
import 'package:e_commerce_full_project/core/theme/themeController.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool onboardingComplete =
      prefs.getBool('onboardingComplete') ??
      false;
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final authCubit = AuthCubit(InjectionContainer.authRepository);
  await authCubit.checkAuth();
  log('FINAL AUTH STATE: ${authCubit.state}');
  log('CURRENT USER: ${FirebaseAuth.instance.currentUser?.uid}');
  // await authCubit.logout();
  final appRouter = createAppRouter(onboardingComplete);
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/trans',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => CartCubit()),

          BlocProvider(create: (_) => FavouriteCubit()),

          BlocProvider<OrderCubit>(create: (_) => OrderCubit()),

          BlocProvider<PaymentPreferenceCubit>(
            create: (_) => PaymentPreferenceCubit(),
          ),
        ],

        child: MyApp(authCubit: authCubit, appRouter: appRouter),
      ),
    ),
  );
}
class MyApp extends StatelessWidget {
  final AuthCubit? authCubit;
  final GoRouter? appRouter;
  const MyApp({this.authCubit, this.appRouter, super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      child: BlocProvider.value(
        value: authCubit!,
        child: ValueListenableBuilder<ThemeMode>(
          valueListenable: ThemeController.themeMode,
          builder: (context, currentThemeMode, _) {
            return MaterialApp.router(
              theme: AppThemes.lightTheme,
              darkTheme: AppThemes.darkTheme,
              themeMode: currentThemeMode,
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              routerConfig: appRouter,
              debugShowCheckedModeBanner: false,
              debugShowMaterialGrid: false,
            );
          },
        ),
      ),
    );
  }
}
