import 'package:flutter/material.dart';
import 'package:flutter_maps/app/models/user_model.dart';
import 'package:flutter_maps/app/services/auth_service.dart';
import 'package:flutter_maps/app/services/db_service.dart';
import 'package:get/get.dart';

import '../view/landing_page.dart';

class UserController extends GetxController {
  AuthService authService = Get.find();
  DBService dbService = Get.find();
  Rx<UserModel> user = UserModel().obs;

  registerUser({required String email, required String password}) async {
    UserModel? userModel =
        await authService.registerUser(email: email, password: password);
    if (userModel?.userId != null) {
      bool result = await dbService.saveUser(userModel!);
      if (result) {
        Get.offAll(() => LandingPage());
        user.value = userModel;
      }
    }
    if(user.value.userId!=null){
      debugPrint('kayıt başarılı');
    }
  }

  currentUser() async {
    String? currentUserId = await authService.currentUser();
    if (currentUserId != null) {
      UserModel? getUser = await dbService.readUser(currentUserId);
      if (getUser != null) {
        user.value = getUser;
      }
    } else {
      user.value = UserModel();
    }
    debugPrint('user: ${user.value.toString()}');
  }

}
