import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lokerapps/features/data/auth_remote_data_service.dart';

import '../domain/auth_data_model.dart';


class AuthRemoteDataSource {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw e;
    }
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel user =
      await AuthRemoteDataService().getUserById(userCredential.user!.uid);
      return user;
    }  catch (e) {
      throw (e);
    }
  }

  Future<UserModel> signUp(
      {required String email,
        required String password
  }) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      UserModel user = UserModel(
          id: userCredential.user!.uid,
          email: email,
      );

      await AuthRemoteDataService().setUser(user);

      return user;
    } catch (e) {
      throw (e);
    }
  }


  Future<void> signOut() async {
    try {
      await _auth.signOut();
    }  catch (e) {
      throw (e);
    }
  }
}