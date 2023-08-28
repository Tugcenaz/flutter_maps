import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controller/location_controller.dart';

class MapsView extends StatefulWidget {
  const MapsView({super.key});

  @override
  _MapsViewState createState() => _MapsViewState();
}


class _MapsViewState extends State<MapsView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  GoogleMapController? googleMapController;

  LocationController locationController = Get.find();
  Rx<LatLng> latLong = LatLng(0.0, 0.0).obs;

  Future<void> _handleLocationPermission() async {
    bool result = await locationController.handleLocationPermission();
    if (result) {
      await locationController.getCurrentPosition();
    }
  }

  final Rx<CameraPosition> _initalCameraPosition =
      const CameraPosition(target: LatLng(0, 0)).obs;

  @override
  void initState() {
    _handleLocationPermission().then((value) async {
      _initalCameraPosition.value = CameraPosition(
        zoom: 15,
        target: LatLng(locationController.currentPosition?.value.latitude ?? 0,
            locationController.currentPosition?.value.longitude ?? 0),
      );
      googleMapController = await _controller.future;
      googleMapController?.animateCamera(CameraUpdate.newCameraPosition(_initalCameraPosition.value));
    });

    super.initState();
  }

  Set<Marker> _createMarker() {
    return <Marker>{
      Marker(
          infoWindow: const InfoWindow(title: "Konumum"),
          markerId: const MarkerId("my_position"),
          position: _initalCameraPosition.value.target,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)),
      Marker(
          infoWindow: const InfoWindow(title: "Ulutek"),
          markerId: const MarkerId("ulutek"),
          position: const LatLng(40.2223549, 28.8586724),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRose)),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(()=>GoogleMap(
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition: _initalCameraPosition.value,
        tiltGesturesEnabled: true,
        compassEnabled: true,
        markers: _createMarker(),
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
        trafficEnabled: true,
        onTap: (LatLng latLong) async {
          await _changeTheLocation(latLong);
          setState(() {});
        },
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),),
      /* floatingActionButton: FloatingActionButton(
          onPressed: _changeTheLocation(const LatLng(40.2222981, 28.8562524)),
          child: const Icon(Icons.map_rounded),
        )*/
    );
  }

  Future _changeTheLocation(LatLng latLong) async {
    setState(() {});
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newLatLng(latLong));
  }
}
