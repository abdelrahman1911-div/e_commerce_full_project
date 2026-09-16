import 'package:e_commerce_full_project/features/home/homescreen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final MapController mapController = MapController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  LatLng? selectedLocation;

  String selectedAddress = 'select_location_from_map';

  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  // ===========================================================
  // GET CURRENT LOCATION
  // ===========================================================

  Future<void> _getCurrentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
          selectedAddress = 'please_enable_location_services';
        });

        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
          selectedAddress = 'location_permission_denied';
        });

        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;

        setState(() {
          isLoading = false;
          selectedAddress = 'location_permission_permanently_denied';
        });

        return;
      }

      final position = await Geolocator.getCurrentPosition();

      final location = LatLng(position.latitude, position.longitude);

      if (!mounted) return;

      setState(() {
        selectedLocation = location;
        isLoading = false;
      });

      await _getAddressFromLocation(location);

      if (mounted) {
        mapController.move(location, 16);
      }
    } catch (e) {
      debugPrint('Location Error: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
        selectedAddress = 'unable_to_get_location';
      });
    }
  }

  // ===========================================================
  // GET ADDRESS FROM LAT/LNG
  // ===========================================================

  Future<void> _getAddressFromLocation(LatLng location) async {
    try {
      final placemarks = await Geocoding().placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isEmpty) {
        if (!mounted) return;

        setState(() {
          selectedAddress = 'address_not_found';
        });

        return;
      }

      final place = placemarks.first;

      final addressParts = <String>[
        if (place.street?.trim().isNotEmpty ?? false) place.street!,

        if (place.subLocality?.trim().isNotEmpty ?? false) place.subLocality!,

        if (place.locality?.trim().isNotEmpty ?? false) place.locality!,

        if (place.administrativeArea?.trim().isNotEmpty ?? false)
          place.administrativeArea!,

        if (place.country?.trim().isNotEmpty ?? false) place.country!,
      ];

      final address = addressParts.join(', ');

      if (!mounted) return;

      setState(() {
        selectedAddress = address.isNotEmpty ? address : 'address_not_found';
      });
    } catch (e) {
      debugPrint('Geocoding Error: $e');

      if (!mounted) return;

      setState(() {
        selectedAddress = 'unable_to_get_address';
      });
    }
  }

  // ===========================================================
  // MAP TAP
  // ===========================================================

  Future<void> _onMapTap(TapPosition tapPosition, LatLng location) async {
    setState(() {
      selectedLocation = location;
    });

    await _getAddressFromLocation(location);
  }

  // ===========================================================
  // USE CURRENT LOCATION
  // ===========================================================

  Future<void> _useCurrentLocation() async {
    setState(() {
      isLoading = true;
    });

    await _getCurrentLocation();

    if (selectedLocation != null && mounted) {
      mapController.move(selectedLocation!, 16);
    }
  }

  // ===========================================================
  // SAVE ADDRESS
  // ===========================================================

  Future<void> _saveAddress() async {
    if (selectedLocation == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('please_select_location'.tr())));

      return;
    }

    final user = _auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No authenticated user found.')),
      );

      return;
    }

    if (selectedAddress == 'select_location_from_map') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('please_select_location'.tr())));

      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final latitude = selectedLocation!.latitude;

      final longitude = selectedLocation!.longitude;

      // ==========================================
      // SAVE LOCATION TO FIRESTORE
      // ==========================================

      await _firestore.collection('users').doc(user.uid).update({
        'address': selectedAddress,
        'latitude': latitude,
        'longitude': longitude,
        'addressUpdatedAt': FieldValue.serverTimestamp(),
      });
      debugPrint('==============================');
      debugPrint('ADDRESS SAVED SUCCESSFULLY');
      debugPrint('User ID: ${user.uid}');
      debugPrint('Address: $selectedAddress');
      debugPrint('Latitude: $latitude');
      debugPrint('Longitude: $longitude');
      debugPrint('==============================');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text('address_saved_successfully'.tr()),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      debugPrint('Save Address Error: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Unable to save address: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  // ===========================================================
  // BUILD
  // ===========================================================

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text('my_address'.tr())),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // =================================================
                // MAP
                // =================================================
                Expanded(
                  flex: 5,
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController: mapController,

                        options: MapOptions(
                          initialCenter:
                              selectedLocation ??
                              const LatLng(30.0444, 31.2357),

                          initialZoom: 15,

                          onTap: _onMapTap,
                        ),

                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',

                            userAgentPackageName:
                                'com.example.e_commerce_full_project',
                          ),

                          if (selectedLocation != null)
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: selectedLocation!,

                                  width: 50,
                                  height: 50,

                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 45,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),

                      // =================================================
                      // CURRENT LOCATION BUTTON
                      // =================================================
                      Positioned(
                        right: 15,
                        bottom: 15,
                        child: FloatingActionButton(
                          heroTag: 'current-location',

                          onPressed: _useCurrentLocation,

                          child: const Icon(Icons.my_location),
                        ),
                      ),
                    ],
                  ),
                ),

                // =================================================
                // BOTTOM PANEL
                // =================================================
                Expanded(
                  flex: 4,
                  child: Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: colorScheme.surface,

                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(25),
                      ),

                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 15,
                          offset: Offset(0, -3),
                          color: Colors.black12,
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          'delivery_address'.tr(),

                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          'tap_map_to_select'.tr(),

                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 18),

                        // =================================================
                        // SELECTED ADDRESS
                        // =================================================
                        Container(
                          width: double.infinity,

                          padding: const EdgeInsets.all(15),

                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),

                            borderRadius: BorderRadius.circular(15),
                          ),

                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              const Icon(Icons.location_on_outlined),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Text(
                                  selectedAddress.tr(),

                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        // =================================================
                        // USE CURRENT LOCATION
                        // =================================================
                        SizedBox(
                          width: double.infinity,
                          height: 48,

                          child: OutlinedButton.icon(
                            onPressed: isSaving ? null : _useCurrentLocation,

                            icon: const Icon(Icons.my_location),

                            label: Text('use_current_location'.tr()),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // =================================================
                        // SAVE
                        // =================================================
                        SizedBox(
                          width: double.infinity,
                          height: 52,

                          child: ElevatedButton(
                            onPressed: isSaving ? null : _saveAddress,
                            child: isSaving
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'save_address'.tr(),

                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
