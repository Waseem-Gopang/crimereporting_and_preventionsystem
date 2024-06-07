import 'package:crimereporting_and_preventionsystem/drawer/components/add_contact_popup.dart';
import 'package:crimereporting_and_preventionsystem/drawer/components/livestream.dart';
import 'package:crimereporting_and_preventionsystem/drawer/components/send_email.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isSwitched = false;
  String? imageURL;
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
        imageURL = data['avatar'] ?? currentUser.photoURL;
      });
    } else {
      setState(() {
        imageURL = currentUser.photoURL;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String displayName = getDisplayName(currentUser!);
    return SizedBox(
      width: 300,
      child: Drawer(
        backgroundColor: Colors.transparent,
        elevation: 16,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(55),
              bottomRight: Radius.circular(55),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildProfileHeader(displayName),
                const SizedBox(height: 20),
                buildDrawerItem(
                  icon: Icons.edit,
                  text: "Edit Profile",
                  onTap: () {
                    Navigator.pushNamed(context, '/editProfile');
                  },
                ),
                const SizedBox(height: 20),
                buildDrawerItem(
                  icon: Icons.feedback,
                  text: "Send Feedback",
                  onTap: () {
                    getSendFeedbackPopUp();
                  },
                ),
                const SizedBox(height: 20),
                buildDrawerItem(
                  icon: Icons.message,
                  text: "Edit SOS Message",
                  onTap: () {
                    Navigator.of(context).pushNamed('/editSOS');
                  },
                ),
                const SizedBox(height: 20),
                buildDrawerItem(
                    icon: Icons.videocam,
                    text: "SOS Live Stream",
                    onTap: () {
                      jumpToLiveStream(currentUser.uid, true);
                    }),
                const SizedBox(height: 20),
                buildDrawerItem(
                  icon: Icons.person_add,
                  text: "Add Contacts",
                  onTap: () {
                    getContactFormPopUp();
                  },
                ),
                const SizedBox(height: 20),
                buildDrawerItem(
                  icon: Icons.manage_accounts,
                  text: "Manage Contacts",
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

  Widget buildProfileHeader(String displayName) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "WELCOME",
            style: GoogleFonts.satisfy(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          Center(child: getAvatar()),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(displayName,
                  style: GoogleFonts.satisfy(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget getHeaderText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget buildDrawerItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      horizontalTitleGap: 10,
      dense: true,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget getAvatar() {
    return CircleAvatar(
      radius: 60,
      backgroundColor: Colors.red,
      backgroundImage: imageURL != null ? NetworkImage(imageURL!) : null,
      child: imageURL == null
          ? const Icon(Icons.person, color: Colors.white, size: 40)
          : null,
    );
  }

  void getSendFeedbackPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const SendEmail(title: "Feedback");
      },
    );
  }

  void getContactFormPopUp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddEmergencyContact(
          mapEdit: null,
          onEdit: (value) {},
        );
      },
    );
  }

  void jumpToLiveStream(String liveId, bool isHost) {
    if (liveId.isNotEmpty) {
      Get.to(
        () => LiveStreamingPage(
          liveId: liveId,
          isHost: isHost,
        ),
      );
    } else {
      Get.snackbar("Error", "Please enter a valid ID");
    }
  }
}
