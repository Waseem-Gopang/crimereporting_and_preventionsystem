import 'package:flutter/material.dart';

import '../../utils/theme.dart';
import '../models/info_model.dart';

class AddEditInfoPopUP extends StatefulWidget {
  final Function(Info) onAdd;

  const AddEditInfoPopUP({Key? key, required this.onAdd}) : super(key: key);

  @override
  State<AddEditInfoPopUP> createState() => _AddEditInfoPopUPState();
}

class _AddEditInfoPopUPState extends State<AddEditInfoPopUP> {
  String? description;
  String? type;

  Info? info;
  List<String> infoType = ['Medical', 'Other'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Additional Content'),
      scrollable: true,
      content: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Form(
          child: Column(
            children: <Widget>[selectTypeField(), getContentField()],
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
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.red.shade900)),
            child: const Text(
              "Add",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              info = Info(type!, description!);
              widget.onAdd(info!);
              Navigator.of(context).pop();
            })
      ],
    );
  }

  selectTypeField() {
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
              hint: const Text("Select type of detail"),
              items: infoType.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              validator: (value) {
                if (type == null) {
                  return "Please select the type of info";
                }
                return null;
              },
              onChanged: (value) {
                type = value.toString();
              },
            ),
          )),
    );
  }

  getContentField() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      decoration: ThemeHelper().inputBoxDecorationShaddow(),
      child: TextFormField(
        minLines: 3,
        maxLines: 5,
        keyboardType: TextInputType.multiline,
        decoration: ThemeHelper().textInputDecoReport(
            "Enter the additional details content to attach in the SOS SMS"),
        onChanged: (val) {
          setState(() {
            description = val;
          });
        },
        validator: (val) {
          if (val!.isEmpty) {
            return "Content is required";
          }
          return null;
        },
      ),
    );
  }
}
