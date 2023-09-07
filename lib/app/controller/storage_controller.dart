import 'dart:io';
import 'package:flutter_maps/app/services/storage_service.dart';
import 'package:get/get.dart';

class StorageController extends GetxController {
  StorageService storageService = Get.find();
  RxString imageUrl =''.obs;

  uploadMedia(File file) async {
    String url = await storageService.uploadMedia(file);
    imageUrl.value = url;
  }
}
