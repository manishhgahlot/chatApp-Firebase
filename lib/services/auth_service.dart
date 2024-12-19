import 'package:chatapp/modules/auth/screens/login_screen.dart';
import 'package:chatapp/services/shared_pref_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print("The email address is already in use by another account.");
      } else if (e.code == 'weak-password') {
        print("The password provided is too weak.");
      } else if (e.code == 'invalid-email') {
        print("The email address is not valid.");
      } else {
        print("${e.message}");
      }
      return null;
    } catch (e) {
      print("$e");
      return null;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _prefsService.saveLoginState(true);
      await _prefsService.saveUserId(userCredential.user!.uid);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        print("Wrong password provided for that user.");
      } else if (e.code == 'invalid-email') {
        print("The email address is not valid.");
      } else {
        print("Login Error: ${e.message}");
      }
      return null;
    } catch (e) {
      print("Unexpected Error during login: $e");
      return null;
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await _auth.signOut();
      await _prefsService.clearLoginState();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      throw Exception("Logout failed: $e");
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<bool> isLoggedIn() async {
    return await _prefsService.getLoginState();
  }

  Future<String?> getUserId() async {
    return await _prefsService.getUserId();
  }
}
