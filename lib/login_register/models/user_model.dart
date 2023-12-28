//import '../../service/logger.dart';

import 'package:firebase_database/firebase_database.dart';

class User {
  bool isLoggedIn = false;
  String? uId;
  String? fName;
  String? avatar;
  String? iNo;
  String? pass;
  String? dob;
  String? email;
  String? mobileNo;
  String? address;
  String? country;
  String? state;
  String? city;
  String? zipcode;

  //final _log = logger();
  User({
    required this.fName,
    required this.email,
    required this.mobileNo,
    required this.uId,
    this.avatar,
    this.address,
    this.city,
    this.state,
    this.country,
    this.zipcode,
  });
  User.fromSnapshot(DataSnapshot dataSnapshot) {
    uId = dataSnapshot.key!;
    var data = dataSnapshot.value as Map?;
    if (data != null) {
      email = data["email"];
      fName = data["UserName"];
      mobileNo = data["Phone"];
    }
  }

  //User();
  User.otherUser(this.avatar, this.fName);

  void setUserInfo(String userID, Map data) {
    isLoggedIn = true;
    uId = userID;
    fName = data['fName'];
    iNo = data['iNo'];
    dob = data['dob'];
    avatar = data['avatar'];
    email = data['email'];
    mobileNo = data['phone'];
    address = data['address'];
    country = data['country'];
    state = data['state'];
    city = data['city'];
    zipcode = data['zCode'];
  }

  clearUserInfo() {
    isLoggedIn = false;
    uId = null;
    fName = null;
    iNo = null;
    dob = null;
    avatar = null;
    email = null;
    mobileNo = null;
    address = null;
    country = null;
    state = null;
    city = null;
    zipcode = null;
  }
}
