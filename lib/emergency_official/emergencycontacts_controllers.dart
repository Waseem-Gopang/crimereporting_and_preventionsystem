import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmergencyContactsController extends GetxController {
  static EmergencyContactsController get instance => Get.find();

  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();
  final String uID = FirebaseAuth.instance.currentUser!.uid;

  // Method to load emergency contacts from Firebase Realtime Database
  Future<List<String>> loadEmergencyContactsFromFirebase() async {
    List<String> emergencyContacts = [];
    try {
      DataSnapshot snapshot = await _dbRef.child('contacts').child(uID).get();
      if (snapshot.exists) {
        Map<dynamic, dynamic> contacts =
            snapshot.value as Map<dynamic, dynamic>;
        contacts.forEach((key, value) {
          emergencyContacts.add(value['contactNo']);
        });
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load emergency contacts: $e",
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    return emergencyContacts;
  }
}
