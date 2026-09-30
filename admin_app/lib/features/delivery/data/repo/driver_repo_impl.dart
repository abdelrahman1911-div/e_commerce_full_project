import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_admin/features/delivery/data/model/Admin_driver_model.dart';
import 'package:e_commerce_admin/features/delivery/domain/driver_repo.dart';

class DriverRepoImpl implements DriverRepository {
  final FirebaseFirestore _firestore; 
  DriverRepoImpl(this._firestore);  
  @override  
  Future<List<AdminDriverModel>> getAvailableDrivers () async { 
    final snapshot = await _firestore.collection('drivers').where('isOnline', isEqualTo: true).where("isAvailable" , isEqualTo: true ).get(); 
    return snapshot.docs.map((doc) =>  AdminDriverModel.fromJson(doc.data()), 
     ).toList(); 
  }
}