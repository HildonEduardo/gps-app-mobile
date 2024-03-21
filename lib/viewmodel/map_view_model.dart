import 'package:flutter/material.dart';

import '../data/model/location.dart';
import '../service/location_service.dart';

class MapViewModel extends ChangeNotifier {
  final LocationService _locationService = LocationService();
  LocationModel? _currentLocation;

  LocationModel? get currentLocation => _currentLocation;

  MapViewModel() {
    loadGpsLocation();
    loadLocation();
  }

  Future<void> loadGpsLocation() async {
    var locationModel = await _locationService.getGpsLocation();
    if (locationModel != null &&
        locationModel.latitude != null &&
        locationModel.longitude != null) {

      _currentLocation = LocationModel(
          latitude: locationModel.latitude!,
          longitude: locationModel.longitude!);
      notifyListeners();
    }
  }

  Future<void> loadLocation([String ip = '']) async {
    _currentLocation = await _locationService.getLocationFromIP(ip: ip);
    notifyListeners();
  }
}
