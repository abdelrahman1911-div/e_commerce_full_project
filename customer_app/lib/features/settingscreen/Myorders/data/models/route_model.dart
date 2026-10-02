
import 'package:latlong2/latlong.dart';

class RouteModel {
  final double distanceInMeters ; 
  final double durationInSec; 
  final List<LatLng> points ; 

  const RouteModel({
    required this.distanceInMeters, 
    required this.durationInSec, 
    required this.points
  }); 

  double get distanceInKilometers {
    return distanceInMeters / 1000 ; 
  } 
  double get durationInMin {
    return durationInSec / 60 ; 
  }
}