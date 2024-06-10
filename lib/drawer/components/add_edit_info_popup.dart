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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Additional Content'),
      scrollable: true,
      content: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Form(
          child: Column(
            children: <Widget>[getContentField()],
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
              info = Info(description!);
              widget.onAdd(info!);
              Navigator.of(context).pop();
            })
      ],
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
