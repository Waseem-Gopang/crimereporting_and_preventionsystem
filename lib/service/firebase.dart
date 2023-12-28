import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:twitter_login/twitter_login.dart';

final ref = FirebaseDatabase.instance.ref();

//User methods
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
    print(e);
    return false;
  }
}

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
      Fluttertoast.showToast(msg: "The account already exists for that email.");
    }
    return false;
  } catch (e) {
    print(e.toString());
  }
}

Future<String> fetchUserID() async {
  final User? user = FirebaseAuth.instance.currentUser;
  return user!.uid;
}

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();
final TwitterLogin twitterLogin = TwitterLogin(
  apiKey: 'nYzaVyn9f5t9nyk7QZMIDooUW',
  apiSecretKey: 'hccDtYqBGo0rtFj1SkXtsvAKZZ6LQU0Tx7GS2ZmtmvJAv4UM32',
  redirectURI:
      'https://crimereportingandprevent-22511.firebaseapp.com/__/auth/handler',
);
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
    print("Google Sign-In Error: $e");
    return null;
  }
}

Future<void> signInWithFacebook() async {
  try {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      final AccessToken accessToken = result.accessToken!;
      final AuthCredential credential =
          FacebookAuthProvider.credential(accessToken.token);

      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User user = authResult.user!;

      print('User ID: ${user.uid}');
      print('Display Name: ${user.displayName}');
      print('Email: ${user.email}');
    } else {
      print('Facebook login failed');
    }
  } catch (e) {
    print('Error: $e');
  }
}

Future<User?> signInWithTwitter() async {
  final result = await twitterLogin.login();

  switch (result.status) {
    case TwitterLoginStatus.loggedIn:
      final AuthCredential credential = TwitterAuthProvider.credential(
        accessToken: result.authToken!,
        secret: result.authTokenSecret!,
      );

      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return authResult.user;

    case TwitterLoginStatus.cancelledByUser:
      print('Twitter login canceled by user');
      return null;

    case TwitterLoginStatus.error:
      print('Twitter login error: ${result.errorMessage}');
      return null;
    case null:
    // TODO: Handle this case.
  }
  return null;
}

Future signOut() async {
  await FirebaseAuth.instance.signOut();
  await googleSignIn.signOut();
  //await Global.instance.logout();
}

Future checkUserExist(String idNo) async {
  bool isDuplicate = false;
  final snapshot = await ref.child('users').get();
  if (snapshot.exists) {
    Map data = await json.decode(json.encode(snapshot.value));

    data.values.forEach((element) {
      //check if Identity No Duplicate
      if (element["iNo"] == idNo) {
        isDuplicate = true;
      }
    });
    return isDuplicate;
  } else {
    return isDuplicate;
  }
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

//SOS methods
Future getSOSData(String userId) async {
  final snapshot = await ref.child('sos/$userId').get();
  if (snapshot.exists) {
    return snapshot.value;
  } else {
    print('No data available.');
  }
}

//SOS methods
Future getRecipientContact(String userId) async {
  List<String> recipientList = [];
  final contactRef = FirebaseDatabase.instance.ref().child('contacts/$userId');
  await contactRef.onValue.listen((event) async {
    for (final child in event.snapshot.children) {
      final contactID = await json.decode(json.encode(child.key));
      Map data = await json.decode(json.encode(child.value));

      recipientList.add(data["contactNo"]);
    }
  });
  return recipientList;
}
