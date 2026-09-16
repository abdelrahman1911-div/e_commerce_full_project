import 'dart:developer' show log;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_full_project/core/di/injection_container.dart'
    as InjectionContainer;

import 'package:e_commerce_full_project/core/router/app_router_configuration.dart';

import 'package:e_commerce_full_project/core/styling/app_themes.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/presentation/cubit/category_cubit.dart';

import 'package:e_commerce_full_project/features/auth/presentations/cubit/auth_cubit.dart';
import 'package:e_commerce_full_project/features/auth/register/cubit/register_cubit.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/presentations/cubit/brand_cubit.dart';

import 'package:e_commerce_full_project/features/home/favourite/peresentation/cubit/favourite_cubit.dart';

import 'package:e_commerce_full_project/features/home/mycart/cubit/mycart_cubit.dart';
import 'package:e_commerce_full_project/features/home/product/presentation/cubit/prod_cubit.dart';
import 'package:e_commerce_full_project/features/home/profile/data/repos/user_repo_impl.dart';
import 'package:e_commerce_full_project/features/home/profile/presentation/cubit/user_cubit.dart';

import 'package:e_commerce_full_project/features/settingscreen/Myorders/presentation/cubit/order_cubit.dart';

import 'package:e_commerce_full_project/features/settingscreen/PaymentPerf/cubit/payment_preference_services.dart';

import 'package:e_commerce_full_project/firebase_options.dart';

import 'package:e_commerce_full_project/core/theme/themeController.dart';

import 'package:easy_localization/easy_localization.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool onboardingComplete = prefs.getBool('onboardingComplete') ?? false;
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform); 
  // await InjectionContainer.productRepository.uploadAllProducts(
  //   ProductData().productsList,
  // );
  await GoogleSignIn.instance.initialize(
    serverClientId:
        '507116110863-2idafv7fauibaa3lif84a0a9tcsc14p5.apps.googleusercontent.com',
  );
  final authCubit = AuthCubit(InjectionContainer.authRepository);
  log('FINAL AUTH STATE: ${authCubit.state}');
  log('CURRENT USER: ${FirebaseAuth.instance.currentUser?.uid}');
  final appRouter = createAppRouter(authCubit, onboardingComplete);
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/trans',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CartCubit>(create: (_) => CartCubit(
            InjectionContainer.cartRepository
          )), 
          BlocProvider<FavouriteCubit>(create: (_) => FavouriteCubit(InjectionContainer.favouriteRepository)..getFavorites()),
          BlocProvider<OrderCubit>(create: (_) => OrderCubit(InjectionContainer.orderRepo)..getOrders()),
          BlocProvider<PaymentPreferenceCubit>(
            create: (_) => PaymentPreferenceCubit(),
          ),   
          BlocProvider<ProductCubit>(
           create: (_) => ProductCubit(
             InjectionContainer.productRepository,
           ),
         ),
          BlocProvider<CategoryCubit>(create: (_) => CategoryCubit(InjectionContainer.categoryRepository)), 
          BlocProvider<BrandCubit>(create: (_) => BrandCubit(InjectionContainer.brandRepository,)), 
          BlocProvider<UserCubit>(
          create: (_) => UserCubit(
          UserRepoImpl(FirebaseFirestore.instance ,   InjectionContainer.cloudinaryService,),
           ),
          ),
          BlocProvider<RegisterCubit>(
            create: (_) => RegisterCubit(InjectionContainer.authRepository),
          ),
          BlocProvider<AuthCubit>.value(value: authCubit),
        ],
        child: MyApp(appRouter: appRouter),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final GoRouter appRouter;
  const MyApp({required this.appRouter, super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: ThemeController.themeMode,
        builder: (context, currentThemeMode, _) {
          return MaterialApp.router(
            theme: AppThemes.lightTheme,
            darkTheme: AppThemes.darkTheme,
            themeMode: currentThemeMode,
            // Localization
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            // Router
            routerConfig: appRouter,
            debugShowCheckedModeBanner: false,
            debugShowMaterialGrid: false,
          );
        },
      ),
    );
  }
}
