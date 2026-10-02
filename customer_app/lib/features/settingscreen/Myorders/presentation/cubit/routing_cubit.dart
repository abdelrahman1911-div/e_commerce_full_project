import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import 'package:e_commerce_full_project/features/settingscreen/Myorders/domain/routing_repo.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/presentation/cubit/states/routing_states.dart';

class RoutingCubit extends Cubit<RoutingState> {
  final RoutingRepo _routingRepo;

  RoutingCubit(this._routingRepo)
      : super(const RoutingInitial());

  Future<void> getRoute({
    required LatLng driverLocation,
    required LatLng destination,
  }) async {
    try {
      emit(const RoutingLoading());

      final route = await _routingRepo.getRoute(
        driverLatitude: driverLocation.latitude,
        driverLongitude: driverLocation.longitude,
        destinationLatitude: destination.latitude,
        destinationLongitude: destination.longitude,
      );

      emit(RoutingSuccess(route));
    } catch (e) {
      emit(
        RoutingError(
          e.toString(),
        ),
      );
    }
  }

  void reset() {
    emit(const RoutingInitial());
  }
}
