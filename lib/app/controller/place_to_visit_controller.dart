import 'package:flutter_maps/app/controller/user_controller.dart';
import 'package:flutter_maps/app/models/place_to_visit_model.dart';
import 'package:flutter_maps/app/services/place_to_visit_service.dart';
import 'package:get/get.dart';

class PlaceToVisitController extends GetxController {
  PlaceToVisitService placeToVisitService = Get.find();
  UserController userController = Get.find();

  Future<void> savePlaceInfo(PlaceToVisitModel placeToVisitModel) async {
    await placeToVisitService.savePlaceInfo(placeToVisitModel);
  }

  getSavedPlace() async {
    await userController.currentUser();
    PlaceToVisitModel? placeModel = await placeToVisitService
        .getSavedPlace(userController.user.value.userId ?? '');
  }
}
