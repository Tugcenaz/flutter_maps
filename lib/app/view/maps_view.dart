import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maps/app/controller/place_to_visit_controller.dart';
import 'package:flutter_maps/app/controller/user_controller.dart';
import 'package:flutter_maps/app/models/place_to_visit_model.dart';
import 'package:flutter_maps/app/view/location_detail_view.dart';
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
  final LocationController locationController = Get.find();
  final UserController userController = Get.find();
  final PlaceToVisitController placeToVisitController = Get.find();

  Future<void> _getLocation() async {
    bool result = await locationController.handleLocationPermission();
    if (result) {
      await locationController.getCurrentPosition();
    }
  }

  showArchiveDialog() async {
    List<PlaceToVisitModel>? placeList =
        await placeToVisitController.getSavedPlace();
    if ((placeList ?? []).isNotEmpty) {
      return await showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.sp),
            topRight: Radius.circular(30.sp),
          ),
        ),
        isScrollControlled: true,
        useSafeArea: true,
        context: Get.context!,
        builder: (context) {
          return SizedBox(
            height: Get.height * .4,
            child: ListView.builder(
              itemBuilder: (_, int index) {
                PlaceToVisitModel placeToVisitModel = placeList![index];
                return ListTile(
                    onTap: () {
                      Get.back();
                      goToLocation(LatLng(
                          placeToVisitModel.lat, placeToVisitModel.long));
                    },
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        Get.back();
                        placeToVisitController
                            .deletePlaceInfo(placeToVisitModel.placeId);
                      },
                    ),
                    leading: CircleAvatar(
                      child: placeToVisitModel.imageUrl.isEmpty
                          ? SizedBox()
                          : CachedNetworkImage(
                              imageUrl: placeToVisitModel.imageUrl,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                            ),
                    ),
                    title: Text(placeToVisitModel.description));
              },
              itemCount: placeList?.length,
            ),
          );
        },
      );
    } else {
      Get.snackbar("Hata", "Kaydedilmiş yer yok!");
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
    return {
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
                  EdgeInsets.symmetric(horizontal: 12.0.sp, vertical: 30.sp),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded),
                      Text(
                        overflow: TextOverflow.clip,
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
                      Get.back();
                      Get.to(() => LocationDetailView());
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
            icon: const Icon(Icons.archive),
            onPressed: () {
              showArchiveDialog();
            },
          ),
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
                goToLocation(latLong);
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

  goToLocation(LatLng latLong) async {
    await _changeTheLocation(latLong);
    setState(() {});
    locationController.onTapLoc.value = latLong;
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
