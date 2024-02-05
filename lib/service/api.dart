import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<String> uploadImage({required File file}) async {
  try {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference reference =
        FirebaseStorage.instance.ref().child('images/$fileName');
    UploadTask uploadTask = reference.putFile(file);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  } catch (e) {
    Get.snackbar("Error uploading image:", e.toString(),
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.lightBlueAccent);
    return "";
  }
}

Future<String> uploadFile({required PlatformFile file}) async {
  final File fileForFirebase = File(file.path!);
  var fileName = fileForFirebase.path.split('/').last;
  final path = 'Evidences/$fileName';
  UploadTask? uploadTask;

  final ref = FirebaseStorage.instance.ref().child(path);
  uploadTask = ref.putFile(fileForFirebase);

  final snapshot = await uploadTask.whenComplete(() {});

  final urlDownload = await snapshot.ref.getDownloadURL();
  return urlDownload;
}
