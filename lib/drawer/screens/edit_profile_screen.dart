import 'dart:convert';
import 'package:crimereporting_and_preventionsystem/home.dart';
import 'package:crimereporting_and_preventionsystem/utils/custom_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../service/api.dart';

import '../../utils/theme.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();

  String imageURL =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT98A0_6JOy9FNLcNjipGe4xSgzGiCTfgLybw&usqp=CAU';
  late User currentUser;
  late DatabaseReference userRef;

  var uID;
  String fName = "";
  String iNo = "";
  String email = "";
  String mobileNo = "";
  String address = "";
  String zipcode = "";

  File? image;

  // bool haveImage = false;

  TextEditingController dateCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser!;
    userRef =
        FirebaseDatabase.instance.ref().child('users').child(currentUser.uid);
    fetchUserData();
  }

  void fetchUserData() async {
    final snapshot = await userRef.get();
    if (snapshot.exists) {
      Map data = snapshot.value as Map;
      setState(() {
        fName = data['fName'] ?? currentUser.displayName ?? '';
        iNo = data['iNo'] ?? '';
        email = data['email'] ?? currentUser.email ?? '';
        imageURL = data['avatar'] ?? currentUser.photoURL ?? imageURL;
        dateCtl.text = data['dob'] ?? '';
        mobileNo = data['phone'] ?? '';
        address = data['address'] ?? '';
        zipcode = data['zCode'] ?? '';
        //haveImage = imageURL.isNotEmpty;
      });
    } else {
      // If no data in database, use Google account information
      setState(() {
        fName = currentUser.displayName ?? '';
        email = currentUser.email ?? '';
        imageURL = currentUser.photoURL ?? imageURL;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: "Edit Profile",
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        getAvatarPicker(),
                        const SizedBox(
                          height: 30,
                        ),
                        getTextField(
                            text: fName,
                            isEdit: true,
                            decoration: ThemeHelper().textInputDecoration(
                                const Icon(Icons.person_rounded),
                                'Full Name',
                                ' '),
                            onChanged: (value) {
                              fName = value;
                            }),
                        getTextField(
                            text: iNo,
                            isEdit: true,
                            decoration: ThemeHelper().textInputDecoration(
                                const Icon(Icons.badge_outlined),
                                'CNIC No.',
                                ' '),
                            onChanged: (value) {
                              iNo = value;
                            }),
                        Container(
                          decoration: ThemeHelper().inputBoxDecorationShaddow(),
                          child: TextFormField(
                            controller: dateCtl,
                            onChanged: (value) {
                              dateCtl = value as TextEditingController;
                            },
                            decoration: ThemeHelper().textInputDecoration(
                                const Icon(Icons.today), 'Date of Birth', ' '),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        getTextField(
                          text: email,
                          isEdit: true,
                          decoration: ThemeHelper().textInputDecoration(
                              const Icon(Icons.email_outlined),
                              'E-mail address',
                              ''),
                          valError: 'Please enter your email',
                          onChanged: (value) {
                            email = value;
                          },
                        ),
                        getTextField(
                          text: mobileNo,
                          isEdit: true,
                          decoration: ThemeHelper().textInputDecoration(
                              const Icon(Icons.phone),
                              'Mobile Number',
                              'Enter your mobile number'),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Please enter the mobile number";
                            } else if ((val.isNotEmpty) &&
                                !RegExp(r"^(\d+)*$").hasMatch(val)) {
                              return "Enter a valid mobile number";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            mobileNo = value;
                          },
                        ),
                        getTextField(
                          text: address,
                          isEdit: true,
                          decoration: ThemeHelper().textInputDecoration(
                              const Icon(Icons.business),
                              'Address',
                              'Enter your house/unit no, and street'),
                          valError: 'Please enter your address',
                          onChanged: (value) {
                            address = value;
                          },
                        ),
                        //const SizedBox(height: 20.0),
                        getTextField(
                          text: zipcode,
                          isEdit: true,
                          decoration: ThemeHelper().textInputDecoration(
                              const Icon(Icons.location_on),
                              'Zip Code',
                              'Enter your zip code'),
                          valError: 'Please enter your zip code',
                          onChanged: (value) {
                            zipcode = value;
                          },
                        ),
                        getSubmitButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void pickImage() async {
    XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {
        print('The file name is :$image');
      });
    } else {
      print('No image selected.');
    }
  }

  getAvatarPicker() {
    return GestureDetector(
      onTap: () {
        setState(() {
          pickImage();
        });
      },
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(width: 5, color: Colors.white),
              color: Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 20,
                  offset: Offset(5, 5),
                ),
              ],
              image: DecorationImage(
                image: image != null
                    ? FileImage(image!)
                    : NetworkImage(imageURL) as ImageProvider,
              ),
            ),
            child: Icon(
              Icons.person,
              color: Colors.grey.withOpacity(0.02),
              size: 80.0,
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(80, 80, 0, 0),
            child: Icon(
              Icons.add_circle,
              color: Colors.grey.shade700,
              size: 25.0,
            ),
          ),
        ],
      ),
    );
  }

  getSubmitButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Container(
        decoration: ThemeHelper().buttonBoxDecoration(context),
        child: ElevatedButton(
          style: ThemeHelper().buttonStyle(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: Text(
              "Submit".toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              uID = FirebaseAuth.instance.currentUser!.uid;
              print(uID);
              var iURL = image != null
                  ? await uploadImage(file: image!)
                  : currentUser.photoURL!;

              DatabaseReference userRef =
                  FirebaseDatabase.instance.ref().child('users');

              await userRef.child(uID.toString()).update({
                'fName': fName,
                'iNo': iNo,
                'email': email,
                'dob': dateCtl.text,
                'phone': mobileNo,
                'avatar': iURL,
                'address': address,
                'zCode': zipcode
              });

              //get user data snapshot
              final snapshot = await userRef.child(uID.toString()).get();
              if (snapshot.exists) {
                Map data = await json.decode(json.encode(snapshot.value));
                //set new data to Global User instance
                // setUserInfo(uID.toString(), data);
                Fluttertoast.showToast(
                    msg: "Profile Details Updated Successfully");
                if (image != null) {
                  //edit user profile in posts data
                  // await editAvatarPostList();
                }
                ;
              } else {
                Fluttertoast.showToast(msg: 'Error Updating user profile');
              }

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (Route<dynamic> route) => false);
            }
          },
        ),
      ),
    );
  }
}
