import 'package:e_commerce_full_project/core/services/routing_services.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/data/models/route_model.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/domain/routing_repo.dart';
import 'package:latlong2/latlong.dart';

class RoutingRepoImpl implements RoutingRepo {
  final RoutingService _routingService;

  RoutingRepoImpl(this._routingService);
      
  @override
  Future<RouteModel> getRoute({
    required double driverLatitude,
    required double driverLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
  }) async {
    return await _routingService.getRoute(
      driverLocation: LatLng(
        driverLatitude,
        driverLongitude,
      ),
      destination: LatLng(
        destinationLatitude,
        destinationLongitude,
      ),
    );
  }
}