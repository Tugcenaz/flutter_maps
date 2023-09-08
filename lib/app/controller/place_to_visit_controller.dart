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

  Future<void> deletePlaceInfo(String placeId) async {
    await placeToVisitService.deletePlaceInfo(placeId);
  }

  Future<List<PlaceToVisitModel>?>getSavedPlace() async {
    return await placeToVisitService.getSavedPlace(userController.user.value.userId??"");
  }
}
