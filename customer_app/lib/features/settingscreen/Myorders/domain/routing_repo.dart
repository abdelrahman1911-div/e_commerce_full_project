import 'package:e_commerce_full_project/features/settingscreen/Myorders/data/models/route_model.dart';

abstract class RoutingRepo {
  Future<RouteModel> getRoute({
    required double driverLatitude,
    required double driverLongitude,
    required double destinationLatitude,
    required double destinationLongitude,
  });
}