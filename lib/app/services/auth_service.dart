import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class AuthService {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<UserModel?> registerUser(
      {required String email, required String password}) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (credential.user != null) {
        UserModel userModel = UserModel(
            email: credential.user!.email, userId: credential.user!.uid);
        return userModel;
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('firebase auth exception: $e');
    }
    return null;
  }

  Future<String?> currentUser() async {
    User? user = firebaseAuth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  Future<void> deleteFirebaseUser() async {
    await firebaseAuth.currentUser?.delete();
  }
}
