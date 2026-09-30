import 'dart:async';
import 'package:e_commerce_delivery_app/features/driver/data/models/driver_model.dart';
import 'package:e_commerce_delivery_app/features/driver/data/models/driver_order_model.dart';
import 'package:e_commerce_delivery_app/features/driver/domain/driver_repository.dart';
import 'package:e_commerce_delivery_app/features/driver/presentations/cubit/states/driver_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DriverCubit extends Cubit<DriverState> {
  final DriverRepository _repository;

  StreamSubscription<DriverModel>? _driverSubscription;
  StreamSubscription<DriverOrderModel?>? _orderSubscription;

  DriverCubit(this._repository) : super(DriverInitial());

  Future<void> startDriver(String driverId) async {
    emit(DriverLoading());

    try {
      final driver = await _repository.getDriver(driverId);

      emit(
        DriverSuccess(
          driver: driver,
        ),
      );

      _listenToDriver(driverId);
      _listenToAssignedOrder(driverId);
    } catch (e) {
      emit(
        const DriverError(
          'something_went_wrong',
        ),
      );
    }
  }

  void _listenToDriver(String driverId) {
    _driverSubscription?.cancel();

    _driverSubscription = _repository
        .watchDriver(driverId)
        .listen((driver) {
      final currentState = state;

      DriverOrderModel? order;

      if (currentState is DriverSuccess) {
        order = currentState.order;
      }

      emit(
        DriverSuccess(
          driver: driver,
          order: order,
        ),
      );
    });
  }

  void _listenToAssignedOrder(String driverId) {
    _orderSubscription?.cancel();

    _orderSubscription = _repository
        .watchAssignedOrder(driverId)
        .listen((order) {
      final currentState = state;

      if (currentState is DriverSuccess) {
        emit(
          DriverSuccess(
            driver: currentState.driver,
            order: order,
          ),
        );
      }
    });
  }

  Future<void> updateOnlineStatus({
    required String driverId,
    required bool isOnline,
  }) async {
    try {
      await _repository.updateOnlineStatus(
        driverId: driverId,
        isOnline: isOnline,
      );
    } catch (e) {
      emit(
        const DriverError(
          'something_went_wrong',
        ),
      );
    }
  }
   Future<void> updateLocation({
  required String driverId,
  required double latitude,
  required double longitude,
}) async {
  try {
    await _repository.updateLocation(
      driverId: driverId,
      latitude: latitude,
      longitude: longitude,
    );
  } catch (e) {
    emit(const DriverError('something_went_wrong'));
  }
}
  Future<void> updateAvailability({
    required String driverId,
    required bool isAvailable,
  }) async {
    try {
      await _repository.updateAvailability(
        driverId: driverId,
        isAvailable: isAvailable,
      );
    } catch (e) {
      emit(
        const DriverError(
          'something_went_wrong',
        ),
      );
    }
  }
      
  Future<void> updateOrderStatus({
    required String userId,
    required String orderId,
    required String status,
  }) async {
    try {
      await _repository.updateOrderStatus(
        userId: userId,
        orderId: orderId,
        status: status,
      );
    } catch (e) {
      emit(
        const DriverError(
          'something_went_wrong',
        ),
      );
    }
  } 
  Future<void> completeOrder({
  required String userId,
  required String orderId,
}) async {
  try {
    await _repository.completeOrder(
      userId: userId,
      orderId: orderId,
    );
  } catch (e) {
    emit(const DriverError('something_went_wrong'));
  }
}
  @override
  Future<void> close() async {
    await _driverSubscription?.cancel();
    await _orderSubscription?.cancel();
    return super.close();
  }
}