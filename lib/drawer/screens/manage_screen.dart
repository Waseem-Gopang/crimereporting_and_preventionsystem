import 'dart:convert';

import 'package:crimereporting_and_preventionsystem/utils/custom_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../components/add_contact_popup.dart';
import '../models/contact_model.dart';

class ManageEmergencyContact extends StatefulWidget {
  const ManageEmergencyContact({Key? key}) : super(key: key);

  @override
  State<ManageEmergencyContact> createState() => _ManageEmergencyContactState();
}

class _ManageEmergencyContactState extends State<ManageEmergencyContact> {
  List<Contact> contactList = [];

  bool haveContact = false;

  String uID = FirebaseAuth.instance.currentUser!.uid;
  var contactRef;

  getContactList() async {
    contactList = [];
    contactRef = FirebaseDatabase.instance.ref().child('contacts').child(uID);
    await contactRef.onValue.listen((event) async {
      for (final child in event.snapshot.children) {
        String id = await json.decode(json.encode(child.key));
        Map data = await json.decode(json.encode(child.value));

        contactList.add(
            Contact(id, data["fname"], data["relation"], data["contactNo"]));
      }
      setState(() {
        haveContact = true;
      });
    }, onError: (error) {
      debugPrint('Error getting contacts');
    });
  }

  @override
  void initState() {
    super.initState();
    getContactList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(
        title: "Manage Contacts",
      ),
      body: haveContact
          ? ListView.builder(
              itemCount: contactList.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                  child: Card(
                    child: ListTile(
                        leading: Text(contactList[index].relation!),
                        title: Text(contactList[index].fname!),
                        subtitle: Text(contactList[index].contactNo!),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.green.shade900,
                                ),
                                onPressed: () {
                                  getContactFormPopUp(contactList[index]);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red.shade900,
                                ),
                                onPressed: () {
                                  setState(() {
                                    contactRef
                                        .child(contactList[index].id!)
                                        .remove();
                                    Fluttertoast.showToast(
                                        msg: "Contact deleted Successfully");
                                    contactList = [];
                                  });
                                },
                              ),
                            ],
                          ),
                        )),
                  ),
                );
              })
          : const Text(
              'No contacts added yet!',
              style: TextStyle(fontSize: 20),
            ),
    );
  }

  getContactFormPopUp(Contact contact) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddEmergencyContact(
            mapEdit: contact,
            onEdit: (value) {
              DatabaseReference contactRef =
                  FirebaseDatabase.instance.ref().child('contacts').child(uID);

              contactRef.child(value.id!).update({
                'fname': value.fname,
                'relation': value.relation,
                'contactNo': value.contactNo,
              });
              Fluttertoast.showToast(
                  msg: "Contact Details updated Successfully");
              contactList = [];
            },
          );
        });
  }
}
