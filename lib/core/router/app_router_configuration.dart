import 'package:e_commerce_full_project/core/router/app_routes.dart';
import 'package:e_commerce_full_project/features/All_categories_brands/all_categorise_screen.dart';
import 'package:e_commerce_full_project/features/All_categories_brands/all_Item_screen.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/categorise_screen.dart';
import 'package:e_commerce_full_project/features/CheckOut/checkout_screen.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/myorders_screen.dart';
import 'package:e_commerce_full_project/features/settingscreen/PaymentPerf/paymentPerferences_screen.dart';
import 'package:e_commerce_full_project/features/settingscreen/addressScreen/address_screen.dart';
import 'package:e_commerce_full_project/features/auth/presentations/screens/loginscreen.dart';
import 'package:e_commerce_full_project/features/auth/register/presentation/register_screen.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand_screen.dart';
import 'package:e_commerce_full_project/features/changepassword/change_password_screen.dart';
import 'package:e_commerce_full_project/features/home/favourite/favourite_screen.dart';

// ==================== AUTH IMPORTS (COMMENTED OUT) ====================
// import 'package:e_commerce_full_project/features/auth/data/repos/auth_repo_impl.dart';
// import 'package:e_commerce_full_project/features/auth/presentations/cubit/auth_cubit.dart';
// import 'package:e_commerce_full_project/features/auth/presentations/cubit/auth_state.dart';
// import 'package:e_commerce_full_project/features/auth/presentations/screens/loginscreen.dart';
// import 'package:e_commerce_full_project/features/auth/register/cubit/register_cubit.dart';
// import 'package:e_commerce_full_project/features/auth/register/presentation/register_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';

import 'package:e_commerce_full_project/features/home/homescreen.dart';
import 'package:e_commerce_full_project/features/home/mycart/mycart_screen.dart';
import 'package:e_commerce_full_project/features/home/product/product_details_screen.dart';
import 'package:e_commerce_full_project/features/home/product/product_model.dart';
import 'package:e_commerce_full_project/features/home/profile/profile_screen.dart';
import 'package:e_commerce_full_project/features/onboarding/onboarding_screen.dart';
import 'package:e_commerce_full_project/features/CheckOut/order_success/order_success_screen.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/order_tracking/order_tracking.dart';
import 'package:e_commerce_full_project/features/settingscreen/personalinfo/personal_information.dart';
import 'package:e_commerce_full_project/features/settingscreen/settingscreen.dart';
import 'package:e_commerce_full_project/features/splashscreen/splash_screen.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter(/* AuthCubit authCubit */ bool onboardingComplete) {
  return GoRouter(
    initialLocation: AppRoutes.splash, // يبدأ أوتوماتيك من الصفحة الرئيسية
    // ==================== AUTH ROUTING & REDIRECT (COMMENTED OUT) ====================
    // initialLocation: _getInitialLocation(authCubit.state),
    // refreshListenable: AuthRouterRefreshNotifier(authCubit),
    // redirect: (context, state) {
    //   final authState = authCubit.state;
    //   final isLogin = state.matchedLocation == AppRoutes.login;
    //   final isRegister = state.matchedLocation == AppRoutes.register;
    //
    //   if (authState is! AuthSuccess) {
    //     if (!isLogin && !isRegister) {
    //       return AppRoutes.login;
    //     }
    //     return null;
    //   }
    //
    //   if (isLogin || isRegister) {
    //     if (authState.user.role == 'admin') {
    //       return AppRoutes.admin;
    //     }
    //     return AppRoutes.home;
    //   }
    //
    //   return null;
    // },
    routes: [
      // ==================== AUTH ROUTES (COMMENTED OUT) ====================
      // GoRoute(
      //   path: AppRoutes.login,
      //   builder: (context, state) => const LoginScreen(),
      // ),
      // GoRoute(
      //   path: AppRoutes.register,
      //   builder: (context, state) => BlocProvider(
      //     create: (context) => RegisterCubit(
      //       AuthRepositoryImpl(
      //         FirebaseAuth.instance,
      //         FirebaseFirestore.instance,
      //       ),
      //     ),
      //     child: const RegisterScreen(),
      //   ),
      // ), 

      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) {
          return SplashScreen(onboardingComplete: onboardingComplete);
        },
      ),

      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.checkOut,
        builder: (context, state) => CheckoutScreen(),
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

        builder: (context, state) => AllCategoriesScreen(),
      ),

      GoRoute(
        path: AppRoutes.allItems,

        builder: (context, state) {
          final products = state.extra as List<ProductModel>;

          return AllItemsScreen(productsList: products);
        },
      ),

      GoRoute(
        path: AppRoutes.register,

        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.AddressScreen,

        builder: (context, state) => const AddressScreen(),
      ),

      GoRoute(
        path: AppRoutes.MyOrdersScreen,

        builder: (context, state) => const MyOrdersScreen(),
      ),

      GoRoute(
        path: AppRoutes.PayPerf,

        builder: (context, state) => const PaymentPreferenceScreen(),
      ),

      GoRoute(
        path: AppRoutes.settingScreen,

        builder: (context, state) => SettingsScreen(),
      ),
      ///////////
      GoRoute(
        path: AppRoutes.personalInformation,

        builder: (context, state) => const PersonalInformationScreen(),
      ),
      GoRoute(
        path: AppRoutes.changepass,

        builder: (context, state) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: AppRoutes.brand, 
        builder: (context, state) => BrandScreen(),
        ),
      GoRoute(
        path: AppRoutes.categorise,
        builder: (context, state) {
          return const CategoriseScreen();
        },
      ),
      GoRoute(
        path: AppRoutes.home,

        name: "home",

        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.cart,

        builder: (context, state) => const MycartScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,

        builder: (context, state) => const ProfileScreen(),
      ),

      GoRoute(
        path: AppRoutes.favourites,

        builder: (context, state) => const FavouriteScreen(),
      ),

      GoRoute(
        path: AppRoutes.product,

        builder: (context, state) {
          final product = state.extra as ProductModel;

          return ProductDetailsScreen(product: product);
        },
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
    ],
  );
}

// ==================== AUTH HELPERS (COMMENTED OUT) ====================
// String _getInitialLocation(AuthState state) {
//   if (state is AuthSuccess) {
//     return state.user.role == 'admin' ? AppRoutes.admin : AppRoutes.home;
//   }
//   return AppRoutes.login;
// }

// class AuthRouterRefreshNotifier extends ChangeNotifier {
//   late final StreamSubscription _subscription;
//
//   AuthRouterRefreshNotifier(AuthCubit authCubit) {
//     _subscription = authCubit.stream.listen((_) {
//       notifyListeners();
//     });
//   }
//
//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
// }
