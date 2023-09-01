import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/user_controller.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);
  String? email;
  String? password;
  RxBool isOnTap = true.obs;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  UserController userController = Get.find();

  void formSubmit() {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      debugPrint('Email:$email  şifre: $password');
      if (email != null && password != null) {
        userController.registerUser(email: email!, password: password!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
            padding:const EdgeInsets.symmetric(vertical: 150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 38),
                  child: Text(
                    'Hesap oluştur',
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            label: Text('E-mail'),
                          ),
                          onSaved: (String? val) {
                            email = val;
                          },
                          validator: (String? value) {
                            if (value != null) {
                              bool isEmail = GetUtils.isEmail(value);
                              if (isEmail == false) {
                                return 'Geçersiz email';
                              }
                            }
                            return null;
                          },
                        ),
                        Obx(
                          () => TextFormField(
                            obscureText: isOnTap.value,
                            onSaved: (String? val) {
                              password = val;
                            },
                            validator: (String? value) {
                              if (value!.length < 6) {
                                return 'Şifre en az 6 karakter olmalı!';
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              label: Text('Şifre'),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                _buildContainer(),
              ],
            ),
          ),

    );
  }

  Widget _buildContainer() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              formSubmit();
            },
            child: Text('kaydol'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Zaten hesabın var mı? ',
                textAlign: TextAlign.center,
              ),
              GestureDetector(
                onTap: () {
                  debugPrint('tıklandıı');
                  Get.back();
                },
                child: const Text(
                  'Giriş yap',
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
