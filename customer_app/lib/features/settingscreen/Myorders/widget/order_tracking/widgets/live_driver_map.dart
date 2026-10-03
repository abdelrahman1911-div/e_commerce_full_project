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

class _LiveDriverMapState extends State<LiveDriverMap>
    with SingleTickerProviderStateMixin {
  late final MapController _mapController;
  late final AnimationController _animationController;

  late LatLng _displayedPosition;
  LatLng? _animationStart;
  LatLng? _animationEnd;

  bool _hasCenteredOnce = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    _displayedPosition = LatLng(
      widget.location.latitude,
      widget.location.longitude,
    );

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..addListener(_onAnimationTick);
  }

  void _onAnimationTick() {
    if (_animationStart == null || _animationEnd == null) return;

    final t = Curves.easeInOut.transform(_animationController.value);

    final lat = _lerp(
      _animationStart!.latitude,
      _animationEnd!.latitude,
      t,
    );
    final lng = _lerp(
      _animationStart!.longitude,
      _animationEnd!.longitude,
      t,
    );

    final newPosition = LatLng(lat, lng);

    setState(() {
      _displayedPosition = newPosition;
    });

    // Keep the camera following the animated marker smoothly.
    if (_hasCenteredOnce) {
      _mapController.move(newPosition, _mapController.camera.zoom);
    }
  }

  double _lerp(double start, double end, double t) {
    return start + (end - start) * t;
  }

  @override
  void didUpdateWidget(covariant LiveDriverMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.location != widget.location) {
      final newPosition = LatLng(
        widget.location.latitude,
        widget.location.longitude,
      );

      _animationStart = _displayedPosition;
      _animationEnd = newPosition;

      _animationController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _animationController
      ..removeListener(_onAnimationTick)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasCenteredOnce) {
      _hasCenteredOnce = true;
    }

    final markers = <Marker>[
      Marker(
        point: _displayedPosition,
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
            initialCenter: _displayedPosition,
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