import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_full_project/core/helpers/cloudinaryservice/cloudinary_service.dart';
import 'package:e_commerce_full_project/features/auth/data/repos/auth_repo_impl.dart';
import 'package:e_commerce_full_project/features/auth/domain/repos/auth_repos.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance; 
final CloudinaryService cloudinaryService = CloudinaryService();  
final AuthRepository authRepository = AuthRepositoryImpl(
  firebaseAuth, firebaseFirestore , cloudinaryService
); 
