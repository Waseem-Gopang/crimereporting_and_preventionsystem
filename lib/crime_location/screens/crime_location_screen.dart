import 'dart:convert';
import 'package:crimereporting_and_preventionsystem/utils/bottom_navbar.dart';
import 'package:crimereporting_and_preventionsystem/utils/custom_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/alert_model.dart';

class CrimeAlertsScreen extends StatefulWidget {
  const CrimeAlertsScreen({Key? key}) : super(key: key);

  @override
  State<CrimeAlertsScreen> createState() => _CrimeAlertsScreenState();
}

const kGoogleApiKey =
    'AIzaSyCgHCbmvovZvbTqg-DUBRWUm8HVJfVfXsY'; // Replace with your Google API key
final homeScaffoldKey = GlobalKey<ScaffoldState>();

class _CrimeAlertsScreenState extends State<CrimeAlertsScreen> {
  MapType _currentMapType = MapType.normal; // Default map type

  CameraPosition? initialCameraPosition;

  Set<Marker> markersList = {};
  List<Alert> alerts = [];

  double lng = 2.814014;
  double lat = 101.758337;
  late GoogleMapController googleMapController;

  getCurrentLocation() async {
    final position = await _determinePosition();
    setState(() {
      lng = position.longitude;
      lat = position.latitude;

      markersList.add(Marker(
          markerId: const MarkerId("0"),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueViolet)));

      googleMapController.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 14.0)));
      getCrimeAlerts();
    });
  }

  Future getAlertList() async {
    final reportRef = FirebaseDatabase.instance.ref().child('reports');
    reportRef.onValue.listen((event) async {
      for (final child in event.snapshot.children) {
        final alertID = await json.decode(json.encode(child.key));
        Map data = await json.decode(json.encode(child.value));

        var lt = double.parse(data['latitude']);
        var ln = double.parse(data['longitude']);

        markersList.add(
          Marker(
            markerId: MarkerId(alertID),
            position: LatLng(lt, ln),
            infoWindow: InfoWindow(
              title: data["type"],
              snippet: "click to see more", //data["date"],
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      title: Text(
                        data["type"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Icon(Icons.calendar_today, size: 16),
                                SizedBox(width: 8),
                                Text("Date: ${data["date"]}"),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Icon(Icons.access_time, size: 16),
                                SizedBox(width: 8),
                                Text("Time: ${data["time"]}"),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Icon(Icons.description, size: 16),
                                SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    "Description: ${data["descr"]}",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        );
      }
      setState(() {});
    }, onError: (error) {
      debugPrint('Error getting post List');
    });
  }

  getCrimeAlerts() async {
    await getAlertList();
    setState(() {});
  }

  @override
  void initState() {
    initialCameraPosition =
        CameraPosition(target: LatLng(lng, lat), zoom: 16.0);
    super.initState();
    getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: 'Crime Locations'),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition!,
            markers: markersList.map((e) => e).toSet(),
            mapType: _currentMapType,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding:
                  const EdgeInsets.only(bottom: 10.0, left: 10, right: 100),
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.deepPurple.shade400,
                    ),
                    const Text(
                      "Current Location",
                      style: TextStyle(fontSize: 12),
                    ),
                    const Icon(
                      Icons.location_on,
                      color: Colors.red,
                    ),
                    const Text(
                      "Crime locators",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              top: 80,
              right: 25,
              child: FloatingActionButton(
                onPressed: _onMapTypeButtonPressed,
                materialTapTargetSize: MaterialTapTargetSize.padded,
                backgroundColor: Colors.red,
                child: const Icon(Icons.map, size: 32.0),
              )),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        defaultSelectedIndex: 0,
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(
          msg: "Please enable the location services to use this feature");
      return Future.error('Location services are disabled');
    }
    //get permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }
    //get location using geolocator
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return position;
  }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }
}
