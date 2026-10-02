import 'package:geocoding/geocoding.dart';

class GeocodingService { 
 static final geocoding = Geocoding(); 
  static Future<Location?> getLocationFromAddress(
    String address,
  ) async {
    if (address.trim().isEmpty) {
      return null;
    }
        
    try {
      final locations = await geocoding.locationFromAddress(address); 

      if (locations == null || locations.isEmpty) {
        return null;
      }

      return locations.first;
    } catch (e) {
      return null;
    }
  }
}
