import 'package:flutter/material.dart';
import 'package:flutter_maps/app/view/register_user/register_page.dart';
import 'package:get/get.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: GestureDetector(onTap: (){
      Get.off(()=>RegisterPage());
    },child: Text("Kayıt")),),);
  }
}
