import 'dart:async';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:route_tracker_app/core/services/location_service.dart';
import 'package:route_tracker_app/features/data/models/place_details.dart';
import 'package:route_tracker_app/features/data/models/places_suggestions.dart';
import 'package:route_tracker_app/features/data/models/routes_models/routes_request_model.dart';
import 'package:route_tracker_app/features/data/repository/places_repo.dart';
import 'package:route_tracker_app/features/home/view_model/maps_cubit/maps_states.dart';
import 'package:uuid/uuid.dart';

class MapsCubit extends Cubit<MapsStates> {
  MapsCubit() : super(MapsStateInitial()) {
    searchPlace();
  }
  // TODO make dependancy injection later
  final LocationService locationService = LocationService();
  final PlacesRepo placesRepo = PlacesRepo();
  Timer? _debounce;
  CameraPosition initialCameraPotion = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 1,
  );
  late GoogleMapController googleMapController;
  late LatLng userLocation;
  late PlaceDetails placeDetails;
  Set<Marker> mapMarkers = {};
  Set<Polyline> mapPolylines = {};
  final List<PlacesSuggestions> places = [];
  TextEditingController textEditingController = TextEditingController();
  final Uuid _uuid = const Uuid();
  String? _sessionToken;

  Future navigateToUserLocation() async {
    try {
      locationService.getUserLocationStream((location) {
        userLocation = LatLng(location.latitude!, location.longitude!);
        Marker myLocationMarker = Marker(
          markerId: const MarkerId('value'),
          position: userLocation,
        );
        mapMarkers.add(myLocationMarker);
        emit(ChangeMapView());
        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: userLocation, zoom: 14),
          ),
        );
      });
    } on LocationServicesException catch (_) {
      // TODO:
    } on LocationPermissionException catch (_) {
      // TODO:
    } catch (e) {
      // TODO:
    }
  }

  void searchPlace() async {
    _sessionToken ??= _uuid.v4();
    textEditingController.addListener(() async {
      if (_debounce?.isActive ?? false) {
        _debounce?.cancel();
      }
      _debounce = Timer(const Duration(milliseconds: 500), () async {
        if (textEditingController.text.isNotEmpty) {
          await _getPlaces();
        } else {
          places.clear();
        }
        emit(ClearSuggestedPlaces());
      });
    });
  }

  Future<void> _getPlaces() async {
    final result = await placesRepo.getPlacesSuggestions(
      input: textEditingController.text,
      sessionToken: _sessionToken!,
    );
    result.fold((l) => dev.log('Failed to fetchPlaces'), (placesSuggestions) {
      dev.log('Get Suggested Places Successfully');
      places.clear();
      places.addAll(placesSuggestions);
    });
  }

  Future<void> getPlaceDetails({required String placeId}) async {
    final result = await placesRepo.getPlaceDetails(placeId: placeId);
    result.fold((l) => dev.log('Failed to Get place Details'), (r) {
      placeDetails = r;
      textEditingController.clear();
      _sessionToken = null;
      _getTwoPlacesRoute();
    });
  }

  Future<void> _getTwoPlacesRoute() async {
    final result = await placesRepo.getTwoPointsRoute(
      routesRequestModel: RoutesRequestModel(
        location: userLocation,
        destination: placeDetails.location,
      ),
    );
    result.fold((l) => dev.log('Failed to get Route'), (routePoints) {
      final polyline = Polyline(
        polylineId: const PolylineId('id'),
        points: routePoints,
        color: Colors.blue,
        width: 4,
      );
      mapPolylines.add(polyline);
      LatLngBounds bounds = _getNewPotionBounds(routePoints);
      googleMapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 16),
      );
      emit(AddDestinationPolygon());
    });
  }

  LatLngBounds _getNewPotionBounds(List<LatLng> routePoints) {
    var southwestLat = routePoints.first.latitude;
    var southwestLong = routePoints.first.longitude;
    var northeastLat = routePoints.first.latitude;
    var northeastLong = routePoints.first.longitude;
    for (var routePoint in routePoints) {
      southwestLat = min(southwestLat, routePoint.latitude);
      southwestLong = min(southwestLong, routePoint.longitude);
      northeastLat = max(northeastLat, routePoint.latitude);
      northeastLong = min(northeastLong, routePoint.longitude);
    }

    return LatLngBounds(
      southwest: LatLng(southwestLat, southwestLong),
      northeast: LatLng(northeastLat, northeastLong),
    );
  }

  @override
  Future<void> close() {
    textEditingController.dispose();
    _debounce?.cancel();

    return super.close();
  }
}
