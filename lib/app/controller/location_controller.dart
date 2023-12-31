import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationController extends GetxController {
  final RxString _currentAddress = ''.obs;
  final Rx<LatLng> onTapLoc = const LatLng(0, 0).obs;
  RxSet<Marker> markers = <Marker>{}.obs;

  String get currentAddress => _currentAddress.value;

  set currentAddress(String value) {
    _currentAddress.value = value;
  }

  final Rx<Position> _currentPosition = Position(
          longitude: 0,
          latitude: 0,
          timestamp: DateTime(2023),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0)
      .obs;

  Position get currentPosition => _currentPosition.value;

  set currentPosition(Position value) {
    _currentPosition.value = value;
  }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      const SnackBar(
          content: Text(
              'Konum hizmetleri devre dışı. Lütfen hizmetleri etkinleştirin'));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        const SnackBar(content: Text('Konum izinleri reddedildi'));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      const SnackBar(
          content: Text(
              'Konum izinleri kalıcı olarak reddedildi, izin isteyemiyoruz.'));
      return false;
    }
    return true;
  }

  Future<Position> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLng = LatLng(currentPosition.latitude, currentPosition.longitude);
    await getAddressFromLatLng(latLng);
    return currentPosition;
  }

  Future<void> getAddressFromLatLng(LatLng latlong) async {
    await placemarkFromCoordinates(latlong.latitude, latlong.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      currentAddress =
          '${place.street}, ${place.thoroughfare}, ${place.postalCode}, ${place.subAdministrativeArea}/${place.administrativeArea}';
    }).catchError((e) {
      debugPrint(e);
    });
  }
}
