import 'package:easy_localization/easy_localization.dart';
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

  LatLng? selectedLocation;

  String selectedAddress = 'select_location_from_map';

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }
  Future<void> _getCurrentLocation() async {
    try {
      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        setState(() {
          isLoading = false;
          selectedAddress =
              'please_enable_location_services';
        });
        return;
      }
      LocationPermission permission =
          await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission =
            await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        setState(() {
          isLoading = false;
          selectedAddress =
              'location_permission_denied';
        });
        return;
      }
      if (permission ==
          LocationPermission.deniedForever) {
        if (!mounted) return;
        setState(() {
          isLoading = false;
          selectedAddress =
              'location_permission_permanently_denied';
        });
        return;
      }
      final position =
          await Geolocator.getCurrentPosition();
      final location = LatLng(
        position.latitude,
        position.longitude,
      );
      if (!mounted) return;
      setState(() {
        selectedLocation = location;
        isLoading = false;
      });
      await _getAddressFromLocation(location);
      mapController.move(
        location,
        16,
      );
    } catch (e) {
      debugPrint(
        'Location Error: $e',
      );
      if (!mounted) return;
      setState(() {
        isLoading = false;
        selectedAddress =
            'unable_to_get_location';
      });
    }
  }
  Future<void> _getAddressFromLocation(
    LatLng location,
  ) async {
    try {
      final placemarks =
          await Geocoding().placemarkFromCoordinates(
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
        if (place.street?.trim().isNotEmpty ?? false)
          place.street!,
        if (place.subLocality?.trim().isNotEmpty ?? false)
          place.subLocality!,
        if (place.locality?.trim().isNotEmpty ?? false)
          place.locality!,
        if (place.administrativeArea
                ?.trim()
                .isNotEmpty ??
            false)
          place.administrativeArea!,
        if (place.country?.trim().isNotEmpty ?? false)
          place.country!,
      ];
      final address =
          addressParts.join(', ');
      if (!mounted) return;
      setState(() {
        selectedAddress = address.isNotEmpty
            ? address
            : 'address_not_found';
      });
    } catch (e) {
      debugPrint(
        'Geocoding Error: $e',
      );
      if (!mounted) return;
      setState(() {
        selectedAddress =
            'unable_to_get_address';
      });
    }
  }
  Future<void> _onMapTap(
    TapPosition tapPosition,
    LatLng location,
  ) async {
    setState(() {
      selectedLocation = location;
    });
    await _getAddressFromLocation(
      location,
    );
  }
  Future<void> _useCurrentLocation() async {
    setState(() {
      isLoading = true;
    });
    await _getCurrentLocation();
    if (selectedLocation != null) {
      mapController.move(
        selectedLocation!,
        16,
      );
    }
  }
  void _saveAddress() {
    if (selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'please_select_location'.tr(),
          ),
        ),
      );

      return;
    }
    final latitude =
        selectedLocation!.latitude;
    final longitude =
        selectedLocation!.longitude;
    debugPrint(
      '==============================',
    );

    debugPrint(
      'Address: $selectedAddress',
    );

    debugPrint(
      'Latitude: $latitude',
    );

    debugPrint(
      'Longitude: $longitude',
    );

    debugPrint(
      '==============================',
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'address_saved_successfully'.tr(),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'my_address'.tr(),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [

                Expanded(
                  flex: 5,
                  child: Stack(
                    children: [
                      FlutterMap(
                        mapController:
                            mapController,

                        options: MapOptions(
                          initialCenter:
                              selectedLocation ??
                                  const LatLng(
                                    30.0444,
                                    31.2357,
                                  ),

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
                                  point:
                                      selectedLocation!,

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


                      Positioned(
                        right: 15,
                        bottom: 15,

                        child: FloatingActionButton(
                          heroTag:
                              'current-location',

                          onPressed:
                              _useCurrentLocation,

                          child: const Icon(
                            Icons.my_location,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  flex: 4,
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surface,
                      borderRadius:
                          const BorderRadius.vertical(
                        top:
                            Radius.circular(25),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 15,
                          offset:
                              Offset(0, -3),
                          color:
                              Colors.black12,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          'delivery_address'.tr(),
                          style:
                              const TextStyle(
                            fontSize: 20,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          'tap_map_to_select'.tr(),
                          style: TextStyle(
                            color: Colors
                                .grey
                                .shade600,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(
                          height: 18,
                        ),
                        Container(
                          width:
                              double.infinity,

                          padding:
                              const EdgeInsets
                                  .all(15),

                          decoration:
                              BoxDecoration(
                            border:
                                Border.all(
                              color: Colors
                                  .grey
                                  .shade300,
                            ),

                            borderRadius:
                                BorderRadius
                                    .circular(
                              15,
                            ),
                          ),

                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [
                              const Icon(
                                Icons
                                    .location_on_outlined,
                              ),

                              const SizedBox(
                                width: 12,
                              ),

                              Expanded(
                                child: Text(
                                  selectedAddress
                                      .tr(),

                                  style:
                                      const TextStyle(
                                    fontSize:
                                        14,

                                    fontWeight:
                                        FontWeight
                                            .w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(
                          height: 15,
                        ),


                        SizedBox(
                          width:
                              double.infinity,

                          height: 48,

                          child:
                              OutlinedButton
                                  .icon(
                            onPressed:
                                _useCurrentLocation,

                            icon:
                                const Icon(
                              Icons
                                  .my_location,
                            ),

                            label:
                                Text(
                              'use_current_location'
                                  .tr(),
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 12,
                        ),


                        SizedBox(
                          width:
                              double.infinity,

                          height: 52,

                          child:
                              ElevatedButton(
                            onPressed:
                                _saveAddress,

                            child:
                                Text(
                              'save_address'.tr(),

                              style:
                                  const TextStyle(
                                fontSize:
                                    16,

                                fontWeight:
                                    FontWeight
                                        .w600,
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