import 'dart:async';
import 'package:e_commerce_admin/core/di/injection_container.dart';
import 'package:e_commerce_admin/core/router/app_routes.dart';
import 'package:e_commerce_admin/features/Categoriesscreen/data/models/category_model.dart';
import 'package:e_commerce_admin/features/Categoriesscreen/presentation/screens/add_edit_screen.dart';
import 'package:e_commerce_admin/features/Categoriesscreen/presentation/screens/categories_screen.dart';
import 'package:e_commerce_admin/features/Myorders/data/models/orderModel.dart';
import 'package:e_commerce_admin/features/Myorders/presentation/screen/orders_details_screen.dart';
import 'package:e_commerce_admin/features/Myorders/presentation/screen/orders_screen.dart';
import 'package:e_commerce_admin/features/auth/presentations/cubit/auth_cubit.dart';
import 'package:e_commerce_admin/features/auth/presentations/cubit/auth_state.dart';
import 'package:e_commerce_admin/features/auth/presentations/screens/loginscreen.dart';
import 'package:e_commerce_admin/features/brand/data/models/brand_model.dart';
import 'package:e_commerce_admin/features/brand/presentations/screen/add_edit_brand.dart';
import 'package:e_commerce_admin/features/brand/presentations/screen/brand_screen.dart';
import 'package:e_commerce_admin/features/dashboard/dashboard_screen.dart';
import 'package:e_commerce_admin/features/delivery/presentation/screen/drivers_screen.dart' show DriverTestScreen;
import 'package:e_commerce_admin/features/product/data/model/product_model.dart';
import 'package:e_commerce_admin/features/product/presentation/screen/add_edit_screen.dart';
import 'package:e_commerce_admin/features/product/presentation/screen/products_screen.dart';
import 'package:e_commerce_admin/features/users/screens/create_user_screem.dart';
import 'package:e_commerce_admin/features/users/screens/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AuthRouterRefreshNotifier extends ChangeNotifier {
  late final StreamSubscription<AuthState> _authSubscription;

  final AuthCubit authCubit;

  AuthRouterRefreshNotifier(
    this.authCubit,
  ) {
    _authSubscription = authCubit.stream.listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _authSubscription.cancel();
    super.dispose();
  }
}

GoRouter createAppRouter(
  AuthCubit authCubit,
) {
  final refreshNotifier =
      AuthRouterRefreshNotifier(authCubit);

  return GoRouter(
    initialLocation: AppRoutes.login,

    refreshListenable: refreshNotifier,

    redirect: (context, state) {
      final authState = authCubit.state;

      final isLogin =
          state.matchedLocation == AppRoutes.login;

      if (authState is AuthInitial ||
          authState is AuthChecking ||
          authState is AuthLoading) {
        return null;
      }

      if (authState is AuthSuccess) {
        if (isLogin) {
          return AppRoutes.admin;
        }
        return null;
      }
      if (authState is AuthUnauthenticated) {
        if (!isLogin) {
          return AppRoutes.login;
        }

        return null;
      }

      if (authState is AuthError) {
        if (isLogin) {
          return null;
        }

        return AppRoutes.login;
      }

      return null;
    },

routes: [ 
GoRoute(
  path: AppRoutes.categories,
  builder: (context, state) {
    return const CategoriesScreen();
  },
),

GoRoute(
  path: AppRoutes.createCategory,
  builder: (context, state) {
    return const AddEditCategoryScreen();
  },
),
GoRoute(
  path: AppRoutes.brands,
  builder: (context, state) {
    return const BrandsScreen();
  },
),
GoRoute(
  path: AppRoutes.addEditBrand,
  builder: (context, state) {
    final brand = state.extra as AdminBrandModel?;
    return AddEditBrandScreen(
      brand: brand,
    );
  },
),
GoRoute(
  path: AppRoutes.editCategory,
  builder: (context, state) {
    final category =
        state.extra as AdminCategoryModel;
    return AddEditCategoryScreen(
      category: category,
    );
  },
),
 GoRoute(
        path: AppRoutes.drivers,
        builder: (context, state) {
          return const DriverTestScreen();
        },
      ),
  GoRoute(
    path: AppRoutes.login,
    builder: (context, state) {
      return const LoginScreen();
    },
  ),

  GoRoute(
    path: AppRoutes.admin,
    builder: (context, state) {
      return const AdminDashboardScreen();
    },
  ),

  GoRoute(
    path: AppRoutes.users,
    builder: (context, state) {
      return BlocProvider.value(
        value: usersCubit,
        child: const UsersScreen(),
      );
    },
  ),

  GoRoute(
    path: AppRoutes.createUser,
    builder: (context, state) {
      return BlocProvider.value(
        value: usersCubit,
        child: const CreateUserScreen(),
      );
    },
  ),

  GoRoute(
    path: AppRoutes.products,
    builder: (context, state) {
      return BlocProvider.value(
        value: productsCubit,
        child: const ProductsScreen(),
      );
    },
  ),

  GoRoute(
    path: AppRoutes.createProduct,
    builder: (context, state) {
      return BlocProvider.value(
        value: productsCubit,
        child: const ProductFormScreen(),
      );
    },
  ),

  GoRoute(
    path: AppRoutes.editProduct,
    builder: (context, state) {
      final product = state.extra as AdminProductModel;
      return BlocProvider.value(
        value: productsCubit,
        child: ProductFormScreen(
          product: product,
        ),
      );
    },
  ),
  GoRoute(
    path: AppRoutes.orders,
    builder: (context, state) {
      return const OrdersScreen();
    },
  ),

  GoRoute(
    path: AppRoutes.orderDetails,
    builder: (context, state) {
      final order = state.extra as OrderModel;

      return OrderDetailsScreen(
        order: order,
      );
    },
  ),
],

  );
}
