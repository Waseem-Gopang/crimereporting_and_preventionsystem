import 'package:crimereporting_and_preventionsystem/drawer/components/add_contact_popup.dart';
import 'package:crimereporting_and_preventionsystem/drawer/components/send_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isSwitched = false;
  String? imageURL =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT98A0_6JOy9FNLcNjipGe4xSgzGiCTfgLybw&usqp=CAU';

  late User currentUser;
  late DatabaseReference userRef;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser!;
    userRef =
        FirebaseDatabase.instance.ref().child('users').child(currentUser.uid);
    fetchUserImage();
  }

  void fetchUserImage() async {
    final snapshot = await userRef.get();
    if (snapshot.exists) {
      Map data = snapshot.value as Map;
      setState(() {
        imageURL = data['avatar'] ?? currentUser.photoURL ?? imageURL;
        //haveImage = imageURL.isNotEmpty;
      });
    } else {
      // If no data in database, use Google account information
      setState(() {
        imageURL = currentUser.photoURL ?? imageURL;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User currentUser = FirebaseAuth.instance.currentUser!;
    String displayName = getDisplayName(currentUser);
    return SizedBox(
      width: 300,
      child: Drawer(
        elevation: 16,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.red.shade800,
                Colors.red.shade700,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      top: 20, right: 10, left: 10, bottom: 10),
                  color: Colors.grey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      getAvatar(),
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0, left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/editProfile');
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      "Edit Profile",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.red.shade900),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: Colors.red.shade900,
                                      size: 25,
                                    )
                                  ],
                                ))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                getTextButton(
                  text: "Send Feedback",
                  onTap: () {
                    getSendFeedbackPopUp();
                  },
                ),
                const SizedBox(height: 20),
                getHeaderText("SOS Message"),
                const SizedBox(height: 10),
                getTextButton(
                  text: "Edit SOS Message Content",
                  onTap: () {
                    Navigator.of(context).pushNamed('/editSOS');
                  },
                ),
                const SizedBox(height: 20),
                getHeaderText("Emergency Contacts"),
                const SizedBox(height: 10),
                getTextButton(
                  text: "Add Emergency Contacts",
                  onTap: () {
                    getContactFormPopUp();
                  },
                ),
                getTextButton(
                  text: "Manage Emergency Contacts",
                  onTap: () {
                    Navigator.pushNamed(context, '/manageContact');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getDisplayName(User user) {
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      return user.displayName!;
    } else if (user.email != null && user.email!.isNotEmpty) {
      return user.email!
          .split('@')[0]; // Use email prefix if displayName is null
    }
    return 'User';
  }

  Widget getHeaderText(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget getTextButton({String? text, Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          text!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  getAvatar() {
    return imageURL != ""
        ? Container(
            height: 85.0,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: NetworkImage(imageURL!),
                fit: BoxFit.cover,
              ), // border color
              borderRadius: const BorderRadius.all(Radius.circular(50.0)),
              border: Border.all(
                color: Colors.red.shade900,
                width: 1.0,
              ),
            ),
            child: Container())
        : Container(
            height: 85.0,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.white, // border color
              borderRadius: const BorderRadius.all(Radius.circular(50.0)),
              border: Border.all(
                color: Colors.red.shade900,
                width: 3.0,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: Icon(
                Icons.person,
                color: Colors.red.shade900,
                size: 78.0,
              ),
            ));
  }

  getSendFeedbackPopUp() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return const SendEmail(title: "Feedback");
        });
  }

  getContactFormPopUp() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddEmergencyContact(
            mapEdit: null,
            onEdit: (value) {},
          );
        });
  }
}
