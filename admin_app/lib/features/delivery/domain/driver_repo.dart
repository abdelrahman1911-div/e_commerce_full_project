import 'package:e_commerce_admin/features/delivery/data/model/Admin_driver_model.dart';

abstract class DriverRepository {
  Future<List<AdminDriverModel>> getAvailableDrivers();
}