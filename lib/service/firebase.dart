import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

Future signOut() async {
  await FirebaseAuth.instance.signOut();
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
