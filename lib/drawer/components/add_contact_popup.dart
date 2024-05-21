import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../utils/theme.dart';
import '../models/contact_model.dart';

class AddEmergencyContact extends StatefulWidget {
  final mapEdit;
  final Function(Contact) onEdit;

  const AddEmergencyContact(
      {Key? key, required this.mapEdit, required this.onEdit})
      : super(key: key);

  @override
  State<AddEmergencyContact> createState() => _AddEmergencyContactState();
}

class _AddEmergencyContactState extends State<AddEmergencyContact> {
  bool isEdit = false;
  final _formKey = GlobalKey<FormState>();

  String? id;
  String? fName = "";
  String? relation = "";
  String? contactNo = "";

  String uID = FirebaseAuth.instance.currentUser!.uid;

  Contact? contact;
  List<String> type = [
    'Father',
    'Mother',
    'Brother',
    'Sister',
    'Husband',
    'Wife',
    'Son',
    'Daughter',
    'Guardian',
    'Other'
  ];

  @override
  void initState() {
    if (widget.mapEdit != null) {
      isEdit = true;
      id = widget.mapEdit.id;
      fName = widget.mapEdit.fname;
      relation = widget.mapEdit.relation;
      contactNo = widget.mapEdit.contactNo;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: isEdit
          ? const Text('Edit Emergency Contact')
          : const Text('Add Emergency Contact'),
      scrollable: true,
      content: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              getTextField(
                  text: fName,
                  label: 'Full Name',
                  hint: 'Enter name of the person',
                  valError: 'Please enter the name',
                  onChanged: (value) {
                    fName = value;
                  }),
              isEdit ? selectEditRelationField() : selectRelationField(),
              getTextField(
                text: contactNo,
                label: 'Contact Number',
                hint: 'Enter contact no. of the person',
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Please enter the contact no.";
                  } else if ((val.isNotEmpty) &&
                      !RegExp(r"^(\d+)*$").hasMatch(val)) {
                    return "Enter a valid contact no.";
                  }
                  return null;
                },
                onChanged: (value) {
                  contactNo = value;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black)),
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        isEdit
            ? ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.red.shade900)),
                child: const Text(
                  "Update",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    var contact = Contact(id!, fName!, relation!, contactNo);
                    widget.onEdit(contact);
                    Navigator.of(context).pop();
                  });
                })
            : ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.red.shade900)),
                child: const Text(
                  "Add",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    DatabaseReference contactRef = FirebaseDatabase.instance
                        .ref()
                        .child('contacts')
                        .child(uID);

                    String contactID = contactRef.push().key!;

                    //add new emergency contact information to database
                    contactRef.child(contactID).set({
                      'fname': fName,
                      'relation': relation,
                      'contactNo': contactNo,
                    });

                    Fluttertoast.showToast(
                        msg: "New Contact Added Successfully");

                    Navigator.of(context).pop();
                  });
                }),
      ],
    );
  }

  selectRelationField() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
          width: 400,
          padding: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              isExpanded: true,
              hint: const Text("Please select your relation"),
              items: type.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              validator: (value) {
                if (relation == null) {
                  return "Please select your relation";
                }
                return null;
              },
              onChanged: (value) {
                relation = value.toString();
              },
            ),
          )),
    );
  }

  selectEditRelationField() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
          width: 400,
          padding: const EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              isExpanded: true,
              value: relation!,
              hint: const Text("Please select your relation"),
              items: type.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              validator: (value) {
                if (relation == null) {
                  return "Please select your relation";
                }
                return null;
              },
              onChanged: (value) {
                relation = value.toString();
              },
            ),
          )),
    );
  }

  getTextField(
      {String? text,
      Icon? prefixIcon,
      String? label,
      String? hint,
      String? valError,
      IconButton? suffixIcon,
      Function(String)? onChanged,
      bool? obscureText,
      String? Function(String?)? validator}) {
    TextEditingController controller = TextEditingController();
    controller.text = text!;

    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: ThemeHelper().inputBoxDecorationShaddow(),
      child: TextFormField(
        controller: isEdit ? controller : null,
        decoration:
            ThemeHelper().textInputDecoration(prefixIcon, label!, hint!),
        onChanged: onChanged,
        validator: validator ??
            (val) {
              if (val!.isEmpty) {
                return valError;
              }
              return null;
            },
      ),
    );
  }
}
