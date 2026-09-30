import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_admin/core/di/injection_container.dart';
import 'package:e_commerce_admin/core/router/app_router_configuration.dart';
import 'package:e_commerce_admin/core/styling/app_themes.dart';
import 'package:e_commerce_admin/features/Categoriesscreen/data/repos/category_repo_impl.dart';
import 'package:e_commerce_admin/features/Categoriesscreen/presentation/cubit/category_cubit.dart';
import 'package:e_commerce_admin/features/auth/presentations/cubit/auth_cubit.dart';
import 'package:e_commerce_admin/features/brand/data/repos/brands_repo_impl.dart';
import 'package:e_commerce_admin/features/brand/presentations/cubit/brand_cubit.dart';
import 'package:e_commerce_admin/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:e_commerce_admin/features/dashboard/dashboard_repo.dart';
import 'package:e_commerce_admin/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final authCubit = AuthCubit(authRepository);

  authCubit.checkAuth();

  final appRouter = createAppRouter(authCubit); 


  
  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: authCubit,
            ), 
            BlocProvider.value(value: driverCubit), 
            BlocProvider.value(
              value: orderCubit,
            ),
            BlocProvider<DashboardCubit>(
              create: (_) => DashboardCubit(
                DashboardRepositoryImpl(
                  FirebaseFirestore.instance,
                ),
              )..getDashboardStats(),
            ), 
            BlocProvider<CategoryCubit>(
  create: (_) => CategoryCubit(
    CategoryRepositoryImpl(
      FirebaseFirestore.instance,
    ),
  )..getAllCategories(),
),
            BlocProvider<BrandCubit>(
              create: (_) => BrandCubit(
                BrandRepositoryImpl(
                  FirebaseFirestore.instance,
                ),
              )..getAllBrands(),
            ),
          ],
          child: MyApp(
            appRouter: appRouter,
          ),
        );
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  final dynamic appRouter;

  const MyApp({
    super.key,
    required this.appRouter,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce Admin',
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
    );
  }
}