// C:\Users\th366\Desktop\sevakai\frontend\lib\services\location_service.dart
import 'package:geolocator/geolocator.dart';

class CapturedLocation {
  const CapturedLocation({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;
}

class LocationService {
  const LocationService._();

  static Future<CapturedLocation> getCurrentLocation() async {
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      throw Exception('Location permission not granted.');
    }

    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    );
    return CapturedLocation(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}
