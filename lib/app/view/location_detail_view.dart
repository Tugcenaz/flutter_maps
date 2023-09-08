import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_maps/app/components/cached_image_widget.dart';
import 'package:flutter_maps/app/components/my_custom_button.dart';
import 'package:flutter_maps/app/controller/image_controller.dart';
import 'package:flutter_maps/app/controller/location_controller.dart';
import 'package:flutter_maps/app/controller/place_to_visit_controller.dart';
import 'package:flutter_maps/app/controller/storage_controller.dart';
import 'package:flutter_maps/app/controller/user_controller.dart';
import 'package:flutter_maps/app/models/place_to_visit_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as googleMaps;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:lottie/lottie.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/image_constants.dart';
import '../../core/theme/text_styles.dart';

class LocationDetailView extends StatelessWidget {
  LocationDetailView({super.key});

  String? description = '';
  final LocationController locationController = Get.find();
  final ImageController imageController = Get.find();
  final StorageController storageController = Get.find();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  PlaceToVisitController placeToVisitController = Get.find();
  UserController userController = Get.find();

  createMarker() {
    locationController.createMarker(
        MarkerId('${userController.user.value.userId}'),
        locationController.onTapLoc.value,
        BitmapDescriptor.defaultMarker);
  }

  savePlace() async {
    var uuid = Uuid();
    var placeModel = PlaceToVisitModel(
        userId: userController.user.value.userId ?? '',
        createdAt: DateTime.now().millisecondsSinceEpoch,
        lat: locationController.onTapLoc.value.latitude,
        long: locationController.onTapLoc.value.longitude,
        description: description ?? '',
        placeId: uuid.v4(),
        imageUrl: storageController.imageUrl.value);
    await placeToVisitController.savePlaceInfo(placeModel);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 60.0.h, horizontal: 34.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              locationPicWidget(context),
              SizedBox(height: 8.h),
              buildForm(),
              MyCustomButton(
                  width: 200.w,
                  height: 50.h,
                  function: () {
                    savePlace();
                    createMarker();
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.save,
                    color: Colors.purple,
                  ),
                  text: Text(
                    'Bu konumu kaydet',
                    style: TextStyles.titleBlackTextStyle1(),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Form buildForm() {
    return Form(
      key: formKey,
      child: TextFormField(
        maxLines: 2,
        maxLength: 150,
        onChanged: (String? value) {
          if (value != null) {
            description = value;
            debugPrint(description);
          }
        },
        decoration: InputDecoration(
            hintText: 'Konumla ilgili açıklama ekle',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(26.sp),
                borderSide: BorderSide(color: Colors.black.withOpacity(0.2)))),
      ),
    );
  }

  Widget locationPicWidget(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Obx(
            () => storageController.imageUrl.value == ''
                ? SizedBox(
                    height: 150.h,
                    child: SvgPicture.asset(ImageConstants.placeHolder))
                : SizedBox(
                    height: 280.h,
                    child: CachedImageWidget(
                      imageUrl: storageController.imageUrl.value,
                    ),
                  ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Bounceable(
            onTap: () {
              modalBottomSheet(context);
            },
            child: Container(
              alignment: Alignment.center,
              //width: MediaQuery.of(context).size.width - 55,
              height: 38.h,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black.withOpacity(0.2),
                  ),
                  borderRadius: BorderRadius.circular(18.sp)),
              child: Text(
                'Bu konum için bir fotoğraf ekle',
                style: TextStyles.titleBlackTextStyle2(),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future modalBottomSheet(context) async {
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
          height: 160.h,
          child: cameraAndGalleryButtons(),
        );
      },
    );
  }

  Widget cameraAndGalleryButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        cameraGalleryRowWidget(
            onTap: () async {
              Get.back();
              await imageController.pickImageFromCamera();
              if (imageController.imageFile?.value != null) {
                storageController.uploadMedia(imageController.imageFile!.value);
              }
            },
            title: 'Kameradan fotoğraf çek',
            asset: 'assets/animation_json/camera.json'),
        Divider(
          thickness: 1,
          indent: 30.sp,
          endIndent: 30.sp,
          height: 0.h,
        ),
        cameraGalleryRowWidget(
          onTap: () async {
            Get.back();
            await imageController.pickImageFromGallery();
            if (imageController.imageFile?.value != null) {
              storageController.uploadMedia(imageController.imageFile!.value);
            }
          },
          title: 'Galeriden fotoğraf seç',
          asset: 'assets/animation_json/gallery_animation.json',
        )
      ],
    );
  }

  Bounceable cameraGalleryRowWidget(
      {required Function() onTap,
      required String title,
      required String asset}) {
    return Bounceable(
      onTap: () {
        onTap();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 150.w,
            child: Text(
              title,
              style: TextStyles.titleBlackTextStyle2(),
            ),
          ),
          Lottie.asset(asset, width: 75.w, height: 75.h),
        ],
      ),
    );
  }
}
