import 'package:e_commerce_admin/features/Myorders/data/models/orderModel.dart';
import 'package:e_commerce_admin/features/Myorders/data/models/order_user_model.dart';

abstract class OrderRepository {
  Future<List<OrderModel>> getAllOrders();

  Future<OrderModel?> getOrderById({
    required String userId,
    required String orderId,
  });

  Future<OrderUserModel?> getOrderUser({
    required String userId,
  });

  Future<void> updateOrderStatus({
    required String userId,
    required String orderId,
    required String status,
  }); 

  Future<void> assignDriverToOrder ({
    required String userId ,
    required String orderId , 
    required String driverId, 
    required String driverName,
  }); 
}
