import 'package:e_commerce_admin/features/delivery/data/model/Admin_driver_model.dart';

abstract class DriverState {}

class DriverInitial extends DriverState {}

class DriverLoading extends DriverState {}

class DriverSuccess extends DriverState {
  final List<AdminDriverModel> drivers;

  DriverSuccess(this.drivers);
}

class DriverError extends DriverState {
  final String message;

  DriverError(this.message);
}