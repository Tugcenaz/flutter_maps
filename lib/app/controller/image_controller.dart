import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
class ImageController extends GetxController{
  Rx<File>? image = File('').obs;

  Future pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      this.image?.value = imageTemp;
    } catch (e) {
      debugPrint('failed to pick image from gallery: $e');
    }
  }

  Future pickImageFromCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      this.image?.value = imageTemp;
    } catch (e) {
      debugPrint('failed to pick image from camera : $e');
    }
  }

}