import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_delivery_app/features/driver/data/models/driver_model.dart';
import 'package:e_commerce_delivery_app/features/driver/data/models/driver_order_model.dart';
import 'package:e_commerce_delivery_app/features/driver/domain/driver_repository.dart';

class DriverRepositoryImpl implements DriverRepository {
  final FirebaseFirestore _firestore;

  DriverRepositoryImpl(this._firestore);

  @override
  Future<DriverModel> getDriver(String driverId) async {
    final doc = await _firestore
        .collection('drivers')
        .doc(driverId)
        .get();

    if (!doc.exists) {
      throw Exception('driver_not_found');
    }

  return DriverModel.fromJson({
  ...doc.data()!,
  'id': doc.id,
});
  }

  @override
  Stream<DriverModel> watchDriver(String driverId) {
    return _firestore
        .collection('drivers')
        .doc(driverId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) {
        throw Exception('driver_not_found');
      }

     return DriverModel.fromJson({
  ...doc.data()!,
  'id': doc.id,
});
    });
  }

@override
Stream<DriverOrderModel?> watchAssignedOrder(String driverId) {
  print('QUERY DRIVER ID: $driverId');

  return _firestore
      .collectionGroup('orders')
      .where('driverId', isEqualTo: driverId)
      .where('status', isEqualTo: 'shipping')
      .limit(1)
      .snapshots()
      .map((snapshot) {
        print('ORDERS FOUND: ${snapshot.docs.length}');

        for (final doc in snapshot.docs) {
          print('ORDER ID: ${doc.id}');
          print('ORDER DATA: ${doc.data()}');
        }

        if (snapshot.docs.isEmpty) {
          return null;
        }

        return DriverOrderModel.fromJson(
          snapshot.docs.first,
        );
      });
}

  @override
  Future<void> updateOnlineStatus({
    required String driverId,
    required bool isOnline,
  }) async {
    await _firestore
        .collection('drivers')
        .doc(driverId)
        .update({
      'isOnline': isOnline,
    });
  }

  @override
  Future<void> updateAvailability({
    required String driverId,
    required bool isAvailable,
  }) async {
    await _firestore
        .collection('drivers')
        .doc(driverId)
        .update({
      'isAvailable': isAvailable,
    });
  }

  @override
  Future<void> updateOrderStatus({
    required String userId,
    required String orderId,
    required String status,
  }) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('orders')
        .doc(orderId)
        .update({
      'status': status,
    });
  } 

  @override 
  Future<void> updateLocation ({
   required String driverId, 
   required double latitude, 
   required double longitude, 
  }) async {
   await _firestore.collection('drivers').doc(driverId).update({
    'latitude' : latitude ,
    'longitude' : longitude,  
   });
  }  
  Future <void> completeOrder ({required String userId , required String orderId}) async { 
    await _firestore.collection('users').doc(userId).collection('orders').doc(orderId).update({
     'status' : 'delivered', 
     'paymentStatus' : 'paid', 
     'deliveredAt' : FieldValue.serverTimestamp(), 
    });
  }

}