import 'package:google_maps_flutter/google_maps_flutter.dart';

class RoutesRequestModel {
  final LatLng location;
  final LatLng destination;

  RoutesRequestModel({required this.location, required this.destination});

  Map<String, dynamic> toJson() {
    return {
      "origin": {
        "location": {
          "latLng": {
            "latitude": location.latitude, //37.419734,
            "longitude": location.longitude, //-122.0827784,
          },
        },
      },
      "destination": {
        "location": {
          "latLng": {
            "latitude": destination.latitude, // 37.417670,
            "longitude": destination.longitude, //-122.079595 ,
          },
        },
      },
      "routeModifiers": {
        "avoidTolls": false,
        "avoidHighways": false,
        "avoidFerries": false,
      },
      "languageCode": "en-US",
      "units": "METRIC",
    };
  }
}
