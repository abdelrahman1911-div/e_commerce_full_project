import 'package:dio/dio.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/data/models/route_model.dart';
import 'package:latlong2/latlong.dart';

class RoutingService {
  final Dio dio;

  RoutingService(this.dio);

  static const String _baseUrl =
      'https://router.project-osrm.org/route/v1/driving';

  Future<RouteModel> getRoute({
    required LatLng driverLocation,
    required LatLng destination,
  }) async {
    final response = await dio.get(
      '$_baseUrl/'
      '${driverLocation.longitude},${driverLocation.latitude};'
      '${destination.longitude},${destination.latitude}',
      queryParameters: {
        'overview': 'full',
        'geometries': 'geojson',
      },
    );

    final data = response.data as Map<String, dynamic>;

    if (data['code'] != 'Ok') {
      throw Exception('Route not found');
    }

    final routes = data['routes'] as List<dynamic>;

    if (routes.isEmpty) {
      throw Exception('No route available');
    }

    final route = routes.first as Map<String, dynamic>;

    final geometry =
        route['geometry'] as Map<String, dynamic>;

    final coordinates =
        geometry['coordinates'] as List<dynamic>;

    final points = coordinates.map((coordinate) {
      final point = coordinate as List<dynamic>;

      return LatLng(
        (point[1] as num).toDouble(),
        (point[0] as num).toDouble(),
      );
    }).toList();

    return RouteModel(
      distanceInMeters:
          (route['distance'] as num).toDouble(),
      durationInSec:
          (route['duration'] as num).toDouble(), 
          points: points, 
    );
  }
}