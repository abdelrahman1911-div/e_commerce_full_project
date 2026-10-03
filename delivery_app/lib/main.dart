import 'package:e_commerce_delivery_app/core/di/injection_container.dart';
import 'package:e_commerce_delivery_app/core/routing/app_router_config.dart';
import 'package:e_commerce_delivery_app/features/auth/domain/auth_repos.dart';
import 'package:e_commerce_delivery_app/features/auth/presentation/cubit/cubit/auth_cubit.dart';
import 'package:e_commerce_delivery_app/features/driver/domain/driver_repository.dart';
import 'package:e_commerce_delivery_app/features/driver/presentations/cubit/driver_cubit.dart';
import 'package:e_commerce_delivery_app/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final authCubit = AuthCubit(
    InjectionContainer.authRepository,
  );
  final router = AppRouter.createRouter(authCubit);
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(
          value: InjectionContainer.authRepository,
        ),
        RepositoryProvider<DriverRepository>.value(
          value: InjectionContainer.driverRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>.value(
            value: authCubit,
          ),
          BlocProvider<DriverCubit>(
            create: (context) => DriverCubit(
              context.read<DriverRepository>(),
            ),
          ),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            routerConfig: router,
            title: 'Delivery App',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
              ),
              useMaterial3: true,
            ),
          ),
        ),
      ),
    ),
  );
}