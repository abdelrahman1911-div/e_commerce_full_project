
import 'package:e_commerce_full_project/features/settingscreen/Myorders/data/models/driver_location_model.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/data/models/orderModel.dart';

abstract class OrderRepo {
  Future<void> addOrder(OrderModel order);

  Future<List<OrderModel>> getOrders();

  Future<OrderModel?> getOrderById(String orderId);

  Future<void> removeOrder(String orderId);

  Future<void> clearOrders();

  Stream<List<OrderModel>> watchOrders();

Stream<DriverLocationModel?> watchDriverLocation(String driverId); 

}