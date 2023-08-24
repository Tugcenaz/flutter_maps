import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsView extends StatefulWidget {
  const MapsView({super.key});

  @override
  _MapsViewState createState() => _MapsViewState();
}

double _originLatitude = 40.2310977;

double _originLongitude = 28.8425853;

class _MapsViewState extends State<MapsView> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  static final CameraPosition _initalCameraPosition = CameraPosition(
    target: LatLng(_originLatitude, _originLongitude),
    zoom: 15,
  );

  Set<Marker> _createMarker() {
    return <Marker>{
      Marker(
          infoWindow: const InfoWindow(title: "Görükle"),
          markerId: const MarkerId("gorukle"),
          position: _initalCameraPosition.target,
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
        body: GoogleMap(
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: _initalCameraPosition,
          tiltGesturesEnabled: true,
          compassEnabled: true,
          markers: _createMarker(),
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          trafficEnabled: true,
          onTap: (LatLng latLong) async{
            await _changeTheLocation(latLong);
            setState(() {});
          },
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
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
