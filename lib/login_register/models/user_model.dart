//import '../../service/logger.dart';

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

  User();
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
