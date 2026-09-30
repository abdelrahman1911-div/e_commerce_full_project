import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_delivery_app/features/auth/data/repo/auth_repo_impl.dart';
import 'package:e_commerce_delivery_app/features/auth/domain/auth_repos.dart';
import 'package:e_commerce_delivery_app/features/auth/presentation/cubit/cubit/auth_cubit.dart';
import 'package:e_commerce_delivery_app/features/driver/data/repo/driver_data_impl.dart';
import 'package:e_commerce_delivery_app/features/driver/domain/driver_repository.dart';
import 'package:e_commerce_delivery_app/features/driver/presentations/cubit/driver_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InjectionContainer {
   static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

   static final FirebaseFirestore firestore =
      FirebaseFirestore.instance;

   static final AuthRepository authRepository = AuthRepositoryImpl(firebaseAuth,firestore,);

   static AuthCubit get authCubit => AuthCubit(authRepository,); 
   static final DriverRepository driverRepository =  DriverRepositoryImpl( firestore,); 
   static DriverCubit get driverCubit => DriverCubit(driverRepository); 
}