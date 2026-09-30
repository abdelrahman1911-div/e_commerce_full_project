import 'package:e_commerce_delivery_app/features/driver/data/models/driver_model.dart';
import 'package:e_commerce_delivery_app/features/driver/data/models/driver_order_model.dart';
import 'package:equatable/equatable.dart';

abstract class DriverState extends Equatable {
  const DriverState();

  @override
  List<Object?> get props => [];
}

class DriverInitial extends DriverState {}

class DriverLoading extends DriverState {}

class DriverSuccess extends DriverState {
  final DriverModel driver;
  final DriverOrderModel? order;

  const DriverSuccess({
    required this.driver,
    this.order,
  });

  @override
  List<Object?> get props => [
        driver,
        order,
      ];
}

class DriverError extends DriverState {
  final String message;

  const DriverError(this.message);

  @override
  List<Object?> get props => [message];
}