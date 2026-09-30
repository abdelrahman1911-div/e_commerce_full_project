import 'package:equatable/equatable.dart';

class DriverLocationModel extends Equatable {
  final double latitude ; 
  final double longitude ; 

  const DriverLocationModel ({required this.latitude , required this.longitude}); 

  factory DriverLocationModel.fromJson(Map<String , dynamic > json ) {
    return DriverLocationModel(latitude: (json['latitude'] as num ).toDouble(), longitude: (json['longitude'] as num ).toDouble());  
  }

  @override
  List<Object?> get props => [latitude , longitude]; 

}