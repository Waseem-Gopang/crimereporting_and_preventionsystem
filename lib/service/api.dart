import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

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
    print("Error uploading image: $e");
    return "";
  }
}

// Future<String> uploadXImage({required XFile file}) async {
//   try {
//     final File fileForFirebase = File(file.path!);
//     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     Reference reference =
//         FirebaseStorage.instance.ref().child('postImages/$fileName');
//     UploadTask uploadTask = reference.putFile(fileForFirebase);
//     TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
//     String imageUrl = await taskSnapshot.ref.getDownloadURL();
//     return imageUrl;
//   } catch (e) {
//     print("Error uploading image: $e");
//     return "";
//   }
// }

// Future<String> uploadFile({required PlatformFile file}) async {
//   try {
//     final File fileForFirebase = File(file.path!);
//     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     Reference reference = FirebaseStorage.instance.ref().child('mediaFiles/$fileName');
//     UploadTask uploadTask = reference.putFile(fileForFirebase);
//     TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
//     String imageUrl = await taskSnapshot.ref.getDownloadURL();
//     return imageUrl;
//   } catch (e) {
//     print("Error uploading file: $e");
//     return "";
//   }
//}
