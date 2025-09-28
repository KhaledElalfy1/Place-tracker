import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();

  /// This method
  /// 1. Ask user to Enable Location services if not enabled
  /// 2. Ask user To allow taking his current location
  /// 3. Get User Location Stream
  Future getUserLocationStream(void Function(LocationData)? onData) async {
    await _requestLocationServices();
    await _requestLocationPermissions();
    await _trackLocation(onData);
  }

  /// This method
  /// 1. Ask user to Enable Location services if not enabled
  /// 2. Ask user To allow taking his current location
  /// 3. Get User Location
  Future<LocationData> getUserCurrentLocation() async {
    await _requestLocationServices();
    await _requestLocationPermissions();

    return await _getUserLocation();
  }

  Future<void> _requestLocationServices() async {
    var isServiceEnabled = await _location.serviceEnabled();
    if (!isServiceEnabled) {
      isServiceEnabled = await _location.requestService();
      if (!isServiceEnabled) {
        throw LocationServicesException();
      }
    }
  }

  Future<void> _requestLocationPermissions() async {
    var hasPermission = await _location.hasPermission();
    if (hasPermission == PermissionStatus.denied) {
      hasPermission = await _location.requestPermission();
    }
    if (hasPermission != PermissionStatus.granted) {
      throw LocationPermissionException();
    }
  }

  Future<void> _trackLocation(void Function(LocationData)? onData) async {
    _location.changeSettings(distanceFilter: 2);
    _location.onLocationChanged.listen(onData);
  }

  Future<LocationData> _getUserLocation() async {
    return await _location.getLocation();
  }
}

class LocationServicesException implements Exception {}

class LocationPermissionException implements Exception {}
