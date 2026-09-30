import 'dart:async';

import 'package:e_commerce_full_project/features/settingscreen/Myorders/data/models/driver_location_model.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/domain/order_repo.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/presentation/cubit/states/driver_location_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverLocationCubit extends Cubit<DriverLocationState> {
  final OrderRepo _orderRepository;

  StreamSubscription<DriverLocationModel?>? _locationSubscription;

  String? _currentDriverId;

  DriverLocationCubit(this._orderRepository) : super(DriverLocationInitial());

  void watchDriverLocation(String driverId) {
    if (_currentDriverId == driverId && _locationSubscription != null) {
      return;
    }
     
    _locationSubscription?.cancel();

    _currentDriverId = driverId;

    emit(DriverLocationLoading());

_locationSubscription = _orderRepository
    .watchDriverLocation(driverId)
    .listen(
  (location) {
    if (location == null) {
      emit(DriverLocationEmpty());
      return;
    }

    emit(DriverLocationSuccess(location));
  },
  onError: (error) {
    emit(
      const DriverLocationError(
        'could_not_get_driver_location',
      ),
    );
  },
);
  }

  void stopWatching() {
    _locationSubscription?.cancel();

    _locationSubscription = null;

    _currentDriverId = null;

    emit(DriverLocationInitial());
  }

  @override
  Future<void> close() async {
    await _locationSubscription?.cancel();

    return super.close();
  }
}
