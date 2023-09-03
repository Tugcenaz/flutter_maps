import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_maps/app/controller/user_controller.dart';
import 'package:flutter_maps/app/view/place_info_view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/theme/text_styles.dart';
import '../components/my_custom_button.dart';
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
  UserController userController = Get.find();

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

  Set<Marker> createMarker() {
    return <Marker>{
      Marker(
          onTap: () async {
            await modalBottomSheet();
          },
          markerId: const MarkerId("my_position"),
          position: _initialCameraPosition.value.target,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)),
    };
  }

  Future modalBottomSheet() async {
    return await showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.sp),
          topRight: Radius.circular(30.sp),
        ),
      ),
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) {
        return SizedBox(
          height: 180,
          child: Obx(
            () => Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.0.sp, vertical: 30.sp),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded),
                      Text(
                        locationController.currentAddress,
                        style: TextStyles.titleBlackTextStyle1(),
                        maxLines: 2,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 12.h,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined),
                      Text(
                        locationController.currentPosition.latitude.toString(),
                        style: TextStyles.titleBlackTextStyle1(
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        ', ',
                        style: TextStyles.titleBlackTextStyle1(
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        locationController.currentPosition.longitude.toString(),
                        style: TextStyles.titleBlackTextStyle1(
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8.h,
                  ),
                  MyCustomButton(
                    function: () {
                      Get.to(() => PlaceInfoView());
                    },
                    icon: Icon(
                      Icons.favorite_rounded,
                      size: 24.sp,
                      color: Colors.red,
                    ),
                    text: Text(
                      'Kaydet',
                      style: TextStyles.titleBlackTextStyle1(),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff7EACD7),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app_sharp),
            onPressed: () {
              userController.signOut();
            },
          )
        ],
      ),
      body: Obx(
        () => Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: true,
              mapType: MapType.normal,
              initialCameraPosition: _initialCameraPosition.value,
              tiltGesturesEnabled: true,
              compassEnabled: true,
              markers: createMarker(),
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              trafficEnabled: true,
              onTap: (LatLng latLong) async {
                await _changeTheLocation(latLong);
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
