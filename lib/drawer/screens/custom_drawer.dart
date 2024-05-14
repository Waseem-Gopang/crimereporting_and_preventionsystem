import 'package:crimereporting_and_preventionsystem/drawer/components/add_contact_popup.dart';
import 'package:crimereporting_and_preventionsystem/drawer/components/send_email.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({Key? key}) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isSwitched = false;
  String? url;

  @override
  Widget build(BuildContext context) {
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
                getTextButton(
                  text: "Send Feedback",
                  onTap: () {
                    getSendFeedbackPopUp();
                  },
                ),
                const SizedBox(height: 20),
                getHeaderText("SOS Message"),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getTextButton(
                      text: "Enable SOS Menu Bar",
                      onTap: () {},
                    ),
                    Switch(
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                        });
                      },
                      value: isSwitched,
                      activeColor: Colors.greenAccent.shade400,
                      activeTrackColor: Colors.green.shade800,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey,
                    ),
                  ],
                ),
                getTextButton(
                  text: "Edit SOS Message Content",
                  onTap: () {
                    Navigator.of(context).pushNamed('/editSOS');
                  },
                ),
                getTextButton(
                  text: "Additional SOS Settings",
                  onTap: () {
                    getSosSettingFormPopUp();
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

  getSosSettingFormPopUp() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("SOS Settings"),
          content: const Text("This is where you can adjust SOS settings."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
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
