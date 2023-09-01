import 'package:flutter/material.dart';
import 'package:flutter_maps/app/view/maps_view.dart';
import 'package:flutter_maps/app/view/register_user/register_page.dart';
import 'package:get/get.dart';
import '../controller/user_controller.dart';

class LandingPage extends StatelessWidget {
  LandingPage({Key? key}) : super(key: key);
  UserController userController = Get.find();
  bool isInit = false;
  RxBool loading = false.obs;

  getUser() async {
    if (isInit == false) {
      loading.value = true;
      isInit = true;
      await userController.currentUser();
      loading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    debugPrint(
        "LANDING = current user ıd = ${userController.user.value.userId}");
    return Obx(() {
      if (loading.value == true) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (userController.user.value.userId == null) {
        return RegisterPage();
      } else {
        return MapsView();
      }
    });
  }
}
