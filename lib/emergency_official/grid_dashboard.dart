import 'package:crimereporting_and_preventionsystem/emergency_official/ambulance.dart';
import 'package:crimereporting_and_preventionsystem/emergency_official/firefighter_option.dart';
import 'package:crimereporting_and_preventionsystem/emergency_official/hospital_option.dart';
import 'package:crimereporting_and_preventionsystem/emergency_official/police_option.dart';
import 'package:crimereporting_and_preventionsystem/utils/bottom_navbar.dart';
import 'package:crimereporting_and_preventionsystem/utils/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class GridDashboard extends StatefulWidget {
  const GridDashboard({super.key});

  @override
  State<GridDashboard> createState() => _GridDashboardState();
}

class _GridDashboardState extends State<GridDashboard> {
  Items item1 = Items(
      title: "Police",
      subtitle: "Emergency Police ",
      event: "",
      img: "assets/policeman.png");

  Items item2 = Items(
    title: "Fire Brigade",
    subtitle: "Emergency Fire Brigade",
    event: "",
    img: "assets/fire-truck.png",
  );

  Items item3 = Items(
    title: "Ambulance",
    subtitle: "Emergency Ambulance",
    event: "",
    img: "assets/ambulance.png",
  );

  Items item4 = Items(
    title: "Hospitals",
    subtitle: "Emergency Hospitals",
    event: "",
    img: "assets/hospital.png",
  );

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item2, item3, item4];
    return Scaffold(
      appBar: customAppBar(title: "Emergency Officials"),
      body: GridView.count(
          childAspectRatio: 1.0,
          padding: const EdgeInsets.only(left: 6, right: 6, top: 150),
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: myList.map((data) {
            return GestureDetector(
              onTap: () {
                if (data.title == "Police") {
                  Get.to(() => const PoliceOptions());
                } else if (data.title == "Fire Brigade") {
                  Get.to(() => const FireFighterOptions());
                } else if (data.title == "Ambulance") {
                  Get.to(() => const AmbulanceOptions());
                } else if (data.title == "Hospitals") {
                  Get.to(() => const HospitalOptions());
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.red.shade600.withOpacity(.8),
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      child: Image.asset(
                        data.img,
                        width: 42,
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Text(
                      data.title,
                      style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      data.subtitle,
                      style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Text(
                      data.event,
                      style: GoogleFonts.openSans(
                          textStyle: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            );
          }).toList()),
      bottomNavigationBar:
          const CustomBottomNavigationBar(defaultSelectedIndex: 4),
    );
  }
}

class Items {
  String title;
  String subtitle;
  String event;
  String img;
  Items(
      {required this.title,
      required this.subtitle,
      required this.event,
      required this.img});
}
