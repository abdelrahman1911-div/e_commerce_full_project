import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_admin/core/service/cloudinary_service.dart';
import 'package:e_commerce_admin/features/Categoriesscreen/data/repos/category_repo_impl.dart';
import 'package:e_commerce_admin/features/Categoriesscreen/presentation/cubit/category_cubit.dart';
import 'package:e_commerce_admin/features/Myorders/data/repo/order_repo_impl.dart';
import 'package:e_commerce_admin/features/Myorders/domain/order_repo.dart';
import 'package:e_commerce_admin/features/Myorders/presentation/cubit/order_cubit.dart';
import 'package:e_commerce_admin/features/auth/data/repos/auth_repo_impl.dart';
import 'package:e_commerce_admin/features/auth/domain/repos/auth_repos.dart';
import 'package:e_commerce_admin/features/brand/data/repos/brands_repo_impl.dart';
import 'package:e_commerce_admin/features/brand/presentations/cubit/brand_cubit.dart';
import 'package:e_commerce_admin/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:e_commerce_admin/features/dashboard/dashboard_repo.dart';
import 'package:e_commerce_admin/features/delivery/data/repo/driver_repo_impl.dart';
import 'package:e_commerce_admin/features/delivery/domain/driver_repo.dart';
import 'package:e_commerce_admin/features/delivery/presentation/cubit/driver_cubit.dart';
import 'package:e_commerce_admin/features/product/data/repo/prod_repo_impl.dart';
import 'package:e_commerce_admin/features/product/domain/prod_repo.dart';
import 'package:e_commerce_admin/features/product/presentation/cubit/prod_cubit.dart';
import 'package:e_commerce_admin/features/users/cubit/user_cubit.dart';
import 'package:e_commerce_admin/features/users/data/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth firebaseAuth =
    FirebaseAuth.instance;

final FirebaseFirestore firebaseFirestore =
    FirebaseFirestore.instance;

final CategoryRepository categoryRepository =
    CategoryRepositoryImpl(firebaseFirestore);

final CategoryCubit categoryCubit =
    CategoryCubit(categoryRepository);

final AuthRepository authRepository =
    AuthRepositoryImpl(
  firebaseAuth,
  firebaseFirestore,
);

final OrderRepository orderRepository =
    OrderRepositoryImpl(firebaseFirestore);

final OrderCubit orderCubit =
    OrderCubit(orderRepository);

final DashboardRepository dashboardRepository =
    DashboardRepositoryImpl(
  firebaseFirestore,
);

final DashboardCubit dashboardCubit =
    DashboardCubit(
  dashboardRepository,
);

final UsersRepository usersRepository =
    UsersRepositoryImpl(
  firebaseFirestore,
  firebaseAuth,
);

final UsersCubit usersCubit =
    UsersCubit(
  usersRepository,
); 

final ProductsRepository productsRepository =
    ProductsRepositoryImpl(
  firebaseFirestore,
);

final ProductsCubit productsCubit =
    ProductsCubit(
  productsRepository,
); 

final CloudinaryService cloudinaryService =
    CloudinaryService(); 

final BrandRepository brandRepository =
    BrandRepositoryImpl(
  firebaseFirestore,
);

final BrandCubit brandCubit =
    BrandCubit(
  brandRepository,
); 
final DriverRepository driverRepository = DriverRepoImpl(firebaseFirestore); 
final DriverCubit driverCubit = DriverCubit(driverRepository); 