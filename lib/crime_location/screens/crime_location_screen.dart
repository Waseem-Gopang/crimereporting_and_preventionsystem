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
                      title: Text(data["type"]),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("Date: ${data["date"]}"),
                          Text("Time: ${data["time"]}"),
                          Text("Description: ${data["descr"]}"),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
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
      print('Error getting post List');
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
          //Container(
          // padding: const EdgeInsets.all(10),
          // child: ElevatedButton(
          //   onPressed: () {}, //_handlePressButton,
          //   style: ButtonStyle(
          //     backgroundColor: MaterialStateProperty.all(Colors.white),
          //     padding: MaterialStateProperty.all(const EdgeInsets.all(10)),
          //   ),
          //   child: Row(
          //     children: [
          // Icon(
          //   Icons.search,
          //   color: Colors.red.shade900,
          // ),
          // const SizedBox(
          //   width: 10,
          // ),
          // Text(
          //   "Enter Area, City or State",
          //   style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
          // )
          // ],
          //),
          //),
          // ),
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

  // Future<void> _handlePressButton() async {
  //   try {
  //     Prediction? p = await PlacesAutocomplete.show(
  //       context: context,
  //       apiKey: kGoogleApiKey,
  //       onError: onError,
  //       mode: _mode,
  //       language: 'en',
  //       strictbounds: false,
  //       types: [""],
  //       logo: Container(
  //         height: 1,
  //       ),
  //       decoration: InputDecoration(
  //         hintText: 'Enter Area, City or State',
  //         focusedBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(20),
  //           borderSide: const BorderSide(color: Colors.white),
  //         ),
  //       ),
  //       components: [
  //         Component(Component.country, "pk"),
  //         Component(Component.country, "usa"),
  //         Component(Component.country, "my"),
  //       ],
  //     );

  //     if (p != null) {
  //       displayPrediction(p, homeScaffoldKey.currentState);
  //     } else {
  //       print('Prediction is null.');
  //     }
  //   } catch (error) {
  //     print('Error during place autocomplete: $error');
  //   }
  // }

  // void onError(PlacesAutocompleteResponse response) {
  //   print('Error during place autocomplete: ${response.errorMessage}');
  // }

  // Future<void> displayPrediction(
  //     Prediction p, ScaffoldState? currentState) async {
  //   try {
  //     GoogleMapsPlaces places = GoogleMapsPlaces(
  //       apiKey: kGoogleApiKey,
  //       apiHeaders: await const GoogleApiHeaders().getHeaders(),
  //     );

  //     PlacesDetailsResponse detail =
  //         await places.getDetailsByPlaceId(p.placeId!);

  //     lat = detail.result.geometry!.location.lat;
  //     lng = detail.result.geometry!.location.lng;

  //     // Add marker for the selected place
  //     markersList.add(
  //       Marker(
  //         markerId: const MarkerId("0"),
  //         position: LatLng(lat, lng),
  //         icon:
  //             BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
  //         infoWindow: InfoWindow(title: detail.result.name),
  //       ),
  //     );

  //     // Set camera to the place selected
  //     setState(() async {
  //       getCrimeAlerts();
  //       googleMapController
  //           .animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  //     });
  //   } catch (error) {
  //     print('Error during place details retrieval: $error');
  //   }
  // }

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }
}
