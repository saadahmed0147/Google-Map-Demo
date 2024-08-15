import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Completer<GoogleMapController> _controller = Completer();

  late double longitude;
  late double latitude;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(24.966116, 66.983297),
    zoom: 14,
  );
  final List<Marker> _marker = [];
  final List<Marker> _list = [
    const Marker(
        markerId: MarkerId("1"),
        position: LatLng(24.966116, 66.983297),
        infoWindow: InfoWindow(title: "My Location")),
    const Marker(
        markerId: MarkerId("2"),
        position: LatLng(24.963536, 66.982081),
        infoWindow: InfoWindow(title: "My Location")),
  ];
  Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("Error:" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    _marker.addAll(_list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: _kGooglePlex,
          mapType: MapType.terrain,
          // myLocationEnabled: true,
          markers: Set<Marker>.of(_marker),
          // compassEnabled: false,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.location_searching),
        onPressed: () async {
          Position position = await getUserCurrentLocation();
          setState(() {
            latitude = position.latitude;
            longitude = position.longitude;
            print("${latitude},${longitude}");

            _marker.add(  Marker(
              markerId: const MarkerId('current'),
              position: LatLng(latitude, longitude),
              infoWindow: const InfoWindow(title: "My Current Location"),
            ));
          });

          GoogleMapController controller = await _controller.future;

          controller.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(latitude, longitude),
                zoom: 14,
              ),
            ),
          );
        },
      ),
    );
  }
}
