import 'package:crimereporting_and_preventionsystem/login_register/screens/login_screen.dart';
import 'package:crimereporting_and_preventionsystem/service/firebase.dart';
import 'package:crimereporting_and_preventionsystem/utils/bottom_navbar.dart';
import 'package:crimereporting_and_preventionsystem/utils/custom_drawer.dart';
import 'package:crimereporting_and_preventionsystem/utils/custom_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBarAction(
        title: 'Home Page',
        actions: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () async {
            await _authService.signOut();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
            );
          },
        ),
      ),
      drawer: const CustomDrawer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              homepageButton(
                  "Crime Locations",
                  'Locate the past crimes occurred in your nearby areas!',
                  '/crimeAlert',
                  Icons.map),
              homepageButton(
                  "Crime Report",
                  'File a crime report anywhere, anytime with ease!',
                  '/crimeReport',
                  Icons.local_police_outlined),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              homepageButton(
                  "Awareness",
                  "Let's stand united against crime.Together, we can make a difference!",
                  '/awareness',
                  Icons.remove_red_eye_outlined),
              homepageButton(
                  "Emergency Officials",
                  'Easy access to Emergency officials such as their locations,numbers and much more!',
                  '/emergency Official',
                  Icons.contact_emergency_sharp)
            ],
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(
        defaultSelectedIndex: 2,
      ),
    );
  }

  Widget homepageButton(
      String text, String info, String routeName, IconData icon) {
    return GestureDetector(
      child: Container(
          width: 180,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.red.shade800.withOpacity(0.2), // border color
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 15, bottom: 15, right: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30, right: 5),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          iconDesign(icon),
                        ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  text,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  width: 155,
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text(
                                    info,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade700),
                                  ),
                                )
                              ]),
                        ]),
                  ),
                ]),
          )),
      onTap: () async {
        Navigator.of(context).pushNamed(routeName);
      },
    );
  }

  Widget iconDesign(IconData icon) {
    return Container(
      width: 55,
      height: 55,
      decoration: const BoxDecoration(
        color: Colors.white, // border color
        borderRadius: BorderRadius.all(Radius.circular(40.0)),
      ),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(icon, size: 40, color: Colors.red.shade900)]),
    );
  }
}
