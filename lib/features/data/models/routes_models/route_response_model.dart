class RouteResponseModel {
  final num distance;
  final String duration;
  final String encodedPolyline;

  RouteResponseModel({
    required this.distance,
    required this.duration,
    required this.encodedPolyline,
  });

  factory RouteResponseModel.fromJson(Map<String, dynamic> json) {
    return RouteResponseModel(
      distance: json['distanceMeters'],
      duration: json['duration'],
      encodedPolyline: json['polyline']['encodedPolyline'],
    );
  }
}
