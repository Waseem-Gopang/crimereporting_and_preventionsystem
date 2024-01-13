import 'package:background_sms/background_sms.dart';
import 'package:crimereporting_and_preventionsystem/emergency_official/emergencycontacts_controllers.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class MessageController extends GetxController {
  static MessageController get instance => Get.find();
  final emergencyContactsController = Get.put(EmergencyContactsController());

  String? _currentAddress;
  Position? _currentPosition;
  Future<void> _sendSMS(String message, List<String> recipients) async {
    for (var i = 0; i < recipients.length; i++) {
      SmsStatus status = await BackgroundSms.sendMessage(
        phoneNumber: recipients[i].toString(),
        message: message,
      );

      if (status == SmsStatus.sent) {
        Get.snackbar("SMS", "Distress SMS Sent Successfully");
      }
    }

    print(recipients);
  }

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar("Disabled",
          'Location services are disabled. Please enable the services');
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar("Rejected", 'Location Permissions are denied.');
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Get.snackbar("Rejected",
          'Location permissions are permanently denied, we cannot request permissions.');
      return false;
    }
    return true;
  }

  handleSmsPermission() async {
    final status = await Permission.sms.request();
    if (status.isGranted) {
      debugPrint("SMS Permission Granted");
      return true;
    } else {
      debugPrint("SMS Permission Denied");
      return false;
    }
  }

  Future<Position> getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();

    if (!hasPermission) {
      return Position(
          latitude: 0,
          longitude: 0,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0);
    }
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      _currentPosition = position;
      _getAddressFromLatLng(_currentPosition!);
      return _currentPosition!;
    }).catchError((e) {
      debugPrint(e);
    });
    return Position(
        latitude: 0,
        longitude: 0,
        timestamp: DateTime.now(),
        accuracy: 0,
        altitude: 0,
        heading: 0,
        speed: 0,
        speedAccuracy: 0,
        altitudeAccuracy: 0,
        headingAccuracy: 0);
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    try {
      final List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> sendLocationViaSMS(String emergencyType) async {
    await getCurrentPosition().then((currentAddress) async {
      if (_currentAddress != null) {
        String message =
            "HELP me! There is an $emergencyType \n http://www.google.com/maps/place/${_currentPosition!.latitude},${_currentPosition!.longitude}}";
        await emergencyContactsController
            .loadData()
            .then((emergencyContacts) => _sendSMS(message, emergencyContacts));
      } else {}
    });
  }
}
