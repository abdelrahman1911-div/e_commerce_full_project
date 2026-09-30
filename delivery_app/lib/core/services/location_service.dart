import 'package:location/location.dart';

class LocationService {
  static final Location _location = Location();

  static Future<bool> requestPermission() async {
    var permission = await _location.hasPermission();

    if (permission == PermissionStatus.denied) {
      permission = await _location.requestPermission();
    }

    return permission == PermissionStatus.granted ||
        permission == PermissionStatus.grantedLimited;
  }

  static Future<bool> startTracking() async {
    final permissionGranted = await requestPermission();

    if (!permissionGranted) {
      return false;
    }

    final serviceEnabled = await _location.serviceEnabled();

    if (!serviceEnabled) {
      final enabled = await _location.requestService();

      if (!enabled) {
        return false;
      }
    }

    try {
      final backgroundEnabled =
          await _location.enableBackgroundMode(
        enable: true,
      );

      if (!backgroundEnabled) {
        return false;
      }
    } catch (e) {
      return false;
    }

    await _location.changeSettings(
      accuracy: LocationAccuracy.high,
      interval: 5000,
      distanceFilter: 5,
      backgroundInterval: 5000,
    );

    return true;
  }

  static Stream<LocationData> get locationStream {
    return _location.onLocationChanged;
  }

  static Future<void> stopTracking() async {
    try {
      await _location.enableBackgroundMode(
        enable: false,
      );
    } catch (_) {}
  }
}