import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceDetails {
  final String placeId;
  final String placeName;
  final String formattedAddress;
  final LatLng location;
  final String? photoUrl;

  PlaceDetails({
    required this.placeId,
    required this.placeName,
    required this.formattedAddress,
    required this.location,
    required this.photoUrl,
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    return PlaceDetails(
      placeId: json['id'],
      placeName: json['name'],
      formattedAddress: json['formattedAddress'],
      location: LatLng(
        json['location']['latitude'],
        json['location']['longitude'],
      ),
      photoUrl: json['photos']?[0]?['googleMapsUri']??'',
    );
  }
}
