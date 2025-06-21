import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:drivers_app/global/global_var.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();

  Position? currentPositionOfUser;
  GoogleMapController? googleMapController;
  Future<void> getCurrentLiveLocationOfDriver() async {
    Position positionOfUser = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
    );
    currentPositionOfUser = positionOfUser;

    LatLng userLatLng = LatLng(
      currentPositionOfUser!.latitude,
      currentPositionOfUser!.longitude,
    );

    CameraPosition cameraPosition = CameraPosition(
      target: userLatLng,
      zoom: 15,
    );

    googleMapController?.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
  }

  void updateMapTheme(GoogleMapController controller) {
    getJsonFileFromThemes("themes/dark_style.json").then(
      (style) => setGoogleMapStyle(style, controller),
    );
  }

  /// Loads the map style JSON file from the assets
  Future<String> getJsonFileFromThemes(String mapStylePath) async {
    ByteData byteData = await rootBundle.load(mapStylePath);
    final list = byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    );
    return utf8.decode(list);
  }

  /// Applies the map style to the GoogleMapController
  void setGoogleMapStyle(String googleMapStyle, GoogleMapController controller) {
    controller.setMapStyle(googleMapStyle);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: googlePlexInitialPosition,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
              updateMapTheme(controller);
              if (!googleMapCompleterController.isCompleted) {
                googleMapCompleterController.complete(controller);
              }
              getCurrentLiveLocationOfDriver();
            },
          ),
        ],
      ),
    );
  }
}