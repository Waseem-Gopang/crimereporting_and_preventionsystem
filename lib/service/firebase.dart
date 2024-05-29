import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:github_sign_in_plus/github_sign_in_plus.dart';

class AuthService {
  final ref = FirebaseDatabase.instance.ref();
  Stream<User?> get authStateChanges => _auth.authStateChanges();

//Sign In by email method
  Future signIn(String email, String password) async {
    try {
      User? user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password))
          .user;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userID", user!.uid);
      return user.uid;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      Get.snackbar("Error:", e.toString(),
          duration: const Duration(seconds: 7),
          backgroundColor: Colors.lightBlueAccent);
      return false;
    }
  }

//Sign up by email method
  Future createAccount(String email, String password, String iNo) async {
    try {
      User? user = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password))
          .user;
      return user!.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: "The account already exists for that email.");
      }
      return false;
    } catch (e) {
      Get.snackbar("Error:", e.toString(),
          duration: const Duration(seconds: 7),
          backgroundColor: Colors.lightBlueAccent);
    }
  }

//loged user id fetching method
  Future<String> fetchUserID() async {
    final User? user = FirebaseAuth.instance.currentUser;
    return user!.uid;
  }

  Future getUserData(String userId) async {
    final snapshot = await ref.child('users/$userId').get();
    if (snapshot.exists) {
      print(snapshot.value);
      return snapshot.value;
    } else {
      print('No data available.');
    }
  }

//google sign in method
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount == null) return null;

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;
      return user;
    } catch (e) {
      Get.snackbar("Google Sign-In Error: ", e.toString(),
          duration: const Duration(seconds: 7),
          backgroundColor: Colors.lightBlueAccent);
      return null;
    }
  }

//facebook sign in method
  Future<void> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final AuthCredential credential =
            FacebookAuthProvider.credential(accessToken.token);

        final UserCredential authResult =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = authResult.user;
        if (user != null) {
          Get.snackbar("Congratulation!", "You have successfully Signed In.",
              duration: const Duration(seconds: 5),
              backgroundColor: Colors.green,
              colorText: Colors.white);
          Get.offAllNamed('/home');
        }
      } else {
        Get.snackbar('Failed!', "Facebook login failed",
            duration: const Duration(seconds: 7),
            backgroundColor: Colors.lightBlueAccent);
      }
    } catch (e) {
      Get.snackbar('Error:', e.toString(),
          duration: const Duration(seconds: 7),
          backgroundColor: Colors.lightBlueAccent);
    }
  }

//github sign in method
  final GitHubSignIn githubSignIn = GitHubSignIn(
    clientId: '8f3fe3cb0f3226744ffd',
    clientSecret: 'b2eadcf062d42bc5da3fdb018d77abb5daec9dc1',
    redirectUrl:
        'https://crimereportingandprevent-22511.firebaseapp.com/__/auth/handler',
  );

  Future<void> githubLogin(BuildContext context) async {
    try {
      final result = await githubSignIn.signIn(context);

      if (result.status == GitHubSignInResultStatus.ok) {
        final AuthCredential credential =
            GithubAuthProvider.credential(result.token!);

        // Sign in to Firebase with the obtained GitHub token
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        if (userCredential.user != null) {
          Get.snackbar("Congratulations!", "You have successfully signed in.",
              duration: const Duration(seconds: 5),
              backgroundColor: Colors.green,
              colorText: Colors.white);
          Get.offAllNamed('/home');
        } else {
          Get.snackbar("Failed!", "Firebase authentication failed.",
              duration: const Duration(seconds: 7),
              backgroundColor: Colors.lightBlueAccent);
        }
      } else {
        Get.snackbar("Failed!", "GitHub login failed or canceled.",
            duration: const Duration(seconds: 7),
            backgroundColor: Colors.lightBlueAccent);
      }
    } catch (error) {
      Get.snackbar('Error during GitHub login:', error.toString(),
          duration: const Duration(seconds: 7),
          backgroundColor: Colors.lightBlueAccent);
    }
  }

//sign out method
  Future signOut() async {
    await FirebaseAuth.instance.signOut();
  }

//method for checking users having same cnic no.
  Future checkUserExist(String idNo) async {
    bool isDuplicate = false;
    final snapshot = await ref.child('users').get();
    if (snapshot.exists) {
      Map data = await json.decode(json.encode(snapshot.value));

      for (var element in data.values) {
        //check if Identity No Duplicate
        if (element["iNo"] == idNo) {
          isDuplicate = true;
        }
      }
      return isDuplicate;
    } else {
      return isDuplicate;
    }
  }

  Future getSOSData(String userId) async {
    final snapshot = await ref.child('sos/$userId').get();
    if (snapshot.exists) {
      return snapshot.value;
    } else {
      print('No data available.');
    }
  }
}
