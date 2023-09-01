import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class DBService {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  Future<bool> saveUser(UserModel userModel) async {
    try {
      await fireStore
          .collection("users")
          .doc(userModel.userId.toString())
          .set(userModel.toMap());
      return true;
    } on Exception catch (e) {
      debugPrint("db error: $e");
      return false;
    }
  }

  Future<UserModel?> readUser(String currentUserID) async {
    try {
      var user = await fireStore.collection("users").doc(currentUserID).get();
      if (user.data() != null) {
        UserModel userModel = UserModel.fromMap(user.data()!);
        return userModel;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
