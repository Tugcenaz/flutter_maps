import 'package:flutter_maps/app/controller/location_controller.dart';
import 'package:get/get.dart';

class InitialBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => LocationController(),fenix: true);

  }

}