import 'package:flutter_maps/app/controller/image_controller.dart';
import 'package:flutter_maps/app/controller/location_controller.dart';
import 'package:flutter_maps/app/controller/place_to_visit_controller.dart';
import 'package:flutter_maps/app/controller/storage_controller.dart';
import 'package:flutter_maps/app/services/auth_service.dart';
import 'package:flutter_maps/app/services/db_service.dart';
import 'package:flutter_maps/app/services/place_to_visit_service.dart';
import 'package:get/get.dart';

import '../controller/user_controller.dart';
import '../services/storage_service.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    //Controllers
    Get.lazyPut(() => LocationController(), fenix: true);
    Get.lazyPut(() => ImageController(), fenix: true);
    Get.lazyPut(() => UserController(), fenix: true);
    Get.lazyPut(() => StorageController(), fenix: true);
    Get.lazyPut(() => PlaceToVisitController(), fenix: true);

    //Services
    Get.lazyPut(() => AuthService(), fenix: true);
    Get.lazyPut(() => DBService(), fenix: true);
    Get.lazyPut(() => StorageService(), fenix: true);
    Get.lazyPut(() => PlaceToVisitService(), fenix: true);
  }
}
