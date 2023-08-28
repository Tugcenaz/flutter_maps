import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationController extends GetxController{
  String? currentAddress;
   Rx<Position>? currentPosition=Position(longitude: 0, latitude: 0, timestamp: DateTime(2023), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0).obs;
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

  Future<Rx<Position>?> getCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentPosition?.value=position;
    return currentPosition;

  }
}
