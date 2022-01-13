import 'dart:math';
import 'package:geolocator/geolocator.dart';

class Geolocation {

  static getPermissions() async {
    bool perm = await Geolocator.isLocationServiceEnabled();
    if (!perm) {
      await Geolocator.checkPermission();
    } else {
      return perm;
    }
  }

  static getLocation() async {
    Position? cords;
    await getPermissions().then((result) async {
      if (result) {
        cords = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true);
      }
    });
    return cords ?? Position();
  }

  static double getDistance(latitude, longitude, centerLatitude, centerLongitude) {
    var earthRadiusKm = 6371;

    var lat1 = latitude;
    var lon1 = longitude;

    var lat2 = centerLatitude;
    var lon2 = centerLongitude;

    var dLat = (lat2 - lat1) * pi / 180;
    var dLon = (lon2 - lon1) * pi / 180;

    lat1 = lat1 * pi / 180;
    lat2 = lat2 * pi / 180;

    var a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    var c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

}