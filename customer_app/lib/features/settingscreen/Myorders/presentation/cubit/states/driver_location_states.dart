import 'package:equatable/equatable.dart';

import 'package:e_commerce_full_project/features/settingscreen/Myorders/data/models/driver_location_model.dart';

abstract class DriverLocationState extends Equatable {
  const DriverLocationState();

  @override
  List<Object?> get props => [];
}

class DriverLocationInitial extends DriverLocationState {}

class DriverLocationLoading extends DriverLocationState {}

class DriverLocationSuccess extends DriverLocationState {
  final DriverLocationModel location;

  const DriverLocationSuccess(this.location);

  @override
  List<Object?> get props => [location];
}

class DriverLocationEmpty extends DriverLocationState {}

class DriverLocationError extends DriverLocationState {
  final String message;

  const DriverLocationError(this.message);

  @override
  List<Object?> get props => [message];
}