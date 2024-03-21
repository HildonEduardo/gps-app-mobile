class LocationModel {
  final double latitude;
  final double longitude;

  LocationModel({required this.latitude, required this.longitude});

  Map toJson() => {
    'latitude': latitude,
    'longitude': longitude
  };

}
