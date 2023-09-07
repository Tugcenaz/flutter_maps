import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maps/app/controller/user_controller.dart';
import 'package:flutter_maps/app/models/place_to_visit_model.dart';
import 'package:get/get.dart';

class PlaceToVisitService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  UserController userController = Get.find();

  Future<bool> savePlaceInfo(PlaceToVisitModel placeToVisitModel) async {
    try {
      debugPrint("toMap = ${placeToVisitModel.toMap()}");
      var resut = await firestore.collection("place").add(placeToVisitModel.toMap());
      debugPrint("result = ${resut}");
      return true;
    } on Exception catch (e) {
      debugPrint(" error = $e");
      return false;
    }
  }

  Future<PlaceToVisitModel?> getSavedPlace(String userId) async {
    try {
      var savedPlace = await firestore
          .collection("place_info")
          .where('userId', isEqualTo: userId)
          .limit(1)
          .get();
      if (savedPlace.docs.isNotEmpty) {
        PlaceToVisitModel placeToVisitModel =
            PlaceToVisitModel.fromMap(savedPlace.docs.first.data());
        return placeToVisitModel;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
