import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_admin/features/Myorders/data/models/orderModel.dart';
import 'package:e_commerce_admin/features/Myorders/data/models/order_user_model.dart';
import 'package:e_commerce_admin/features/Myorders/domain/order_repo.dart';

class OrderRepositoryImpl implements OrderRepository {
  final FirebaseFirestore _firestore;

  OrderRepositoryImpl(
    this._firestore,
  );

  CollectionReference<Map<String, dynamic>>
      _ordersCollection(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('orders');
  }

  @override
  Future<List<OrderModel>> getAllOrders() async {
    final usersSnapshot =
        await _firestore.collection('users').get();

    final List<OrderModel> allOrders = [];

    for (final userDoc in usersSnapshot.docs) {
      final ordersSnapshot =
          await _ordersCollection(userDoc.id).get();

      for (final orderDoc in ordersSnapshot.docs) {
        final data = orderDoc.data();

        final orderData = Map<String, dynamic>.from(data);

        orderData['id'] =
            orderData['id']?.toString().isNotEmpty == true
                ? orderData['id']
                : orderDoc.id;

        final order = OrderModel.fromJson(
          orderData,
          userId: userDoc.id,
        );

        allOrders.add(order);
      }
    }

    allOrders.sort(
      (a, b) => b.date!.compareTo(a.date!),
    );

    return allOrders;
  }

  @override
  Future<OrderModel?> getOrderById({
    required String userId,
    required String orderId,
  }) async {
    final doc =
        await _ordersCollection(userId)
            .doc(orderId)
            .get();

    if (!doc.exists) {
      return null;
    }

    final data = doc.data();

    if (data == null) {
      return null;
    }

    final orderData =
        Map<String, dynamic>.from(data);

    orderData['id'] =
        orderData['id']?.toString().isNotEmpty == true
            ? orderData['id']
            : doc.id;

    return OrderModel.fromJson(
      orderData,
      userId: userId,
    );
  }

  @override
  Future<OrderUserModel?> getOrderUser({
    required String userId,
  }) async {
    final doc =
        await _firestore
            .collection('users')
            .doc(userId)
            .get();

    if (!doc.exists) {
      return null;
    }

    final data = doc.data();

    if (data == null) {
      return null;
    }

    return OrderUserModel.fromMap(
      uid: userId,
      data: data,
    );
  }

  @override
  Future<void> updateOrderStatus({
    required String userId,
    required String orderId,
    required String status,
  }) async {
    await _ordersCollection(userId)
        .doc(orderId)
        .update({
      'status': status,
    });
  } 

  Future <void> assignDriverToOrder ({
    required String userId , 
    required String orderId, 
    required String driverId, 
    required String driverName, 
  }) async {

    final orderRef = _ordersCollection(userId).doc(orderId); 

    final driverRef = _firestore.collection('drivers').doc(driverId); 

    await _firestore.runTransaction((transaction) async {
        final ordersSnapshot = await transaction.get(orderRef); 

        final driverSnapshot = await transaction.get(driverRef); 

        if(!ordersSnapshot.exists){
          throw Exception('Order not found');
        }  

        if(!driverSnapshot.exists){
          throw Exception('Driver not found');
        }  

        final driverData = driverSnapshot.data(); 

        if(driverData == null ) {
          throw Exception('Driver data not found');
        }
          
        final isOnline = driverData['isOnline'] as bool? ?? false ; 

        final isAvailable =  driverData['isAvailable'] as bool? ?? false ; 

        if (!isOnline) {
        throw Exception(
          'Driver is not online',
        );
      }

      if (!isAvailable) {
        throw Exception(
          'Driver is no longer available',
        );
      }  
      transaction.update(orderRef,
           {
            'driverId' : driverId , 
            'driverName' : driverName, 
            'assignedAt' : FieldValue.serverTimestamp(),  
           }, 
        );    
     transaction.update(driverRef, {
         'currentOrderId' : orderId, 
         'isAvailable' : false , 
         'assignedAt' : FieldValue.serverTimestamp(), 
     }); 
    },); 
  }
}
