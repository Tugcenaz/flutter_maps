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

  Future<void> _getLocation() async {
    bool result = await locationController.handleLocationPermission();
    if (result) {
      await locationController.getCurrentPosition();
    }
  }

  final Rx<CameraPosition> _initialCameraPosition =
      const CameraPosition(target: LatLng(0, 0)).obs;

  @override
  void initState() {
    _getLocation().then((value) async {
      _initialCameraPosition.value = CameraPosition(
        zoom: 15,
        target: LatLng(locationController.currentPosition.latitude,
            locationController.currentPosition.longitude),
      );
      googleMapController = await _controller.future;
      await googleMapController?.animateCamera(
          CameraUpdate.newCameraPosition(_initialCameraPosition.value));
    });
    super.initState();
  }

  Set<Marker> _createMarker() {
    return <Marker>{
      Marker(
          onTap: () async {
            showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                isScrollControlled: true,
                useSafeArea: true,
                context: context,
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    height: 150,
                    child: Obx(
                      () => Text(locationController.currentAddress),
                    ),
                  );
                });
          },
          markerId: const MarkerId("my_position"),
          position: _initialCameraPosition.value.target,
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
      body: Obx(
        () => Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: _initialCameraPosition.value,
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
            ),
          ],
        ),
      ),
    );
  }

  Future _changeTheLocation(LatLng latLong) async {
    setState(() {});
    final GoogleMapController controller = await _controller.future;
    _initialCameraPosition.value = CameraPosition(target: latLong, zoom: 15);
    await controller.animateCamera(
        CameraUpdate.newCameraPosition(_initialCameraPosition.value));
    await locationController.getAddressFromLatLng(latLong);
  }
}

/* floatingActionButton: FloatingActionButton(
          onPressed: _changeTheLocation(const LatLng(40.2222981, 28.8562524)),
          child: const Icon(Icons.map_rounded),
        )*/
