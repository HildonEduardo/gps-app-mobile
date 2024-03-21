import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/location.dart';

class LocationService {
  final Location location;
  final http.Client httpClient;

  LocationService({Location? location, http.Client? httpClient})
      : location = location ?? Location(),
        httpClient = httpClient ?? http.Client();

  Future<LocationData?> getGpsLocation() async {
    try {
      return await location.getLocation();
    } catch (e) {
      print("Error getting location: $e");
      return null;
    }
  }

  Future<LocationModel?> getLocationFromIP({String ip = ''}) async {
    var ipKey = ip;
    if (ip == '') {
      ipKey = 'user';
    }
    try {
      final url = Uri.parse('http://ip-api.com/json/$ip');
      final response = await httpClient.get(url).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final location = LocationModel(
          latitude: data['lat'],
          longitude: data['lon'],
        );

        await saveLocationToStorage(ipKey, location);
        return location;
      } else {
        print('Failed to load location: ${response.statusCode}');
        return null;
      }
    } on TimeoutException {
      final location = await getLocationFromStorage(ip: ipKey);
      return location;
    } on SocketException {
      final location = await getLocationFromStorage(ip: ipKey);
      return location;
    } on Error {
      final location = await getLocationFromStorage(ip: ipKey);
      return location;
    }
  }

  Future<void> saveLocationToStorage(String ip, LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(location);
    await prefs.setString(ip, json);
  }

  Future<LocationModel?> getLocationFromStorage({String ip = 'user'}) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(ip);
    if (jsonString != null) {
      final locationJson = jsonDecode(jsonString);
      final location = LocationModel(
          latitude: locationJson['latitude'],
          longitude: locationJson['longitude']);

      return location;
    }
    return null;
  }
}
