import 'package:background_sms/background_sms.dart';
import 'package:crimereporting_and_preventionsystem/home.dart';
import 'package:crimereporting_and_preventionsystem/utils/custom_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../emergency_official/emergencycontacts_controllers.dart';
import '../../utils/theme.dart';
import '../components/add_edit_info_popUp.dart';
import '../models/info_model.dart';

class EditSOSContent extends StatefulWidget {
  const EditSOSContent({Key? key}) : super(key: key);

  @override
  State<EditSOSContent> createState() => _EditSOSContentState();
}

class _EditSOSContentState extends State<EditSOSContent> {
  final emergencyContactsController = Get.put(EmergencyContactsController());
  final _formKey = GlobalKey<FormState>();

  List<Info> infoList = [];
  bool haveInfo = false;

  String? sample;

  String? location;

  User user = FirebaseAuth.instance.currentUser!;

  String message = "SOS! Immediate Help required:";

  String addtionalInfo = "";
  Future<void> _sendSMS(String message, List<String> recipients) async {
    for (var recipient in recipients) {
      SmsStatus status = await BackgroundSms.sendMessage(
        phoneNumber: recipient,
        message: message,
      );

      if (status == SmsStatus.sent) {
        Get.snackbar("SMS", "Distress SMS Sent Successfully");
      } else {
        Get.snackbar("SMS", "Failed to send SMS to $recipient");
      }
    }
  }

  // getInfo() async {
  //   var data = await AuthService().getSOSData(user.uid);

  //   if (data != null && data.containsKey("info")) {
  //     List<dynamic>? infoData = data["info"];
  //     if (infoData != null) {
  //       for (var dt in infoData) {
  //         Map info = dt;
  //         infoList.add(Info(info.keys.first, info.values.first));
  //       }
  //       setState(() {
  //         haveInfo = true;
  //       });
  //     }
  //   }
  // }

  getMessage() async {
    location = await getLocation();
    setState(() {
      message += "\nName: ${user.displayName} \n$location";
    });
  }

  getLocation() async {
    final position = await _determinePosition();
    return "Longitude: ${position.longitude} and Latitude: ${position.latitude}";
  }

  Future<bool> handleSmsPermission() async {
    final status = await Permission.sms.request();
    if (status.isGranted) {
      debugPrint("SMS Permission Granted");
      return true;
    } else {
      debugPrint("SMS Permission Denied");
      return false;
    }
  }

  @override
  void initState() {
    getMessage();
    //getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "Edit SOS Content"),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
              alignment: Alignment.center,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        getTextField(
                          text: message,
                          label: 'Message',
                          readonly: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            color: Colors.grey.shade200,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Add Additional Content",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        getPopUp();
                                      },
                                      icon: Icon(
                                        Icons.add_circle,
                                        size: 30,
                                        color: Colors.red.shade900,
                                      ),
                                    ),
                                  ],
                                ),
                                getAddedList(),
                              ],
                            ),
                          ),
                        ),
                        showSampleMessage(),
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

  getSubmitButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
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
              // Build the final message
              String finalMessage = message + addtionalInfo;

              // Send the SMS using MessageController
              // MessageController messageController =
              //     Get.find<MessageController>();
              // await messageController.sendLocationViaSMS(finalMessage);
              List<String> emergencyContacts = await emergencyContactsController
                  .loadEmergencyContactsFromFirebase();
              if (emergencyContacts.isNotEmpty) {
                await _sendSMS(finalMessage, emergencyContacts);
              } else {
                Get.snackbar("Error", "No emergency contacts found.");
              }

              // Navigate to Home Page after sending the SMS
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomePage()),
                (Route<dynamic> route) => false,
              );
            }
          },
        ),
      ),
    );
  }

  getPopUp() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddEditInfoPopUP(
          onAdd: (value) {
            setState(() {
              infoList.add(value);
              debugPrint(infoList as String?);
              haveInfo = true;
              addtionalInfo += "\n${value.type}: \n${value.description},";
            });
          },
        );
      },
    );
  }

  getAddedList() {
    return Visibility(
      visible: haveInfo,
      child: Container(
        padding: const EdgeInsets.only(bottom: 10),
        child: Container(
          height: 150,
          color: Colors.white,
          child: ListView.builder(
            itemCount: infoList.length,
            itemBuilder: (BuildContext context, int index) {
              addtionalInfo = "";
              for (var i in infoList) {
                addtionalInfo += "\n${i.type}: \n${i.description},";
              }
              return Card(
                child: ListTile(
                  title: Text(infoList[index].type),
                  subtitle: Text(infoList[index].description),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel_outlined),
                    onPressed: () {
                      setState(() {
                        infoList.removeAt(index);

                        infoList = infoList.toList();

                        addtionalInfo = "";
                        for (var i in infoList) {
                          addtionalInfo += "\n${i.type}: \n${i.description},";
                        }
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  showSampleMessage() {
    sample = message + addtionalInfo;
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
              "Sample Message",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            color: Colors.white,
            child: Text(sample!),
          ),
        ],
      ),
    );
  }

  getTextField({
    String? text,
    String? label,
    bool? readonly,
  }) {
    TextEditingController controller = TextEditingController();
    controller.text = text!;
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      decoration: ThemeHelper().inputBoxDecorationShaddow(),
      child: TextFormField(
        controller: controller,
        minLines: 4,
        maxLines: 6,
        readOnly: readonly ?? false,
        decoration:
            ThemeHelper().textInputDecoration(const Icon(Icons.abc), label!),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
