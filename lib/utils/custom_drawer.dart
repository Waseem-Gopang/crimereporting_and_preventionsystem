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
    return SafeArea(
      child: AnimatedContainer(
        curve: Curves.easeInOutCubic,
        duration: const Duration(milliseconds: 500),
        width: 300,
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          color: Color.fromRGBO(20, 20, 20, 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          child: Column(children: [
            const Text(
              'Account',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
              maxLines: 1,
            ),
            const Divider(
              color: Colors.grey,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // getAvatar(),
                Padding(
                  padding: const EdgeInsets.only(top: 2.0, left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(
                      //   user!.fName!,
                      //   style: const TextStyle(
                      //       fontSize: 25,
                      //       fontWeight: FontWeight.bold),
                      // ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/editProfile');
                          },
                          child: const Row(
                            children: [
                              Text(
                                "Edit Profile",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                                size: 25,
                              )
                            ],
                          ))
                    ],
                  ),
                )
              ],
            ),
            Column(
              children: [
                getHeaderText("General"),
                getTextButton(
                    text: "Help Center",
                    onTap: () {
                      Navigator.of(context).pushNamed('/helpCenter');
                    }),
                getTextButton(
                    text: "My Post",
                    onTap: () {
                      Navigator.of(context).pushNamed('/myPost');
                    }),
                getTextButton(
                    text: "Send Feedback",
                    onTap: () {
                      getSendFeedbackPopUp();
                    }),
              ],
            ),

            const SizedBox(
              height: 20,
            ),
            //SOS setting

            Column(
              children: [
                getHeaderText("SOS Message"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    getTextButton(text: "Enable SOS Menu Bar", onTap: () {}),
                    Switch(
                      onChanged: (value) {
                        //createPlantFoodNotification();
                        setState(() {
                          if (isSwitched) {
                            // NotificationController
                            //     .dismissNotification();
                            isSwitched = false;
                          } else {
                            // NotificationController
                            //     .createSOSNotification();
                            isSwitched = true;
                          }
                        });
                      },
                      value: isSwitched,
                      activeColor: Colors.grey.shade100,
                      activeTrackColor: Colors.red.shade900,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey,
                    )
                  ],
                ),
                getTextButton(
                    text: "Edit SOS Message Content",
                    onTap: () {
                      Navigator.of(context).pushNamed('/editSOS');
                    }),
                getTextButton(
                    text: "Additional SOS Settings",
                    onTap: () {
                      getSosSettingFormPopUp();
                    }),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            //Emergency Setting

            Column(
              children: [
                getHeaderText("Emergency Contacts"),
                getTextButton(
                    text: "Add Emergency Contacts",
                    onTap: () {
                      getContactFormPopUp();
                    }),
                getTextButton(
                    text: "Manage Emergency Contacts",
                    onTap: () {
                      Navigator.pushNamed(context, '/manageContact');
                    }),
              ],
            ),
          ]),
        ),
      ),
      //),
    );
  }

  getHeaderText(String text) {
    return Text(text,
        style: const TextStyle(
            color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold));
  }

  getTextButton({String? text, Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        child: Text(
          text!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  getAvatar() {
    return url != ""
        ? Container(
            height: 85.0,
            width: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: NetworkImage(url!),
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
          return Text("s"); //SendEmail(title: "Feedback");
        });
  }

  getContactFormPopUp() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Text("show");
          // return AddEmergencyContact(
          //   mapEdit: null,
          //   onEdit: (value) {},
          // );
        });
  }

  getSosSettingFormPopUp() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Text("h"); //SosSettingsPopUp();
        });
  }
}
