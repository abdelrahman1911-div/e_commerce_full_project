import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_full_project/core/helpers/cloudinaryservice/cloudinary_service.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/data/repos/category_repo_impl.dart';
import 'package:e_commerce_full_project/features/Categoriesscreen/domain/repo/category_repo.dart';
import 'package:e_commerce_full_project/features/auth/data/repos/auth_repo_impl.dart';
import 'package:e_commerce_full_project/features/auth/domain/repos/auth_repos.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/data/repos/brands_repo_impl.dart';
import 'package:e_commerce_full_project/features/brandscreen/brand/domain/repos/brands_repo.dart';
import 'package:e_commerce_full_project/features/home/favourite/data/repos/favourite_repo_impl.dart';
import 'package:e_commerce_full_project/features/home/favourite/domain/favourite_repo.dart';
import 'package:e_commerce_full_project/features/home/mycart/data/repo/cart_repo_impl.dart';
import 'package:e_commerce_full_project/features/home/mycart/domain/cart_repo.dart';
import 'package:e_commerce_full_project/features/home/product/data/repo/prod_repo_impl.dart';
import 'package:e_commerce_full_project/features/home/product/domain/prod_repo.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/data/repo/order_repo_impl.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/domain/order_repo.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/presentation/cubit/driver_location_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance; 
final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance; 
final BrandRepository brandRepository = BrandRepositoryImpl(firebaseFirestore,); 
final CategoryRepo categoryRepository = CategoryRepositoryImpl(firebaseFirestore);
final CloudinaryService cloudinaryService = CloudinaryService();  
final AuthRepository authRepository = AuthRepositoryImpl(
  firebaseAuth, firebaseFirestore , cloudinaryService
);  
final ProductRepository productRepository = ProductRepositoryImpl(firebaseFirestore);
final FavouriteRepository favouriteRepository = FavouriteRepositoryImpl(firebaseFirestore,firebaseAuth,); 
final CartRepository cartRepository = CartRepositoryImpl(firebaseFirestore, firebaseAuth); 
final OrderRepo orderRepo = OrderRepoImpl(firebaseFirestore, firebaseAuth); 