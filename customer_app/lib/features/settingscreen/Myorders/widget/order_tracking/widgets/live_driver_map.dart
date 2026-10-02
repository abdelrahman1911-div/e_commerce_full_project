import 'package:e_commerce_full_project/features/settingscreen/Myorders/data/models/driver_location_model.dart';
import 'package:e_commerce_full_project/features/settingscreen/Myorders/data/models/route_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LiveDriverMap extends StatefulWidget {
  final DriverLocationModel location;
  final LatLng? destination;
  final RouteModel? route;

  const LiveDriverMap({
    super.key,
    required this.location,
    this.destination,
    this.route,
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

      _mapController.move(
        newPosition,
        _mapController.camera.zoom,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final driverPosition = LatLng(
      widget.location.latitude,
      widget.location.longitude,
    );

    final markers = <Marker>[
      Marker(
        point: driverPosition,
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
    ];

    if (widget.destination != null) {
      markers.add(
        Marker(
          point: widget.destination!,
          width: 50,
          height: 50,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 3,
              ),
            ),
            child: const Icon(
              Icons.location_on,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 280,
        width: double.infinity,
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: driverPosition,
            initialZoom: 15,
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName:
                  'com.example.e_commerce_full_project',
            ),
            if (widget.route != null)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: widget.route!.points,
                    strokeWidth: 5,
                    color: Colors.blue,
                  ),
                ],
              ),
            MarkerLayer(
              markers: markers,
            ),
          ],
        ),
      ),
    );
  }
}