import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_maps/app/components/cached_image_widget.dart';
import 'package:flutter_maps/app/controller/image_controller.dart';
import 'package:flutter_maps/app/controller/location_controller.dart';
import 'package:flutter_maps/app/controller/storage_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../core/constants/image_constants.dart';
import '../../core/theme/text_styles.dart';

class LocationDetailView extends StatelessWidget {
  LocationDetailView({super.key});

  final LocationController locationController = Get.find();
  final ImageController imageController = Get.find();
  final StorageController storageController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 60.0.h),
        child: Column(
          children: [
            locationPicWidget(context),
          ],
        ),
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
                    height: 250.h,
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
              width: MediaQuery.of(context).size.width - 55,
              height: 35.h,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black.withOpacity(0.2),
                  ),
                  borderRadius: BorderRadius.circular(26.sp)),
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
