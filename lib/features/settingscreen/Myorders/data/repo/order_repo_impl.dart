import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/data/models/orderModel.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/domain/order_repo.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderRepoImpl implements OrderRepo {
  final FirebaseFirestore _fireStore;
  final FirebaseAuth _firebaseAuth; 
  OrderRepoImpl(this._fireStore , this._firebaseAuth); 

  CollectionReference<Map<String, dynamic>> get _ordersCollection  {
    final uid =  _firebaseAuth.currentUser?.uid;  
    if(uid == null ) {
      throw Exception("No authenticated user found");
    } 
    return _fireStore.collection('users').doc(uid).collection('orders'); 
  } 

  @override 
  Future<void> addOrder(OrderModel order) async {
     await _ordersCollection.doc(order.id).set(order.toJson()); 
  } 
  @override 
  Future<List<OrderModel>> getOrders () async { 
     final snapshot = await _ordersCollection.orderBy('date',descending: true).get(); 
     return snapshot.docs.map((doc) {
      return OrderModel.fromJson({
      ...doc.data(), 
       'id' : doc.id,    
      });
     }).toList();      
  }   
  
  @override
  Future<OrderModel?> getOrderById (String orderId) async {
    final doc = await _ordersCollection.doc(orderId).get(); 
    if(!doc.exists || doc.data() == null ) {
      return null ; 
    }  
    return OrderModel.fromJson({
    ...doc.data()!, 
    'id' : doc.id 
    });
  } 

  @override 
  Future<void> removeOrder (String orderId ) async {
    await _ordersCollection.doc(orderId).delete(); 
  } 

  @override 
  Future <void> clearOrders () async {
    final snapshot = await _ordersCollection.get(); 
    if(snapshot.docs.isEmpty){ 
      return ; 
    } 
    final batch = _fireStore.batch();  
    for(final doc in snapshot.docs){
      batch.delete(doc.reference); 
    }
    await batch.commit(); 
  } 


}