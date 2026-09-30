import 'package:e_commerce_delivery_app/features/driver/data/models/driver_model.dart';
import 'package:e_commerce_delivery_app/features/driver/data/models/driver_order_model.dart';

abstract class DriverRepository {
  Future<DriverModel> getDriver(String driverId);

  Stream<DriverModel> watchDriver(String driverId);

  Stream<DriverOrderModel?> watchAssignedOrder(String driverId);

  Future<void> updateOnlineStatus({
    required String driverId,
    required bool isOnline,
  });

  Future<void> updateAvailability({
    required String driverId,
    required bool isAvailable,
  });

  Future<void> updateOrderStatus({
    required String userId,
    required String orderId,
    required String status,
  }); 

  Future<void> updateLocation ({
    required String driverId, 
    required double latitude, 
    required double longitude,
  });
 Future<void> completeOrder({
  required String userId,
  required String orderId,
});
}