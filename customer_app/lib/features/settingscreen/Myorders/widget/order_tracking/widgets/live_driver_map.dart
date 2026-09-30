import 'package:e_commerce_full_project/features/settingscreen/Myorders/data/models/driver_location_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LiveDriverMap extends StatefulWidget {
  final DriverLocationModel location;

  const LiveDriverMap({
    super.key,
    required this.location,
  });

  @override
  State<LiveDriverMap> createState() => _LiveDriverMapState();
}

class _LiveDriverMapState extends State<LiveDriverMap> {
  late final MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void didUpdateWidget(covariant LiveDriverMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.location != widget.location) {
      final newPosition = LatLng(
        widget.location.latitude,
        widget.location.longitude,
      );

      _mapController.move(newPosition, _mapController.camera.zoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    final position = LatLng(
      widget.location.latitude,
      widget.location.longitude,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 280,
        width: double.infinity,
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: position,
            initialZoom: 15,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName:
                  'com.example.e_commerce_full_project',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: position,
                  width: 50,
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.delivery_dining,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}