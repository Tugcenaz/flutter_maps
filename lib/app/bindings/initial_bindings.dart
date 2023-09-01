import 'package:flutter_maps/app/controller/image_controller.dart';
import 'package:flutter_maps/app/controller/location_controller.dart';
import 'package:flutter_maps/app/services/auth_service.dart';
import 'package:flutter_maps/app/services/db_service.dart';
import 'package:get/get.dart';

import '../controller/user_controller.dart';
import '../services/images_service.dart';

class InitialBindings implements Bindings{
  @override
  void dependencies() {
    //Controllers
    Get.lazyPut(() => LocationController(),fenix: true);
    Get.lazyPut(() => ImageController(),fenix: true);
    Get.lazyPut(() => UserController(),fenix: true);


    //Services
    Get.lazyPut(() => AuthService(),fenix: true);
    Get.lazyPut(() => DBService(),fenix: true);
    Get.lazyPut(() => ImagesService(),fenix: true);
  }

}