import 'package:flutter/material.dart';
import 'package:flutter_maps/app/controller/image_controller.dart';
import 'package:flutter_maps/app/controller/location_controller.dart';
import 'package:get/get.dart';

class PlaceInfoView extends StatelessWidget {
  PlaceInfoView({super.key});

  final LocationController locationController = Get.find();
  final ImageController imageController=Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: cameraAndGalleryButtons()),
    );
  }

  Widget cameraAndGalleryButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        MaterialButton(
            color: Colors.blue,
            child: const Text("Pick Image from Gallery",
                style: TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.bold)),
            onPressed: () async {
              await imageController.pickImageFromGallery();
            }),
        MaterialButton(
            color: Colors.blue,
            child: const Text("Pick Image from Camera",
                style: TextStyle(
                    color: Colors.white70, fontWeight: FontWeight.bold)),
            onPressed: () async {
              await imageController.pickImageFromCamera();
            }),
      ],
    );
  }


}
