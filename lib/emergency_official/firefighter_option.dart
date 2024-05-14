import 'dart:io';
import 'package:crimereporting_and_preventionsystem/emergency_official/message_sending.dart';
import 'package:crimereporting_and_preventionsystem/utils/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class FireFighterOptions extends StatelessWidget {
  const FireFighterOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final smsController = Get.put(MessageController());
    return Scaffold(
      appBar: customAppBar(title: 'Fire Fighter Options'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              child: ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                tileColor: Colors.red,
                leading: const Icon(
                  Icons.map,
                  color: Colors.black,
                ),
                title: const Text(
                  'Fire Station Map Display',
                  style: TextStyle(color: Colors.black),
                ),
                subtitle: const Text(
                  'Find the nearest fire station on the map',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  Position position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high);
                  var lat = position.latitude;
                  var long = position.longitude;
                  String url = '';
                  if (Platform.isAndroid) {
                    url =
                        "https://www.google.com/maps/search/fire+brigade/@$lat,$long,12.5z";
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      throw 'Could not launch $url';
                    }
                  }
                },
              ),
            ),
            Card(
              child: ListTile(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15.0),
                    ),
                  ),
                  tileColor: Colors.red,
                  leading: const Icon(
                    Icons.call,
                    color: Colors.black,
                  ),
                  title: const Text(
                    'Call',
                    style: TextStyle(color: Colors.black),
                  ),
                  subtitle: const Text(
                    'Directly call the fire station helpline',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    if (await Permission.phone.request().isGranted) {
                      debugPrint("In making phone call");
                      var url = Uri.parse("tel:16");
                      await launchUrl(url);

                      debugPrint("Location Permission is granted");
                    } else {
                      debugPrint("Location Permission is denied.");
                    }
                  }),
            ),
            Card(
              child: ListTile(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(15.0),
                  ),
                ),
                tileColor: Colors.red,
                leading: const Icon(
                  Icons.message,
                  color: Colors.black,
                ),
                title: const Text(
                  'Send Distress Message',
                  style: TextStyle(color: Colors.black),
                ),
                subtitle: const Text(
                  'Send a distress message to emergency contacts',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () async {
                  smsController
                      .sendLocationViaSMS("Fire Emergency\nSend Help at");
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
