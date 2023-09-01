import 'package:flutter/material.dart';
import 'package:flutter_maps/app/view/maps_view.dart';
import 'package:flutter_maps/app/view/register_user/sign_in_page.dart';
import 'package:get/get.dart';
import '../controller/user_controller.dart';


class LandingPage extends StatelessWidget {
  LandingPage({Key? key}) : super(key: key);
  final RxBool loading = false.obs;
  bool isInit = false;
  final UserController userController = Get.find();

  getUser() async {
    if (isInit == false) {
      isInit = true;
      loading.value = true;
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
      debugPrint("loading value = ${loading.value}");
      if (loading.value == true) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else if (userController.user.value.userId == null) {
        return SignInPage();
      } else {
        return MapsView();
      }
    });
  }
}
