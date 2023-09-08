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
       await firestore.collection("place").add(placeToVisitModel.toMap());
      return true;
    } on Exception catch (e) {
      debugPrint(" error = $e");
      return false;
    }
  }

  Future<bool> deletePlaceInfo(String placeId) async {
    try {
      var result = await firestore.collection("place").where("placeId",isEqualTo: placeId).get();
      if(result.docs.isNotEmpty){
        await firestore.collection("place").doc(result.docs.first.id).delete();
      }
      return true;
    } on Exception catch (e) {
      debugPrint(" error = $e");
      return false;
    }
  }

  Future<List<PlaceToVisitModel>?> getSavedPlace(String userId) async {
    try {
      var savedPlace = await firestore
          .collection("place")
          .where('userId', isEqualTo: userId)
          .limit(50)
          .get();
      if (savedPlace.docs.isNotEmpty) {
        List<PlaceToVisitModel> placeList = [];
        for(var item in savedPlace.docs){
          PlaceToVisitModel placeToVisitModel = PlaceToVisitModel.fromMap(item.data());
          placeList.add(placeToVisitModel);
        }
        return placeList;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return null;
  }
}
