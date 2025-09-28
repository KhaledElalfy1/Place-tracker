import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_tracker_app/core/api/api_consumer.dart';
import 'package:route_tracker_app/core/api/dio_consumer.dart';
import 'package:route_tracker_app/features/data/models/place_details.dart';
import 'package:route_tracker_app/features/data/models/places_suggestions.dart';
import 'package:route_tracker_app/features/data/models/routes_models/route_response_model.dart';
import 'package:route_tracker_app/features/data/models/routes_models/routes_request_model.dart';

class PlacesRepo {
  final ApiConsumer _apiConsumer = DioConsumer();
  final String _baseUrl = 'https://places.googleapis.com/v1/places';
  final Map<String, String> _header = {
    'Content-Type': "application/json",
    "X-Goog-Api-Key": dotenv.env['GOOGLE_API_KEY']!,
  };
  Future<Either<void, List<PlacesSuggestions>>> getPlacesSuggestions({
    required String input,
    required String sessionToken,
  }) async {
    try {
      final response = await _apiConsumer.post(
        '$_baseUrl:autocomplete',
        data: {"input": input},
        queryParameter: {'sessionToken': sessionToken},
        headers: _header,
      );
      List<PlacesSuggestions> places = (response.data['suggestions'] as List)
          .map((e) {
            return PlacesSuggestions.fromJson(e['placePrediction']);
          })
          .toList();
      return right(places);
    } catch (e) {
      log(e.toString());
      return left(null);
    }
  }

  Future<Either<void, PlaceDetails>> getPlaceDetails({
    required String placeId,
  }) async {
    try {
      final requestHeader = Map<String, String>.from(_header);
      requestHeader['X-Goog-FieldMask'] =
          'id,name,photos,location,formattedAddress';
      final response = await _apiConsumer.get(
        '$_baseUrl/$placeId',
        headers: requestHeader,
      );
      return right(PlaceDetails.fromJson(response.data));
    } catch (e) {
      log(e.toString());
      return left(null);
    }
  }

  Future<Either<void, List<LatLng>>> getTwoPointsRoute({
    required RoutesRequestModel routesRequestModel,
  }) async {
    try {
      final requestHeader = Map<String, String>.from(_header);
      requestHeader['X-Goog-FieldMask'] =
          'routes.duration,routes.distanceMeters,routes.polyline.encodedPolyline';
      print(routesRequestModel.toJson());
      final response = await _apiConsumer.post(
        'https://routes.googleapis.com/directions/v2:computeRoutes',
        data: routesRequestModel.toJson(),
        headers: requestHeader,
      );
      List<RouteResponseModel> routes = (response.data['routes'] as List)
          .map((e) => RouteResponseModel.fromJson(e))
          .toList();
      List<PointLatLng> pointsLatLong = PolylinePoints.decodePolyline(
        routes.first.encodedPolyline,
      );
      List<LatLng> points = pointsLatLong
          .map((e) => LatLng(e.latitude, e.longitude))
          .toList();
      return right(points);
    } catch (e) {
      log(e.toString());
      return left(null);
    }
  }
}
